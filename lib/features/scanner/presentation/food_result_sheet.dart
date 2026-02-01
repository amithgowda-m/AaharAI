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
  // ✅ STORE ALL DETECTED ITEMS
  List<Map<String, dynamic>> allItems = [];
  int selectedIndex = 0; // Which tab is active

  String selectedMealType = 'Breakfast';
  bool isLoadingAI = false;
  bool isSaving = false;
  String? aiSuggestion;

  final List<String> mealTypes = [
    'Breakfast', 'Morning Snack', 'Lunch', 'Evening Snack', 'Dinner', 'Late Night Snack'
  ];

  @override
  void initState() {
    super.initState();
    final rawItems = widget.data['items'] as List<dynamic>? ?? [];
    
    // Initialize local state for EACH item
    if (rawItems.isNotEmpty) {
      for (var item in rawItems) {
        final map = Map<String, dynamic>.from(item);
        map['local_portion_multiplier'] = 1.0;
        map['local_item_count'] = 1;
        map['local_modifiers'] = <ModifierItem>[]; 
        allItems.add(map);
      }
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

  // --- HELPERS FOR CURRENTLY SELECTED ITEM ---
  Map<String, dynamic> get currentItem => allItems[selectedIndex];
  
  double get currentMultiplier => currentItem['local_portion_multiplier'];
  set currentMultiplier(double v) => currentItem['local_portion_multiplier'] = v;

  int get currentCount => currentItem['local_item_count'];
  set currentCount(int v) => currentItem['local_item_count'] = v;

  List<ModifierItem> get currentModifiers => currentItem['local_modifiers'];
  set currentModifiers(List<ModifierItem> v) => currentItem['local_modifiers'] = v;

  // --- CALCULATIONS ---
  double _getAdjustedValue(num? value) {
    if (value == null) return 0;
    return value * currentMultiplier * currentCount;
  }

  // Calculate calories for a SPECIFIC item map (used for totals)
  double _calculateItemCalories(Map<String, dynamic> item) {
    double base = (item['calories'] ?? 0) * (item['local_portion_multiplier'] ?? 1.0) * (item['local_item_count'] ?? 1);
    List<ModifierItem> mods = item['local_modifiers'] ?? [];
    double modCals = mods.fold(0.0, (sum, mod) => sum + (mod.calories * mod.quantity));
    return base + modCals;
  }

  // Current Item Macros
  double _getCurrentCalories() => _calculateItemCalories(currentItem);
  double _getCurrentProtein() => _getAdjustedValue(currentItem['protein']) + currentModifiers.fold(0, (s, m) => s + m.protein * m.quantity);
  double _getCurrentCarbs() => _getAdjustedValue(currentItem['carbs']) + currentModifiers.fold(0, (s, m) => s + m.carbs * m.quantity);
  double _getCurrentFat() => _getAdjustedValue(currentItem['fat']) + currentModifiers.fold(0, (s, m) => s + m.fat * m.quantity);

  // Whole Meal Total
  double _getWholeMealCalories() {
    return allItems.fold(0.0, (sum, item) => sum + _calculateItemCalories(item));
  }

  // --- DELETE ITEM LOGIC ---
  void _deleteCurrentItem() {
    setState(() {
      allItems.removeAt(selectedIndex);
      // Adjust selection index if needed
      if (selectedIndex >= allItems.length) {
        selectedIndex = allItems.length - 1;
      }
      if (selectedIndex < 0) selectedIndex = 0;
    });
  }

  // --- RENAME ITEM LOGIC ---
  void _renameCurrentItem() {
    TextEditingController controller = TextEditingController(text: currentItem['name']);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Rename Item"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Enter new name"),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  currentItem['name'] = controller.text;
                });
              }
              Navigator.pop(context);
            },
            child: const Text("Save", style: TextStyle(color: Color(0xFF2E7D32))),
          ),
        ],
      ),
    );
  }

  // --- AI CHAT LOGIC ---
  Future<void> _askNutria() async {
    setState(() => isLoadingAI = true);
    final nutriaService = NutriaService();
    
    String mealSummary = allItems.map((i) => "${i['name']} (${_calculateItemCalories(i).toInt()} kcal)").join(", ");

    final String prompt = """
    I am eating a meal consisting of: $mealSummary.
    Total Calories: ${_getWholeMealCalories().toInt()}.
    Meal Type: $selectedMealType.
    Is this combination balanced? Suggest 1 improvement.
    """;

    final suggestion = await nutriaService.getChatResponse(message: prompt, history: []);
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
                        Text('Meal Analysis', style: TextStyle(fontSize: 12, color: Colors.grey)),
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
                    aiSuggestion ?? 'Analyzing full meal...',
                    style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
                  ),
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
            currentItem['local_modifiers'] = selectedModifiers;
          });
        },
        currentModifiers: currentItem['local_modifiers'],
      ),
    );
  }

  Future<void> _saveAllItems() async {
    setState(() => isSaving = true);
    try {
      final currentUser = AuthService.getCurrentUser();
      if (currentUser == null) throw Exception('Not logged in');

      final isarService = ref.read(isarProvider);

      for (var item in allItems) {
        double mult = item['local_portion_multiplier'];
        int count = item['local_item_count'];
        List<ModifierItem> mods = item['local_modifiers'];

        double adj(key) => ((item[key] ?? 0) * mult * count).toDouble();

        double modCal = mods.fold(0, (s, m) => s + m.calories * m.quantity);
        double modProt = mods.fold(0, (s, m) => s + m.protein * m.quantity);
        double modCarbs = mods.fold(0, (s, m) => s + m.carbs * m.quantity);
        double modFat = mods.fold(0, (s, m) => s + m.fat * m.quantity);
        List<String> modNames = mods.map((m) => "${m.name} x${m.quantity}").toList();

        final foodLog = FoodLog()
          ..userId = currentUser.id
          ..foodName = item['name']
          ..mealType = selectedMealType
          ..calories = (item['calories'] ?? 0).toDouble()
          ..protein = (item['protein'] ?? 0).toDouble()
          ..carbs = (item['carbs'] ?? 0).toDouble()
          ..fat = (item['fat'] ?? 0).toDouble()
          ..fiber = (item['fiber'] ?? 0).toDouble()
          ..sugar = (item['sugar'] ?? 0).toDouble()
          ..sodium = (item['sodium'] ?? 0).toDouble()
          ..cholesterol = (item['cholesterol'] ?? 0).toDouble()
          ..iron = (item['iron'] ?? 0).toDouble()
          ..potassium = (item['potassium'] ?? 0).toDouble()
          ..portionSize = mult
          ..itemCount = count.toDouble()
          ..totalCalories = adj('calories') + modCal
          ..totalProtein = adj('protein') + modProt
          ..totalCarbs = adj('carbs') + modCarbs
          ..totalFat = adj('fat') + modFat
          ..totalFiber = adj('fiber')
          ..modifiers = modNames
          ..modifierCalories = modCal
          ..modifierProtein = modProt
          ..modifierCarbs = modCarbs
          ..modifierFat = modFat
          ..imagePath = widget.imagePath
          ..timestamp = DateTime.now()
          ..isSynced = false;

        await isarService.addFoodLog(foodLog);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('✅ Logged ${allItems.length} items!'), backgroundColor: const Color(0xFF2E7D32)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Handle empty state (if user deletes all items)
    if (allItems.isEmpty) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.5,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 20),
              width: 40, height: 4,
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
            ),
            const Icon(Icons.remove_shopping_cart_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('No items left to log', style: TextStyle(fontSize: 18, color: Colors.grey)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Close'),
              ),
            )
          ],
        ),
      );
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40, height: 4,
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
          ),
          
          // --- HEADER: MEAL TYPE & TOTAL ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                // Meal Type
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E7D32).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: DropdownButton<String>(
                    value: selectedMealType,
                    underline: const SizedBox(),
                    isDense: true,
                    icon: const Icon(Icons.keyboard_arrow_down, size: 18, color: Color(0xFF2E7D32)),
                    items: mealTypes.map((type) => DropdownMenuItem(
                      value: type, 
                      child: Text(type, style: const TextStyle(color: Color(0xFF2E7D32), fontWeight: FontWeight.bold, fontSize: 13))
                    )).toList(),
                    onChanged: (value) => setState(() => selectedMealType = value!),
                  ),
                ),
                const Spacer(),
                // Total Summary
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text("MEAL TOTAL", style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                    Text(
                      "${_getWholeMealCalories().toInt()} kcal", 
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF2E7D32))
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // --- HORIZONTAL ITEM SELECTOR ---
          Container(
            height: 50,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: allItems.length,
              separatorBuilder: (c, i) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final isSelected = index == selectedIndex;
                return ChoiceChip(
                  label: Text(allItems[index]['name'] ?? 'Item ${index + 1}'),
                  selected: isSelected,
                  onSelected: (bool selected) {
                    setState(() => selectedIndex = index);
                  },
                  selectedColor: const Color(0xFF2E7D32),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                  backgroundColor: Colors.grey[100],
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                );
              },
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- ITEM HEADER (Name & Actions) ---
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: _renameCurrentItem, // Tap to rename
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  currentItem['name'] ?? 'Unknown',
                                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.edit, size: 18, color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                      // DELETE BUTTON
                      IconButton(
                        onPressed: _deleteCurrentItem,
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        tooltip: "Remove Item",
                      ),
                    ],
                  ),

                  // AI Volume Info
                  if (currentItem['portion_desc'] != null)
                    Container(
                      margin: const EdgeInsets.only(top: 4, bottom: 16),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.purple.withOpacity(0.2)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.analytics_outlined, size: 14, color: Colors.purple),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              "AI Detected: ${currentItem['portion_desc']} (~${currentItem['estimated_weight_g'] ?? '?'}g)",
                              style: const TextStyle(fontSize: 12, color: Colors.purple, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Item Calories
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
                        const Text('Item Calories', style: TextStyle(fontSize: 16, color: Colors.grey)),
                        const Spacer(),
                        Text(
                          '${_getCurrentCalories().toInt()}',
                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Portion Slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Portion Size: ${currentMultiplier.toStringAsFixed(1)}x', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      // Item Count Stepper inside Portion Row
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 16),
                              onPressed: () {
                                if (currentCount > 1) setState(() => currentCount--);
                              },
                              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                              padding: EdgeInsets.zero,
                            ),
                            Text('$currentCount', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                            IconButton(
                              icon: const Icon(Icons.add, size: 16),
                              onPressed: () => setState(() => currentCount++),
                              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                              padding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: currentMultiplier,
                    min: 0.5,
                    max: 3.0,
                    divisions: 10,
                    activeColor: const Color(0xFF2E7D32),
                    label: '${currentMultiplier.toStringAsFixed(1)}x',
                    onChanged: (value) => setState(() => currentMultiplier = value),
                  ),

                  const SizedBox(height: 20),

                  // Macros Grid
                  Row(
                    children: [
                      Expanded(child: _buildMacroCard('Protein', _getCurrentProtein(), Colors.red[100]!, Icons.egg_outlined)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildMacroCard('Carbs', _getCurrentCarbs(), Colors.orange[100]!, Icons.grain)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildMacroCard('Fat', _getCurrentFat(), Colors.blue[100]!, Icons.water_drop_outlined)),
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
                              const Icon(Icons.list, color: Colors.grey),
                              const SizedBox(height: 8),
                              const Text('Item Index', style: TextStyle(fontSize: 12, color: Colors.grey)),
                              const SizedBox(height: 4),
                              Text('${selectedIndex + 1}/${allItems.length}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Modifiers Section
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
                  if (currentModifiers.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
                      child: Column(children: currentModifiers.map((mod) => _buildModifierRow(mod)).toList()),
                    )
                  else
                    const Text('No modifiers added', style: TextStyle(color: Colors.grey, fontSize: 14)),

                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: isLoadingAI ? null : _askNutria,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: Color(0xFF2E7D32), width: 2),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: isLoadingAI
                              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                              : const Text('Analyze Full Meal', style: TextStyle(fontSize: 16, color: Color(0xFF2E7D32))),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: isSaving ? null : _saveAllItems,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E7D32),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: isSaving
                              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : Text('Log All (${allItems.length})', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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

  Widget _buildModifierRow(ModifierItem mod) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.add_circle_outline, size: 20, color: Color(0xFF2E7D32)),
          const SizedBox(width: 8),
          Expanded(child: Text("${mod.name} (x${mod.quantity})", style: const TextStyle(fontSize: 14))),
          Text('+${(mod.calories * mod.quantity).toInt()} cal', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.orange)),
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: () => setState(() => currentModifiers.remove(mod)),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroCard(String label, double value, Color bgColor, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
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

// ... (Keep ModifierItem and ModifierSelector classes here)
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
                              Text('$qty', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2E7D32))),
                              IconButton(
                                icon: const Icon(Icons.add, size: 18, color: Color(0xFF2E7D32)),
                                onPressed: () => setState(() => selections[item.name] = qty + 1),
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