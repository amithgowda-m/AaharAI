// lib/features/scanner/presentation/widgets/nutrition_card.dart
class NutritionResultCard extends StatelessWidget {
  final FoodItem item;
  final double portionSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Meal type selector
          MealTypeChip(),
          
          // Food name and quantity
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              PortionAdjuster(),
            ],
          ),
          
          // Calorie card
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.local_fire_department, color: Colors.orange),
                SizedBox(width: 8),
                Text('Calories', style: TextStyle(fontSize: 16)),
                Spacer(),
                Text('${item.calories.toInt()}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          
          SizedBox(height: 16),
          
          // Macro grid
          Row(
            children: [
              MacroCard(label: 'Protein', value: item.protein, color: Colors.red[100]!),
              MacroCard(label: 'Fat', value: item.fat, color: Colors.blue[100]!),
              MacroCard(label: 'Carbs', value: item.carbs, color: Colors.orange[100]!),
              MacroCard(label: 'Fiber', value: item.fiber, color: Colors.purple[100]!),
            ],
          ),
          
          // Health score
          HealthScoreCard(score: item.healthScore),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: Icon(Icons.auto_fix_high),
                  label: Text('Edit with AI'),
                  onPressed: () {},
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  child: Text('Done'),
                  onPressed: () => _saveMeal(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
