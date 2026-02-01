// lib/features/scanner/presentation/food_result_sheet.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/local/isar_service.dart';
import '../../../data/local/entities/food_log.dart';
import 'package:aahar_ai/services/nutria_service.dart';
import '../../../services/auth_service.dart';

class FoodResultSheet extends ConsumerStatefulWidget {
  final Map<String, dynamic> data;
  final String imagePath;

  const FoodResultSheet({
    super.key,
    required this.data,
    required this.imagePath,
  });

  @override
  ConsumerState<FoodResultSheet> createState() => _FoodResultSheetState();
}

class _FoodResultSheetState extends ConsumerState<FoodResultSheet> {
  late Map<String, dynamic> currentItem;
  double portionMultiplier = 1.0;
  int itemCount = 1;
  String selectedMealType = 'Breakfast';
  List<ModifierItem> modifiers = []; // Items with quantity
  bool isLoadingAI = false;
  bool isSaving = false;
  String? aiSuggestion;

  final List<String> mealTypes = [
    'Breakfast', 'Morning Snack', 'Lunch', 'Evening Snack', 'Dinner', 'Late Night Snack'
  ];

  @override
  void initState() {
    super.initState();
    final items = widget.data['items'] as List<dynamic>? ?? [];
    if (items.isNotEmpty) {
      currentItem = Map<String, dynamic>.from(items[0]);
    }
    _getMealTypeFromTime();
  }

  void _getMealTypeFromTime() {
    final hour = DateTime.now().hour;
    if (hour >= 6 && hour < 10) selectedMealType = 'Breakfast';
    else if (hour >= 10 && hour < 12) selectedMealType = 'Morning Snack';
    else if (hour >= 12 && hour < 16) selectedMealType = 'Lunch';
    else if (hour >= 16 && hour < 19) selectedMealType = 'Evening Snack';
    else if (hour >= 19 && hour < 22) selectedMealType = 'Dinner';
    else selectedMealType = 'Late Night Snack';
  }

  double _getAdjustedValue(num? value) {
    if (value == null) return 0;
    return value * portionMultiplier * itemCount;
  }

  // --- CALCULATION LOGIC (Includes Modifiers) ---
  double _getTotalCalories() {
    final base = _getAdjustedValue(currentItem['calories']);
    final mods = modifiers.fold(0.0, (sum, mod) => sum + (mod.calories * mod.quantity));
    return base + mods;
  }

  double _getTotalProtein() {
    final base = _getAdjustedValue(currentItem['protein']);
    final mods = modifiers.fold(0.0, (sum, mod) => sum + (mod.protein * mod.quantity));
    return base + mods;
  }

  double _getTotalCarbs() {
    final base = _getAdjustedValue(currentItem['carbs']);
    final mods = modifiers.fold(0.0, (sum, mod) => sum + (mod.carbs * mod.quantity));
    return base + mods;
  }

  double _getTotalFat() {
    final base = _getAdjustedValue(currentItem['fat']);
    final mods = modifiers.fold(0.0, (sum, mod) => sum + (mod.fat * mod.quantity));
    return base + mods;
  }

  // --- AI CHAT LOGIC ---
  Future<void> _askNutria() async {
    setState(() => isLoadingAI = true);

    final nutriaService = NutriaService();
    
    // Detailed prompt for actionable advice
    final String prompt = """
    I am eating ${currentItem['name']} for $selectedMealType.
    Total: ${_getTotalCalories().toInt()} kcal, ${_getTotalProtein().toInt()}g Protein, ${_getTotalCarbs().toInt()}g Carbs.
    Is this balanced? Suggest 1 small change to improve it. Keep it under 2 sentences.
    """;

    final suggestion = await nutriaService.getChatResponse(
      message: prompt,
      history: [], 
    );

    setState(() {
      aiSuggestion = suggestion;
      isLoadingAI = false;
    });

    _showNutriaDialog();
  }

  void _showNutriaDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32).withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Color(0xFF2E7D32),
                    child: Icon(Icons.auto_awesome, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nutira AI', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('Smart Suggestion', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  child: Text(
                    aiSuggestion ?? 'Analyzing meal balance...',
                    style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Got it!'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showModifierDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) => ModifierSelector(
        onModifiersSelected: (selectedModifiers) {
          setState(() {
            modifiers = selectedModifiers;
          });
        },
        currentModifiers: modifiers,
      ),
    );
  }

  Future<void> _saveMeal() async {
    setState(() => isSaving = true);
    try {
      final currentUser = AuthService.getCurrentUser();
      if (currentUser == null) throw Exception('Not logged in');

      final isarService = ref.read(isarProvider);

      double modCal = 0, modProt = 0, modCarbs = 0, modFat = 0;
      List<String> modNames = [];
      
      for (var mod in modifiers) {
        double qty = mod.quantity.toDouble();
        modCal += mod.calories * qty;
        modProt += mod.protein * qty;
        modCarbs += mod.carbs * qty;
        modFat += mod.fat * qty;
        modNames.add("${mod.name} x${mod.quantity}");
      }

      final foodLog = FoodLog()
        ..userId = currentUser.id
        ..foodName = currentItem['name']
        ..mealType = selectedMealType
        ..calories = (currentItem['calories'] ?? 0).toDouble()
        ..protein = (currentItem['protein'] ?? 0).toDouble()
        ..carbs = (currentItem['carbs'] ?? 0).toDouble()
        ..fat = (currentItem['fat'] ?? 0).toDouble()
        ..fiber = (currentItem['fiber'] ?? 0).toDouble()
        ..sugar = (currentItem['sugar'] ?? 0).toDouble()
        ..sodium = (currentItem['sodium'] ?? 0).toDouble()
        ..cholesterol = (currentItem['cholesterol'] ?? 0).toDouble()
        ..iron = (currentItem['iron'] ?? 0).toDouble()
        ..potassium = (currentItem['potassium'] ?? 0).toDouble()
        ..portionSize = portionMultiplier
        ..itemCount = itemCount.toDouble()
        ..totalCalories = _getTotalCalories()
        ..totalProtein = _getTotalProtein()
        ..totalCarbs = _getTotalCarbs()
        ..totalFat = _getTotalFat()
        ..totalFiber = _getAdjustedValue(currentItem['fiber'])
        ..modifiers = modNames
        ..modifierCalories = modCal
        ..modifierProtein = modProt
        ..modifierCarbs = modCarbs
        ..modifierFat = modFat
        ..imagePath = widget.imagePath
        ..timestamp = DateTime.now()
        ..isSynced = false;

      await isarService.addFoodLog(foodLog);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Meal logged successfully!'),
            backgroundColor: Color(0xFF2E7D32),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.data['items'] as List<dynamic>? ?? [];
    if (items.isEmpty) {
      return Container(padding: const EdgeInsets.all(20), child: const Text('No food detected'));
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag Handle
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40, height: 4,
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- MEAL TYPE SELECTOR ---
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E7D32).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: DropdownButton<String>(
                      value: selectedMealType,
                      underline: const SizedBox(),
                      icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF2E7D32)),
                      items: mealTypes.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type, style: const TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.w600)),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => selectedMealType = value!),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // --- FOOD NAME & COUNT ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          currentItem['name'] ?? 'Unknown',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 20),
                              onPressed: () {
                                if (itemCount > 1) setState(() => itemCount--);
                              },
                            ),
                            Text('$itemCount', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            IconButton(
                              icon: const Icon(Icons.add, size: 20),
                              onPressed: () => setState(() => itemCount++),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // --- TOTAL CALORIES CARD ---
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.local_fire_department, color: Colors.orange, size: 32),
                        const SizedBox(width: 12),
                        const Text('Total Calories', style: TextStyle(fontSize: 16, color: Colors.grey)),
                        const Spacer(),
                        Text(
                          '${_getTotalCalories().toInt()}',
                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // --- PORTION SLIDER ---
                  Text('Portion Size: ${portionMultiplier.toStringAsFixed(1)}x', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  Slider(
                    value: portionMultiplier,
                    min: 0.5,
                    max: 3.0,
                    divisions: 10,
                    activeColor: const Color(0xFF2E7D32),
                    label: '${portionMultiplier.toStringAsFixed(1)}x',
                    onChanged: (value) => setState(() => portionMultiplier = value),
                  ),

                  const SizedBox(height: 20),

                  // --- MACROS GRID ---
                  Row(
                    children: [
                      Expanded(child: _buildMacroCard('Protein', _getTotalProtein(), Colors.red[100]!, Icons.egg_outlined)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildMacroCard('Carbs', _getTotalCarbs(), Colors.orange[100]!, Icons.grain)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildMacroCard('Fat', _getTotalFat(), Colors.blue[100]!, Icons.water_drop_outlined)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.restaurant, color: Colors.grey[600]),
                              const SizedBox(height: 8),
                              const Text('Items', style: TextStyle(fontSize: 12, color: Colors.grey)),
                              const SizedBox(height: 4),
                              Text('$itemCount', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // --- MODIFIERS SECTION ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Modifiers', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      TextButton.icon(
                        onPressed: _showModifierDialog,
                        icon: const Icon(Icons.add, color: Color(0xFF2E7D32)),
                        label: const Text('Add', style: TextStyle(color: Color(0xFF2E7D32))),
                      ),
                    ],
                  ),
                  if (modifiers.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: modifiers.map((mod) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                const Icon(Icons.add_circle_outline, size: 20, color: Color(0xFF2E7D32)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text("${mod.name} (x${mod.quantity})", style: const TextStyle(fontSize: 14)),
                                ),
                                Text(
                                  '+${(mod.calories * mod.quantity).toInt()} cal',
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.orange),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close, size: 18),
                                  onPressed: () => setState(() => modifiers.remove(mod)),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  else
                    const Text('No modifiers added', style: TextStyle(color: Colors.grey, fontSize: 14)),

                  const SizedBox(height: 24),

                  // --- ASK NUTRIA ---
                  OutlinedButton.icon(
                    onPressed: isLoadingAI ? null : _askNutria,
                    icon: isLoadingAI
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.auto_awesome, color: Color(0xFF2E7D32)),
                    label: const Text('Ask Nutira for advice', style: TextStyle(fontSize: 16, color: Color(0xFF2E7D32))),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Color(0xFF2E7D32), width: 2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // --- ACTION BUTTONS ---
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: Colors.grey[400]!),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Cancel', style: TextStyle(fontSize: 16, color: Colors.black87)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: isSaving ? null : _saveMeal,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E7D32),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: isSaving
                              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : const Text('Log Meal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroCard(String label, double value, Color bgColor, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.black54, size: 28),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          Text('${value.toInt()}g', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// IMPROVED MODIFIER SELECTOR (Supports Quantity + / -)
// ---------------------------------------------------------

class ModifierItem {
  final String name;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  int quantity; 

  ModifierItem({
    required this.name,
    required this.calories,
    this.protein = 0,
    this.carbs = 0,
    this.fat = 0,
    this.quantity = 1,
  });
}

class ModifierSelector extends StatefulWidget {
  final Function(List<ModifierItem>) onModifiersSelected;
  final List<ModifierItem> currentModifiers;

  const ModifierSelector({
    super.key,
    required this.onModifiersSelected,
    required this.currentModifiers,
  });

  @override
  State<ModifierSelector> createState() => _ModifierSelectorState();
}

class _ModifierSelectorState extends State<ModifierSelector> {
  // Base list of options
  final List<ModifierItem> commonModifiers = [
    ModifierItem(name: 'Ghee (1 tsp)', calories: 45, fat: 5),
    ModifierItem(name: 'Oil (1 tsp)', calories: 40, fat: 4.5),
    ModifierItem(name: 'Butter (1 tsp)', calories: 36, fat: 4),
    ModifierItem(name: 'Cheese Slice', calories: 113, protein: 7, fat: 9),
    ModifierItem(name: 'Sugar (1 tsp)', calories: 16, carbs: 4),
    ModifierItem(name: 'Honey (1 tsp)', calories: 21, carbs: 6),
    ModifierItem(name: 'Ketchup (1 tbsp)', calories: 20, carbs: 5),
    ModifierItem(name: 'Mayonnaise (1 tbsp)', calories: 90, fat: 10),
  ];

  final Map<String, int> selections = {};

  @override
  void initState() {
    super.initState();
    for (var mod in widget.currentModifiers) {
      selections[mod.name] = mod.quantity;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Add Extras', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
            ],
          ),
          const SizedBox(height: 8),
          const Text('Adjust quantities for toppings & cooking fats', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),
          
          Expanded(
            child: ListView.separated(
              itemCount: commonModifiers.length,
              separatorBuilder: (c, i) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = commonModifiers[index];
                final qty = selections[item.name] ?? 0;
                
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                            Text('${item.calories.toInt()} cal', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ),
                      
                      // Quantity Controls
                      if (qty == 0)
                        OutlinedButton(
                          onPressed: () => setState(() => selections[item.name] = 1),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF2E7D32),
                            side: const BorderSide(color: Color(0xFF2E7D32)),
                          ),
                          child: const Text("ADD"),
                        )
                      else
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E7D32).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove, size: 18, color: Color(0xFF2E7D32)),
                                onPressed: () {
                                  setState(() {
                                    if (qty > 0) selections[item.name] = qty - 1;
                                    if (selections[item.name] == 0) selections.remove(item.name);
                                  });
                                },
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                              ),
                              Text(
                                '$qty',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2E7D32)),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add, size: 18, color: Color(0xFF2E7D32)),
                                onPressed: () {
                                  setState(() => selections[item.name] = qty + 1);
                                },
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: 16),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                List<ModifierItem> result = [];
                selections.forEach((name, qty) {
                  if (qty > 0) {
                    final original = commonModifiers.firstWhere((m) => m.name == name);
                    result.add(ModifierItem(
                      name: original.name,
                      calories: original.calories,
                      protein: original.protein,
                      carbs: original.carbs,
                      fat: original.fat,
                      quantity: qty,
                    ));
                  }
                });
                
                widget.onModifiersSelected(result);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                'Done (${selections.length} items)',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}