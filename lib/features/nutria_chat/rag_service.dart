// lib/features/nutira_chat/data/rag_service.dart
class NutiraRagService {
  final String groqApiKey;
  
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
    
    return jsonDecode(response.body)['choices'][0]['message']['content'];
  }
  
  Future<String> _retrieveRelevantMeals(String query) async {
    // Get last 7 days of meals from Isar
    final meals = await IsarService.isar.mealEntrys
      .filter()
      .timestampGreaterThan(DateTime.now().subtract(Duration(days: 7)))
      .findAll();
    
    // Format as context
    return meals.map((m) => 
      '${m.mealType}: ${m.foodName} (${m.calories} cal, Score: ${m.healthScore}/10)'
    ).join('\n');
  }
}
