import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AiFoodService {
  final String apiKey = dotenv.env['GROQ_API_KEY'] ?? '';
  final String apiUrl = 'https://api.groq.com/openai/v1/chat/completions';

  Future<Map<String, dynamic>> identifyFood(File imageFile) async {
    print("------------------------------------------------");
    print("DEBUG: 🚀 Starting Volumetric Food Analysis...");
    
    try {
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);
      print("DEBUG: 📸 Image converted to Base64 (${bytes.lengthInBytes} bytes)");

      final requestBody = jsonEncode({
        // ✅ RESTORED YOUR WORKING MODEL
        "model": "meta-llama/llama-4-scout-17b-16e-instruct", 
        
        "messages": [
          {
            "role": "user",
            "content": [
              {
                "type": "text", 
                // ✅ UPDATED PROMPT: Added Volumetric & Weight Estimation Requests
                "text": "Identify the food in this image for a medical nutrition report. "
                        "1. Analyze the image to identify food items. "
                        "2. ESTIMATE VOLUME/WEIGHT: Look at the plate size (assume 10-inch standard) or container depth. "
                        "3. Return a JSON object with keys: "
                        "   - 'is_food' (boolean) "
                        "   - 'items' (list): "
                        "     * 'name' (string) "
                        "     * 'estimated_weight_g' (number) : Best guess of weight in grams (e.g. 150, 300). "
                        "     * 'portion_desc' (string) : E.g., '1 cup', '2 slices', '1 large bowl'. "
                        "     * 'calories' (number) : Total calories for this SPECIFIC estimated volume. "
                        "     * 'protein' (g, number) "
                        "     * 'carbs' (g, number) "
                        "     * 'fat' (g, number) "
                        "     * 'fiber' (g, number) "
                        "     * 'sugar' (g, number) "
                        "     * 'sodium' (mg, number) "
                        "     * 'cholesterol' (mg, number) "
                        "     * 'iron' (mg, number) "
                        "     * 'potassium' (mg, number) "
                        "   - 'reason' (string) "
                        "Example: {\"is_food\": true, \"items\": [{\"name\": \"Rice\", \"estimated_weight_g\": 200, \"portion_desc\": \"1 full bowl\", \"calories\": 260, \"protein\": 5, ...}]}"
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