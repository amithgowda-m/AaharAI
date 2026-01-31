import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:aahar_ai/services/groq_recommendation_service.dart';
import 'package:aahar_ai/data/local/isar_service.dart';
import 'package:aahar_ai/data/local/entities/meal_recommendation.dart';
import 'package:aahar_ai/features/recommendations/logic/meal_pattern_analyzer.dart';
import 'package:aahar_ai/data/local/entities/user_profile.dart';

class RecommendationProvider with ChangeNotifier {
  final GroqRecommendationService _groqService;
  final IsarService _isarService;
  final MealPatternAnalyzer _patternAnalyzer;

  RecommendationProvider({
    required GroqRecommendationService groqService,
    required IsarService isarService,
    required MealPatternAnalyzer patternAnalyzer,
  })  : _groqService = groqService,
        _isarService = isarService,
        _patternAnalyzer = patternAnalyzer;

  List<Map<String, dynamic>> _recommendations = [];
  String? _patternInsight;
  String? _nutrientGap;
  bool _isLoading = false;
  String? _error;
  String _currentMealType = '';

  List<Map<String, dynamic>> get recommendations => _recommendations;
  String? get patternInsight => _patternInsight;
  String? get nutrientGap => _nutrientGap;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get currentMealType => _currentMealType;

  /// Load meal recommendations for current meal time
  Future<void> loadRecommendations() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // 1. Determine current meal type
      _currentMealType = _patternAnalyzer.getCurrentMealType();
      
      // 2. Check cache first
      final cached = await _isarService.getValidRecommendations(_currentMealType);
      
      if (cached.isNotEmpty) {
        print("DEBUG: Found cached recommendations");
        _recommendations = cached.map((rec) => {
          'id': rec.id,
          'name': rec.name,
          'calories': rec.calories,
          'protein': rec.protein,
          'carbs': rec.carbs,
          'fat': rec.fat,
          'fiber': rec.fiber,
          'ingredients': rec.ingredients,
          'reason': rec.reason,
        }).toList();
        
        _isLoading = false;
        notifyListeners();
        return;
      }

      // 3. Fetch recent meals (Must have logs!)
      final recentMeals = await _patternAnalyzer.getRecentMeals(7);
      
      if (recentMeals.isEmpty) {
        _error = 'Log some meals first to get personalized recommendations';
        _isLoading = false;
        notifyListeners();
        return;
      }

      // 4. Get User Profile (Handle missing profile)
      final userProfile = await _getUserProfile();
      
      // 5. Calculate Targets
      final dailyTarget = _patternAnalyzer.calculateDailyCalorieTarget(userProfile);
      final mealCalories = _patternAnalyzer.calculateMealCalories(_currentMealType, dailyTarget);

      // 6. Call AI Service
      print("DEBUG: Calling Groq API...");
      final result = await _groqService.generateMealRecommendations(
        recentMeals: recentMeals,
        userProfile: userProfile,
        mealType: _currentMealType,
        targetCalories: mealCalories,
      );

      // 7. Process Result
      if (result['recommendations'] != null) {
        final recList = result['recommendations'] as List;
        _recommendations = recList.cast<Map<String, dynamic>>();
        
        // Save to DB
        final now = DateTime.now();
        final validUntil = now.add(const Duration(hours: 24));
        
        final entities = recList.map((rec) {
          return MealRecommendation()
            ..name = rec['name']
            ..mealType = _currentMealType
            ..calories = _toDouble(rec['calories'])
            ..protein = _toDouble(rec['protein'])
            ..carbs = _toDouble(rec['carbs'])
            ..fat = _toDouble(rec['fat'])
            ..fiber = _toDouble(rec['fiber'])
            ..ingredients = List<String>.from(rec['ingredients'] ?? [])
            ..reason = rec['reason']
            ..createdAt = now
            ..validUntil = validUntil
            ..timestamp = now;
        }).toList();
        
        await _isarService.saveRecommendations(entities);
      }

      _patternInsight = result['pattern_insights'];
      _nutrientGap = result['nutrient_gap'];

      await _isarService.clearExpiredRecommendations();

    } catch (e, stackTrace) {
      print('ERROR loading recommendations: $e');
      print(stackTrace);
      _error = 'Failed to load recommendations. $e'; // Show exact error in UI for debug
    }

    _isLoading = false;
    notifyListeners();
  }

  // Helper to safely convert numbers
  double _toDouble(dynamic value) {
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  /// Get user profile safely
  Future<Map<String, dynamic>> _getUserProfile() async {
    try {
      final isar = await _isarService.db;
      final profile = await isar.userProfiles.where().findFirst();
      
      if (profile != null) {
        return {
          'age': profile.age,
          'gender': profile.gender,
          'weight': profile.currentWeight,
          'height': profile.height,
          'weightGoal': profile.goal,
          'activityLevel': profile.activityLevel,
          // Safely access preferences
          'dietaryPreference': profile.dietaryPreferences.isNotEmpty 
              ? profile.dietaryPreferences.first 
              : 'none',
        };
      }
    } catch (e) {
      print("Error fetching profile: $e");
    }
    
    // Fallback default
    return {
      'age': 25,
      'gender': 'male',
      'weight': 70,
      'height': 170,
      'weightGoal': 'maintain',
      'activityLevel': 'moderate',
      'dietaryPreference': 'none',
    };
  }

  Future<void> refreshRecommendations() async {
    final cached = await _isarService.getValidRecommendations(_currentMealType);
    if (cached.isNotEmpty) {
      final isar = await _isarService.db;
      await isar.writeTxn(() async {
        await isar.mealRecommendations.deleteAll(cached.map((e) => e.id).toList());
      });
    }
    await loadRecommendations();
  }
}