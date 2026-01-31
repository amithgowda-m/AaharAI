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
  List<ModifierItem> modifiers = [];
  bool isLoadingAI = false;
  bool isSaving = false;
  String? aiSuggestion;

  final List<String> mealTypes = [
    'Breakfast',
    'Morning Snack',
    'Lunch',
    'Evening Snack',
    'Dinner',
    'Late Night Snack'
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
    if (hour >= 6 && hour < 10) {
      selectedMealType = 'Breakfast';
    } else if (hour >= 10 && hour < 12) {
      selectedMealType = 'Morning Snack';
    } else if (hour >= 12 && hour < 16) {
      selectedMealType = 'Lunch';
    } else if (hour >= 16 && hour < 19) {
      selectedMealType = 'Evening Snack';
    } else if (hour >= 19 && hour < 22) {
      selectedMealType = 'Dinner';
    } else {
      selectedMealType = 'Late Night Snack';
    }
  }

  double _getAdjustedValue(num? value) {
    if (value == null) return 0;
    return value * portionMultiplier * itemCount;
  }

  double _getTotalCalories() {
    final baseCalories = _getAdjustedValue(currentItem['calories']);
    final modifierCalories = modifiers.fold(0.0, (sum, mod) => sum + mod.calories);
    return baseCalories + modifierCalories;
  }

  double _getTotalProtein() {
    final baseProtein = _getAdjustedValue(currentItem['protein']);
    final modifierProtein = modifiers.fold(0.0, (sum, mod) => sum + mod.protein);
    return baseProtein + modifierProtein;
  }

  double _getTotalCarbs() {
    final baseCarbs = _getAdjustedValue(currentItem['carbs']);
    final modifierCarbs = modifiers.fold(0.0, (sum, mod) => sum + mod.carbs);
    return baseCarbs + modifierCarbs;
  }

  double _getTotalFat() {
    final baseFat = _getAdjustedValue(currentItem['fat']);
    final modifierFat = modifiers.fold(0.0, (sum, mod) => sum + mod.fat);
    return baseFat + modifierFat;
  }

  Future<void> _askNutria() async {
    setState(() => isLoadingAI = true);

    final nutriaService = NutriaService();
    final suggestion = await nutriaService.getMealSuggestions(
      currentMealType: selectedMealType,
      currentFood: currentItem['name'],
      calories: _getTotalCalories(),
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
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFF2E7D32).withOpacity(0.1),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xFF2E7D32),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.auto_awesome, color: Colors.white, size: 28),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nutira AI Assistant',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Your personal nutrition guide',
                          style: TextStyle(color: Colors.grey[600], fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            
            // AI Response
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Text(
                  aiSuggestion ?? 'Getting suggestions...',
                  style: TextStyle(fontSize: 16, height: 1.6),
                ),
              ),
            ),
            
            // Action Buttons
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _showModifierDialog();
                      },
                      icon: Icon(Icons.add),
                      label: Text('Add Modifiers'),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2E7D32),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text('Got it!'),
                    ),
                  ),
                ],
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
      if (currentUser == null) {
        throw Exception('Not logged in');
      }

      final isarService = ref.read(isarProvider);

      // Calculate modifier totals
      double modCalories = 0, modProtein = 0, modCarbs = 0, modFat = 0;
      for (var mod in modifiers) {
        modCalories += mod.calories;
        modProtein += mod.protein;
        modCarbs += mod.carbs;
        modFat += mod.fat;
      }

      final foodLog = FoodLog()
        ..userId = currentUser.id
        ..foodName = currentItem['name']
        ..mealType = selectedMealType
        
        // --- 1. MACROS (With Safe Defaults) ---
        ..calories = (currentItem['calories'] ?? 0).toDouble()
        ..protein = (currentItem['protein'] ?? 0).toDouble()
        ..carbs = (currentItem['carbs'] ?? 0).toDouble()
        ..fat = (currentItem['fat'] ?? 0).toDouble()
        ..fiber = (currentItem['fiber'] ?? 0).toDouble()
        
        // --- 2. MICRONUTRIENTS (Professional Data) ---
        ..sugar = (currentItem['sugar'] ?? 0).toDouble()
        ..sodium = (currentItem['sodium'] ?? 0).toDouble()
        ..cholesterol = (currentItem['cholesterol'] ?? 0).toDouble()
        ..iron = (currentItem['iron'] ?? 0).toDouble()
        ..potassium = (currentItem['potassium'] ?? 0).toDouble()

        // --- 3. QUANTITY ---
        ..portionSize = portionMultiplier
        ..itemCount = itemCount.toDouble()

        // --- 4. CALCULATED TOTALS (Base * Qty + Modifiers) ---
        ..totalCalories = _getTotalCalories()
        ..totalProtein = _getTotalProtein()
        ..totalCarbs = _getTotalCarbs()
        ..totalFat = _getTotalFat()
        ..totalFiber = _getAdjustedValue(currentItem['fiber'])

        // --- 5. MODIFIERS & METADATA ---
        ..modifiers = modifiers.map((m) => m.name).toList()
        ..modifierCalories = modCalories
        ..modifierProtein = modProtein
        ..modifierCarbs = modCarbs
        ..modifierFat = modFat
        ..imagePath = widget.imagePath
        ..timestamp = DateTime.now()
        ..isSynced = false;

      await isarService.addFoodLog(foodLog);

      if (mounted) {
        Navigator.pop(context); // Close result sheet
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ ${currentItem['name']} logged successfully!'),
            backgroundColor: Color(0xFF2E7D32),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
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
      return Container(
        padding: EdgeInsets.all(20),
        child: Text('No food detected'),
      );
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag Handle
          Container(
            margin: EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Meal Type Selector
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Color(0xFF2E7D32).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: DropdownButton<String>(
                      value: selectedMealType,
                      underline: SizedBox(),
                      icon: Icon(Icons.keyboard_arrow_down, color: Color(0xFF2E7D32)),
                      items: mealTypes.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(
                            type,
                            style: TextStyle(
                              color: Color(0xFF2E7D32),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => selectedMealType = value!);
                      },
                    ),
                  ),

                  SizedBox(height: 20),

                  // Food Name and Count
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          currentItem['name'] ?? 'Unknown',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
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
                              icon: Icon(Icons.remove, size: 20),
                              onPressed: () {
                                if (itemCount > 1) {
                                  setState(() => itemCount--);
                                }
                              },
                            ),
                            Text(
                              '$itemCount',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.add, size: 20),
                              onPressed: () {
                                setState(() => itemCount++);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // Total Calories Card
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.local_fire_department, color: Colors.orange, size: 32),
                        SizedBox(width: 12),
                        Text(
                          'Total Calories',
                          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                        Spacer(),
                        Text(
                          '${_getTotalCalories().toInt()}',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  // Portion Size Slider
                  Text(
                    'Portion Size: ${portionMultiplier.toStringAsFixed(1)}x',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Slider(
                    value: portionMultiplier,
                    min: 0.5,
                    max: 3.0,
                    divisions: 10,
                    activeColor: Color(0xFF2E7D32),
                    label: '${portionMultiplier.toStringAsFixed(1)}x',
                    onChanged: (value) {
                      setState(() => portionMultiplier = value);
                    },
                  ),

                  SizedBox(height: 20),

                  // Macros Grid
                  Row(
                    children: [
                      Expanded(
                        child: _buildMacroCard(
                          'Protein',
                          _getTotalProtein(),
                          Colors.red[100]!,
                          Icons.egg_outlined,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildMacroCard(
                          'Carbs',
                          _getTotalCarbs(),
                          Colors.orange[100]!,
                          Icons.grain,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildMacroCard(
                          'Fat',
                          _getTotalFat(),
                          Colors.blue[100]!,
                          Icons.water_drop_outlined,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.restaurant, color: Colors.grey[600]),
                              SizedBox(height: 8),
                              Text(
                                'Items',
                                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '$itemCount',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 24),

                  // Modifiers Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Modifiers',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextButton.icon(
                        onPressed: _showModifierDialog,
                        icon: Icon(Icons.add, color: Color(0xFF2E7D32)),
                        label: Text('Add', style: TextStyle(color: Color(0xFF2E7D32))),
                      ),
                    ],
                  ),
                  if (modifiers.isNotEmpty)
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: modifiers.map((mod) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Icon(Icons.add_circle_outline, size: 20, color: Color(0xFF2E7D32)),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    mod.name,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                                Text(
                                  '+${mod.calories.toInt()} cal',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.orange,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.close, size: 18),
                                  onPressed: () {
                                    setState(() => modifiers.remove(mod));
                                  },
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  else
                    Text(
                      'No modifiers added',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),

                  SizedBox(height: 24),

                  // Ask Nutira Button
                  OutlinedButton.icon(
                    onPressed: isLoadingAI ? null : _askNutria,
                    icon: isLoadingAI
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(Icons.auto_awesome, color: Color(0xFF2E7D32)),
                    label: Text(
                      'Ask Nutira what to add',
                      style: TextStyle(fontSize: 16, color: Color(0xFF2E7D32)),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: Color(0xFF2E7D32), width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: Colors.grey[400]!),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: isSaving ? null : _saveMeal,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF2E7D32),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: isSaving
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Log Meal',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
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
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.black54, size: 28),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
          ),
          SizedBox(height: 4),
          Text(
            '${value.toInt()}g',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// Modifier Item Model
class ModifierItem {
  final String name;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;

  ModifierItem({
    required this.name,
    required this.calories,
    this.protein = 0,
    this.carbs = 0,
    this.fat = 0,
  });
}

// Modifier Selector Widget
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
    ModifierItem(name: '1 tsp Ghee', calories: 45, fat: 5),
    ModifierItem(name: '1 tsp Oil', calories: 40, fat: 4.5),
    ModifierItem(name: '1 tsp Butter', calories: 36, fat: 4),
    ModifierItem(name: 'Extra Cheese (30g)', calories: 113, protein: 7, fat: 9),
    ModifierItem(name: '1 tsp Sugar', calories: 16, carbs: 4),
    ModifierItem(name: '1 tsp Honey', calories: 21, carbs: 6),
    ModifierItem(name: 'Fried', calories: 100, fat: 11),
    ModifierItem(name: 'Extra Spicy', calories: 0),
    ModifierItem(name: 'Less Salt', calories: 0),
  ];

  late List<ModifierItem> selectedModifiers;

  @override
  void initState() {
    super.initState();
    selectedModifiers = List.from(widget.currentModifiers);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Add Modifiers',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Select toppings or cooking methods',
            style: TextStyle(color: Colors.grey[600]),
          ),
          SizedBox(height: 20),
          
          Expanded(
            child: ListView.builder(
              itemCount: commonModifiers.length,
              itemBuilder: (context, index) {
                final modifier = commonModifiers[index];
                final isSelected = selectedModifiers.any((m) => m.name == modifier.name);
                
                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  child: CheckboxListTile(
                    value: isSelected,
                    activeColor: Color(0xFF2E7D32),
                    title: Text(
                      modifier.name,
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: modifier.calories > 0
                        ? Text('+${modifier.calories.toInt()} calories')
                        : null,
                    onChanged: (checked) {
                      setState(() {
                        if (checked == true) {
                          selectedModifiers.add(modifier);
                        } else {
                          selectedModifiers.removeWhere((m) => m.name == modifier.name);
                        }
                      });
                    },
                  ),
                );
              },
            ),
          ),
          
          SizedBox(height: 16),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onModifiersSelected(selectedModifiers);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Done (${selectedModifiers.length} selected)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}