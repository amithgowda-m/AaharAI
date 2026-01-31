// lib/features/recommendations/presentation/insights_tab.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aaharai/services/groq_recommendation_service.dart';
import 'package:aaharai/features/recommendations/logic/meal_pattern_analyzer.dart';
import 'package:aaharai/features/recommendations/logic/subscription_provider.dart';

class InsightsTab extends StatefulWidget {
  const InsightsTab({Key? key}) : super(key: key);

  @override
  State<InsightsTab> createState() => _InsightsTabState();
}

class _InsightsTabState extends State<InsightsTab> {
  Map<String, dynamic>? _insights;
  bool _isLoading = false;
  String? _error;
  int _selectedDays = 7;

  @override
  void initState() {
    super.initState();
    _loadInsights();
  }

  Future<void> _loadInsights() async {
    final subProvider = context.read<SubscriptionProvider>();
    
    if (!subProvider.isPremium && _selectedDays > 7) {
      _showPremiumDialog();
      setState(() => _selectedDays = 7);
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final patternAnalyzer = context.read<MealPatternAnalyzer>();
      final groqService = context.read<GroqRecommendationService>();
      
      final meals = await patternAnalyzer.getRecentMeals(_selectedDays);
      
      if (meals.isEmpty) {
        setState(() {
          _error = 'No meal data available. Start logging to see insights!';
          _isLoading = false;
        });
        return;
      }

      final result = await groqService.analyzeEatingPatterns(
        meals: meals,
        days: _selectedDays,
      );

      setState(() => _insights = result);

    } catch (e) {
      print('Error loading insights: $e');
      setState(() => _error = 'Failed to analyze patterns. Please try again.');
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Time range selector
          _buildTimeRangeSelector(),
          
          const SizedBox(height: 16),

          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(color: Color(0xFF4CAF50)),
              ),
            ),

          if (_error != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      _error!,
                      style: const TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadInsights,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),

          if (_insights != null && !_isLoading) ...[
            _buildPatternsCard(),
            const SizedBox(height: 12),
            _buildNutritionCard(),
            const SizedBox(height: 12),
            _buildBehavioralInsightsCard(),
            const SizedBox(height: 12),
            _buildRecommendationsCard(),
          ],
        ],
      ),
    );
  }

  Widget _buildTimeRangeSelector() {
    return Consumer<SubscriptionProvider>(
      builder: (context, subProvider, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Analyze Last',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: [
                  _buildDayChip(7, subProvider.isPremium),
                  _buildDayChip(14, subProvider.isPremium),
                  _buildDayChip(30, subProvider.isPremium),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDayChip(int days, bool isPremium) {
    final isLocked = !isPremium && days > 7;
    final isSelected = _selectedDays == days && !isLocked;

    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$days days'),
          if (isLocked) ...[
            const SizedBox(width: 4),
            const Icon(Icons.lock, size: 14, color: Color(0xFFFFD700)),
          ],
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        if (isLocked) {
          _showPremiumDialog();
        } else {
          setState(() => _selectedDays = days);
          _loadInsights();
        }
      },
      backgroundColor: const Color(0xFF1A1A1A),
      selectedColor: const Color(0xFF4CAF50),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : (isLocked ? const Color(0xFFFFD700) : Colors.grey),
      ),
    );
  }

  Widget _buildPatternsCard() {
    final patterns = _insights!['patterns'] as Map<String, dynamic>;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.schedule, color: Color(0xFF4CAF50)),
              SizedBox(width: 8),
              Text(
                'Eating Patterns',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoRow('Schedule', patterns['eating_schedule']),
          _buildInfoRow('Consistency', patterns['meal_timing_consistency']),
          _buildInfoRow('Meals/Day', patterns['average_meals_per_day'].toString()),
          if (patterns['common_meal_times'] != null) ...[
            const SizedBox(height: 8),
            const Text(
              'Common Meal Times:',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8,
              children: (patterns['common_meal_times'] as List)
                  .map((time) => Chip(
                        label: Text(time.toString()),
                        backgroundColor: const Color(0xFF1A1A1A),
                        labelStyle: const TextStyle(color: Color(0xFF4CAF50), fontSize: 11),
                      ))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNutritionCard() {
    final nutrition = _insights!['nutrition_analysis'] as Map<String, dynamic>;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.restaurant_menu, color: Color(0xFF4CAF50)),
              SizedBox(width: 8),
              Text(
                'Nutrition Analysis',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoRow('Avg Daily Calories', '${nutrition['avg_daily_calories']} kcal'),
          _buildStatusRow('Protein', nutrition['protein_status']),
          _buildStatusRow('Carbs', nutrition['carb_status']),
          _buildStatusRow('Fat', nutrition['fat_status']),
          _buildStatusRow('Fiber', nutrition['fiber_status']),
          
          if (nutrition['deficient_nutrients'] != null && 
              (nutrition['deficient_nutrients'] as List).isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.warning_amber, color: Colors.orange, size: 16),
                      SizedBox(width: 8),
                      Text(
                        'Nutrient Gaps',
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: (nutrition['deficient_nutrients'] as List)
                        .map((nutrient) => Chip(
                              label: Text(nutrient.toString()),
                              backgroundColor: Colors.orange.withOpacity(0.2),
                              labelStyle: const TextStyle(color: Colors.orange, fontSize: 11),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBehavioralInsightsCard() {
    final insights = _insights!['behavioral_insights'] as List;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.psychology, color: Color(0xFF4CAF50)),
              SizedBox(width: 8),
              Text(
                'Behavioral Insights',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...insights.map((insight) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.lightbulb_outline, 
                         color: Color(0xFFFFA726), size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        insight.toString(),
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              )).toList(),
        ],
      ),
    );
  }

  Widget _buildRecommendationsCard() {
    final recommendations = _insights!['recommendations'] as List;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF4CAF50).withOpacity(0.2),
            const Color(0xFF45A049).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.tips_and_updates, color: Color(0xFF4CAF50)),
              SizedBox(width: 8),
              Text(
                'Recommendations',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...recommendations.asMap().entries.map((entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4CAF50),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${entry.key + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        entry.value.toString(),
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              )).toList(),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, String status) {
    Color statusColor = const Color(0xFF4CAF50);
    if (status.toLowerCase().contains('low') || status.toLowerCase().contains('deficient')) {
      statusColor = Colors.orange;
    } else if (status.toLowerCase().contains('high')) {
      statusColor = Colors.red;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: statusColor.withOpacity(0.5)),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPremiumDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Row(
          children: [
            Icon(Icons.star, color: Color(0xFFFFD700)),
            SizedBox(width: 8),
            Text('Premium Feature', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: const Text(
          'Extended insights (14+ days) are available for Premium subscribers.\n\nUpgrade now for deeper analysis!',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to premium upgrade screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFD700),
            ),
            child: const Text('Upgrade', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
