import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../data/local/isar_service.dart';
import '../../data/local/entities/food_log.dart';
import '../../services/auth_service.dart';

class NutiraRagService {
  final String groqApiKey = dotenv.env['GROQ_API_KEY'] ?? '';
  final IsarService _isarService = IsarService();
  
  // Store user's meal history as embeddings
  Future<String> generateResponse(String userQuery) async {
    // 1. Retrieve relevant context from user's meal history
    final context = await _retrieveRelevantMeals(userQuery);
    
    // 2. Construct prompt with context
    final systemPrompt = '''
    You are Nutira, a friendly AI nutrition assistant for Aahar AI app.
    
    User's Recent Meals:
    $context
    
    Provide personalized advice based on their eating patterns.
    Keep responses encouraging and actionable.
    ''';
    
    // 3. Send to Groq API
    try {
      final response = await http.post(
        Uri.parse('https://api.groq.com/openai/v1/chat/completions'),
        headers: {
          'Authorization': 'Bearer $groqApiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'llama-3.3-70b-versatile',
          'messages': [
            {'role': 'system', 'content': systemPrompt},
            {'role': 'user', 'content': userQuery},
          ],
        }),
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['choices'][0]['message']['content'];
      } else {
        return "I'm having trouble connecting to my brain right now. Please try again later!";
      }
    } catch (e) {
      return "I encountered an error. Please check your connection!";
    }
  }
  
  Future<String> _retrieveRelevantMeals(String query) async {
    final currentUser = AuthService.getCurrentUser();
    if (currentUser == null) return "No meal history available.";

    // Get last 7 days of meals from Isar
    final start = DateTime.now().subtract(const Duration(days: 7));
    final end = DateTime.now();
    
    final meals = await _isarService.getLogsByDateRange(currentUser.id, start, end);
    
    if (meals.isEmpty) return "No meals logged in the last 7 days.";

    // Format as context
    return meals.map((m) => 
      '${m.mealType}: ${m.foodName} (${m.totalCalories.toInt()} cal, Score: ${m.healthScore}/10)'
    ).join('\n');
  }
}
