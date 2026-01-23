// lib/services/ai_food_service.dart - REPLACE ENTIRE FILE

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AiFoodService {
  final String apiKey = dotenv.env['GROQ_API_KEY'] ?? '';
  final String apiUrl = 'https://api.groq.com/openai/v1/chat/completions';

  Future<Map<String, dynamic>> identifyFood(File imageFile) async {
    print("------------------------------------------------");
    print("DEBUG: 🚀 Starting Image Analysis...");
    
    try {
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);
      print("DEBUG: 📸 Image converted to Base64 (${bytes.lengthInBytes} bytes)");

      final requestBody = jsonEncode({
        "model": "meta-llama/llama-4-scout-17b-16e-instruct",
        "messages": [
          {
            "role": "user",
            "content": [
              {
                "type": "text", 
                "text": "Identify the food in this image. "
                        "Return a JSON object with keys: "
                        "1. 'is_food' (boolean): true if edible food. "
                        "2. 'items' (list): Detected foods with 'name', 'calories', 'protein', 'carbs', 'fat'. "
                        "3. 'reason' (string): If not food, explain why. "
                        "Example: {\"is_food\": true, \"items\": [{\"name\": \"Roti\", \"calories\": 100, \"protein\": 3, \"carbs\": 18, \"fat\": 2}]}"
              },
              {
                "type": "image_url",
                "image_url": {
                  "url": "data:image/jpeg;base64,$base64Image"
                }
              }
            ]
          }
        ],
        "temperature": 0.1,
        "max_tokens": 1024,
        "response_format": {"type": "json_object"}
      });

      print("DEBUG: 📡 Sending request to Groq API...");
      
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $apiKey",
          "Content-Type": "application/json",
        },
        body: requestBody,
      ).timeout(const Duration(seconds: 30));

      print("DEBUG: 📥 Response Code: ${response.statusCode}");
      print("DEBUG: 📄 Raw Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String content = data['choices'][0]['message']['content'];
        
        // Clean markdown if present
        final cleanJson = content.replaceAll('```json', '').replaceAll('```', '').trim();
        return jsonDecode(cleanJson);
      } else {
        return {
          'is_food': false, 
          'reason': 'API Error ${response.statusCode}: ${response.body}'
        };
      }
    } catch (e) {
      print("DEBUG: ❌ Error: $e");
      return {'is_food': false, 'reason': 'Network Error: $e'};
    }
  }
}
