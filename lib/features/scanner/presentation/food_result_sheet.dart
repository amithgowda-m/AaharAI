import 'package:flutter/material.dart';

class FoodResultSheet extends StatelessWidget {
  final Map<String, dynamic> data;

  const FoodResultSheet({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // 1. Safety Check: If data is empty or malformed, show error safely
    final items = data['items'] as List<dynamic>? ?? [];
    
    if (items.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: const Center(child: Text("No items details found.")),
      );
    }

    // 2. Extract the first item (Primary food detected)
    final mainItem = items[0]; 
    final String name = mainItem['name'] ?? 'Unknown Food';
    final double calories = (mainItem['calories'] as num?)?.toDouble() ?? 0;
    final double protein = (mainItem['protein'] as num?)?.toDouble() ?? 0;
    final double carbs = (mainItem['carbs'] as num?)?.toDouble() ?? 0;
    final double fat = (mainItem['fat'] as num?)?.toDouble() ?? 0;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle Bar (Visual cue)
          Center(
            child: Container(
              width: 50, height: 5,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          // Title & Calories
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green),
                ),
                child: Text(
                  "${calories.toStringAsFixed(0)} kcal",
                  style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),

          // Macros Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMacro("Protein", "${protein}g", Colors.blue),
              _buildMacro("Carbs", "${carbs}g", Colors.orange),
              _buildMacro("Fats", "${fat}g", Colors.red),
            ],
          ),

          const SizedBox(height: 30),

          // Add to Log Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Meal Logged Successfully!")),
                );
              },
              child: const Text("Add to Diary", style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacro(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}