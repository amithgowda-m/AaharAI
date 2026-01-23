// lib/services/nutira_service.dart - REPLACE ENTIRE FILE

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NutriaService {
  final String apiKey = dotenv.env['GROQ_API_KEY'] ?? '';

  Future<String> getMealSuggestions({
    required String currentMealType,
    required String currentFood,
    required double calories,
  }) async {
    final hour = DateTime.now().hour;

    final prompt = '''
You are Nutira, a friendly AI nutritionist for Aahar AI app.

Current Situation:
- User just logged: $currentFood ($calories cal) for $currentMealType
- Time: ${_getTimeOfDay(hour)}

Provide a personalized response with:
1. **Quick feedback** on their current meal (is it balanced?)
2. **What to add**: Suggest 2-3 budget-friendly Indian modifiers or toppings
3. **Next meal**: Brief suggestion for their next meal

Keep it encouraging, concise (max 150 words), and actionable.
Use emojis to make it friendly!
''';

    try {
      final response = await http.post(
        Uri.parse('https://api.groq.com/openai/v1/chat/completions'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'llama-3.3-70b-versatile',
          'messages': [
            {
              'role': 'system',
              'content': 'You are Nutira, a friendly Indian nutritionist AI assistant.'
            },
            {'role': 'user', 'content': prompt}
          ],
          'temperature': 0.7,
          'max_tokens': 500,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        return '💚 Great choice with $currentFood! Try adding a protein source if you haven\'t already. Stay hydrated!';
      }
    } catch (e) {
      return '💚 Good meal choice! Remember to balance your macros throughout the day. Keep logging!';
    }
  }

  String _getTimeOfDay(int hour) {
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    if (hour < 21) return 'Evening';
    return 'Night';
  }
}
