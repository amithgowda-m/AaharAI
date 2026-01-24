import 'package:flutter/material.dart';
import '../../../../data/local/entities/food_log.dart';

class NutritionResultCard extends StatefulWidget {
  final FoodLog log;
  final VoidCallback onSave;

  const NutritionResultCard({
    super.key,
    required this.log,
    required this.onSave,
  });

  @override
  State<NutritionResultCard> createState() => _NutritionResultCardState();
}

class _NutritionResultCardState extends State<NutritionResultCard> {
  late String _mealType;
  late double _portionSize;

  @override
  void initState() {
    super.initState();
    _mealType = widget.log.mealType;
    _portionSize = widget.log.portionSize;
  }

  void _updateNutrition() {
    // total nutrition is handled in isar_service.addFoodLog, 
    // but we can update local display values if needed.
    setState(() {
      widget.log.mealType = _mealType;
      widget.log.portionSize = _portionSize;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.log.foodName,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              _buildHealthBadge(widget.log.healthScore),
            ],
          ),
          const SizedBox(height: 16),
          _buildMealTypeSelector(),
          const SizedBox(height: 24),
          _buildNutritionGrid(),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Retake'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: widget.onSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Log Meal', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHealthBadge(int score) {
    Color color = Colors.red;
    if (score >= 8) color = Colors.green;
    else if (score >= 5) color = Colors.orange;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            'Score: $score/10',
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildMealTypeSelector() {
    final types = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];
    return Wrap(
      spacing: 8,
      children: types.map((type) {
        final isSelected = _mealType == type;
        return ChoiceChip(
          label: Text(type),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              setState(() {
                _mealType = type;
                _updateNutrition();
              });
            }
          },
          selectedColor: const Color(0xFF2E7D32).withOpacity(0.2),
          labelStyle: TextStyle(
            color: isSelected ? const Color(0xFF2E7D32) : Colors.grey[600],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNutritionGrid() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMacroItem('Calories', '${widget.log.calories.toInt()}', 'kcal', Colors.orange),
              _buildMacroItem('Protein', '${widget.log.protein.toInt()}', 'g', Colors.red),
              _buildMacroItem('Carbs', '${widget.log.carbs.toInt()}', 'g', Colors.blue),
              _buildMacroItem('Fat', '${widget.log.fat.toInt()}', 'g', Colors.yellow[800]!),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroItem(String label, String value, String unit, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          unit,
          style: TextStyle(fontSize: 10, color: Colors.grey[400]),
        ),
        const SizedBox(height: 8),
        Container(
          width: 30,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }
}

