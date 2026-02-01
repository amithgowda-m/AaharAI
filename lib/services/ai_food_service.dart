import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AiFoodService {
  final String apiKey = dotenv.env['GROQ_API_KEY'] ?? '';
  final String apiUrl = 'https://api.groq.com/openai/v1/chat/completions';

  Future<Map<String, dynamic>> identifyFood(File imageFile) async {
    print("------------------------------------------------");
    print("DEBUG: 🚀 Starting Multi-Item Thali Analysis...");
    
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
                // ✅ UPDATED PROMPT: SPECIFICALLY FOR THALI / MULTI-ITEM
                "text": "Analyze this food image for a nutrition log. "
                        "1. DETECTION: If this is a Thali or combo meal, DETECT EVERY DISTINCT ITEM separately (e.g., Roti, Rice, Dal, Curd, Veggie 1, Veggie 2). "
                        "2. ESTIMATION: Estimate the volume/weight for EACH item based on standard bowl sizes (katori). "
                        "3. Return a JSON object with keys: "
                        "   - 'is_food' (boolean) "
                        "   - 'items' (list of objects): "
                        "     * 'name' (string) "
                        "     * 'estimated_weight_g' (number) "
                        "     * 'portion_desc' (string) : e.g., '1 small bowl', '2 pieces'. "
                        "     * 'calories' (number) : Total calories for this specific item's portion. "
                        "     * 'protein' (g), 'carbs' (g), 'fat' (g), 'fiber' (g), 'sugar' (g), 'sodium' (mg), 'cholesterol' (mg), 'iron' (mg), 'potassium' (mg). "
                        "   - 'reason' (string) "
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

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String content = data['choices'][0]['message']['content'];
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