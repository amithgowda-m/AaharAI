// lib/services/groq_recommendation_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GroqRecommendationService {
  final String apiKey = dotenv.env['GROQ_API_KEY'] ?? '';
  final String apiUrl = 'https://api.groq.com/openai/v1/chat/completions';

  /// Generate meal recommendations based on user's eating patterns
  Future<Map<String, dynamic>> generateMealRecommendations({
    required List<Map<String, dynamic>> recentMeals,
    required Map<String, dynamic> userProfile,
    required String mealType, // breakfast, lunch, dinner, snack
    required int targetCalories,
  }) async {
    try {
      // Build context from recent meals
      String mealHistory = _buildMealHistoryContext(recentMeals);
      
      final requestBody = jsonEncode({
        "model": "meta-llama/llama-4-scout-17b-16e-instruct",
        "messages": [
          {
            "role": "system",
            "content": "You are an expert nutritionist AI assistant. Generate personalized meal recommendations based on user's eating patterns, preferences, and nutritional goals. Always respond in JSON format."
          },
          {
            "role": "user",
            "content": """
Based on this user profile and recent eating history, suggest 3 healthy $mealType options:

USER PROFILE:
- Age: ${userProfile['age']}
- Gender: ${userProfile['gender']}
- Weight Goal: ${userProfile['weightGoal']}
- Dietary Preference: ${userProfile['dietaryPreference'] ?? 'None'}
- Target Calories for this meal: $targetCalories kcal

RECENT MEAL HISTORY (Last 7 days):
$mealHistory

REQUIREMENTS:
1. Suggest 3 different $mealType options
2. Each meal should be culturally appropriate (Indian cuisine preferred)
3. Consider nutrient balance (not just calories)
4. Avoid recently eaten foods for variety
5. Each suggestion should include: name, ingredients, calories, protein, carbs, fat, fiber, and why it's recommended

Return ONLY valid JSON in this format:
{
  "recommendations": [
    {
      "name": "Meal name",
      "ingredients": ["ingredient1", "ingredient2"],
      "calories": 400,
      "protein": 20,
      "carbs": 50,
      "fat": 10,
      "fiber": 8,
      "reason": "Why this meal is recommended for this user"
    }
  ],
  "pattern_insights": "Brief insight about their eating patterns",
  "nutrient_gap": "Any nutrients they're lacking"
}
"""
          }
        ],
        "temperature": 0.7,
        "max_tokens": 2048,
        "response_format": {"type": "json_object"}
      });

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $apiKey",
          "Content-Type": "application/json",
        },
        body: requestBody,
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
        return jsonDecode(content);
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      print("Error generating recommendations: $e");
      rethrow;
    }
  }

  /// Generate a full weekly diet plan
  Future<Map<String, dynamic>> generateWeeklyDietPlan({
    required Map<String, dynamic> userProfile,
    required List<Map<String, dynamic>> recentMeals,
    required int dailyCalorieTarget,
  }) async {
    try {
      String mealHistory = _buildMealHistoryContext(recentMeals);
      
      final requestBody = jsonEncode({
        "model": "meta-llama/llama-4-scout-17b-16e-instruct",
        "messages": [
          {
            "role": "system",
            "content": "You are an expert nutritionist creating personalized weekly meal plans. Focus on Indian cuisine, balanced nutrition, and variety."
          },
          {
            "role": "user",
            "content": """
Create a 7-day meal plan for this user:

USER PROFILE:
- Age: ${userProfile['age']}
- Gender: ${userProfile['gender']}
- Weight: ${userProfile['weight']} kg
- Height: ${userProfile['height']} cm
- Activity Level: ${userProfile['activityLevel'] ?? 'Moderate'}
- Weight Goal: ${userProfile['weightGoal']}
- Daily Calorie Target: $dailyCalorieTarget kcal
- Dietary Restrictions: ${userProfile['dietaryPreference'] ?? 'None'}

RECENT EATING PATTERNS:
$mealHistory

Generate a 7-day plan with:
- 3 main meals + 2 snacks per day
- Total daily calories within ±100 of target
- Protein: 20-30% of calories
- Carbs: 45-55% of calories
- Fat: 20-30% of calories
- High variety (no meal repeated in the week)
- Culturally appropriate (Indian meals)

Return ONLY valid JSON:
{
  "week_plan": {
    "Monday": {
      "breakfast": {"name": "", "calories": 0, "protein": 0, "carbs": 0, "fat": 0},
      "morning_snack": {"name": "", "calories": 0, "protein": 0, "carbs": 0, "fat": 0},
      "lunch": {"name": "", "calories": 0, "protein": 0, "carbs": 0, "fat": 0},
      "evening_snack": {"name": "", "calories": 0, "protein": 0, "carbs": 0, "fat": 0},
      "dinner": {"name": "", "calories": 0, "protein": 0, "carbs": 0, "fat": 0},
      "total_calories": 0,
      "total_protein": 0,
      "total_carbs": 0,
      "total_fat": 0
    },
    ... (repeat for all 7 days)
  },
  "weekly_summary": {
    "avg_daily_calories": 0,
    "protein_distribution": "Good/Needs Improvement",
    "variety_score": "8/10",
    "adherence_tips": "Tips for following this plan"
  }
}
"""
          }
        ],
        "temperature": 0.8,
        "max_tokens": 4096,
        "response_format": {"type": "json_object"}
      });

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $apiKey",
          "Content-Type": "application/json",
        },
        body: requestBody,
      ).timeout(const Duration(seconds: 45));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
        return jsonDecode(content);
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      print("Error generating weekly plan: $e");
      rethrow;
    }
  }

  /// Analyze eating patterns and provide insights
  Future<Map<String, dynamic>> analyzeEatingPatterns({
    required List<Map<String, dynamic>> meals,
    required int days,
  }) async {
    try {
      String mealData = _buildDetailedMealAnalysis(meals);
      
      final requestBody = jsonEncode({
        "model": "meta-llama/llama-4-scout-17b-16e-instruct",
        "messages": [
          {
            "role": "system",
            "content": "You are a nutrition data analyst. Analyze eating patterns and provide actionable insights."
          },
          {
            "role": "user",
            "content": """
Analyze the following $days days of meal data:

$mealData

Provide insights on:
1. Eating patterns (timing, frequency, consistency)
2. Nutritional balance (macros, common deficiencies)
3. Food variety and repetition
4. Behavioral patterns (late-night eating, skipped meals, etc.)
5. Actionable recommendations

Return ONLY valid JSON:
{
  "patterns": {
    "eating_schedule": "Regular/Irregular",
    "meal_timing_consistency": "Consistent/Inconsistent",
    "average_meals_per_day": 3.5,
    "common_meal_times": ["8:00 AM", "1:00 PM", "8:30 PM"]
  },
  "nutrition_analysis": {
    "avg_daily_calories": 2000,
    "protein_status": "Adequate/Low/High",
    "carb_status": "Balanced/High/Low",
    "fat_status": "Balanced/High/Low",
    "fiber_status": "Low/Adequate",
    "deficient_nutrients": ["Vitamin D", "Iron"]
  },
  "behavioral_insights": [
    "You tend to skip breakfast on weekdays",
    "Higher calorie intake on weekends",
    "Late-night snacking pattern detected"
  ],
  "recommendations": [
    "Add protein-rich breakfast to stabilize energy",
    "Include more leafy greens for iron",
    "Try earlier dinner time for better digestion"
  ],
  "streak_data": {
    "consistent_logging_days": 6,
    "balanced_meals_count": 15,
    "improvement_areas": ["Add more vegetables", "Reduce sugar intake"]
  }
}
"""
          }
        ],
        "temperature": 0.5,
        "max_tokens": 2048,
        "response_format": {"type": "json_object"}
      });

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $apiKey",
          "Content-Type": "application/json",
        },
        body: requestBody,
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
        return jsonDecode(content);
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      print("Error analyzing patterns: $e");
      rethrow;
    }
  }

  // Helper methods
  String _buildMealHistoryContext(List<Map<String, dynamic>> meals) {
    if (meals.isEmpty) return "No recent meal history available.";
    
    StringBuffer context = StringBuffer();
    for (var meal in meals.take(21)) { // Last 7 days × 3 meals
      context.writeln(
        "- ${meal['date']}: ${meal['name']} "
        "(${meal['calories']}kcal, P:${meal['protein']}g, C:${meal['carbs']}g, F:${meal['fat']}g)"
      );
    }
    return context.toString();
  }

  String _buildDetailedMealAnalysis(List<Map<String, dynamic>> meals) {
    StringBuffer analysis = StringBuffer();
    
    for (var meal in meals) {
      analysis.writeln(
        "Date: ${meal['date']}, Time: ${meal['time']}, "
        "Meal: ${meal['name']}, Type: ${meal['type']}, "
        "Calories: ${meal['calories']}, Protein: ${meal['protein']}g, "
        "Carbs: ${meal['carbs']}g, Fat: ${meal['fat']}g"
      );
    }
    
    return analysis.toString();
  }
}
