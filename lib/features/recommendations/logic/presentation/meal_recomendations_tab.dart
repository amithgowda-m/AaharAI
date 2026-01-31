// lib/features/recommendations/presentation/meal_recommendations_tab.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aaharai/features/recommendations/logic/recommendation_provider.dart';
import 'package:aaharai/features/recommendations/logic/subscription_provider.dart';
import 'package:aaharai/features/recommendations/widgets/recommendation_card.dart';

class MealRecommendationsTab extends StatelessWidget {
  const MealRecommendationsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<RecommendationProvider, SubscriptionProvider>(
      builder: (context, recProvider, subProvider, child) {
        if (recProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF4CAF50)),
          );
        }

        if (recProvider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  recProvider.error!,
                  style: const TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => recProvider.loadRecommendations(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => recProvider.loadRecommendations(),
          backgroundColor: const Color(0xFF2A2A2A),
          color: const Color(0xFF4CAF50),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Current Meal Type Header
              _buildMealTypeHeader(recProvider.currentMealType),
              const SizedBox(height: 16),

              // Pattern Insight Card
              if (recProvider.patternInsight != null)
                _buildInsightCard(recProvider.patternInsight!),
              
              const SizedBox(height: 16),

              // Recommendations
              if (!subProvider.isPremium && recProvider.recommendations.isNotEmpty)
                _buildPremiumLock(context),

              ...recProvider.recommendations.asMap().entries.map((entry) {
                final index = entry.key;
                final rec = entry.value;
                
                // Show first recommendation free, lock others
                final isLocked = !subProvider.isPremium && index > 0;
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: RecommendationCard(
                    recommendation: rec,
                    isLocked: isLocked,
                    onTap: () {
                      if (isLocked) {
                        _showPremiumDialog(context);
                      } else {
                        _showMealDetails(context, rec);
                      }
                    },
                  ),
                );
              }).toList(),

              if (recProvider.recommendations.isEmpty)
                _buildEmptyState(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMealTypeHeader(String mealType) {
    IconData icon;
    String label;
    
    switch (mealType.toLowerCase()) {
      case 'breakfast':
        icon = Icons.wb_sunny;
        label = 'Breakfast Ideas';
        break;
      case 'lunch':
        icon = Icons.lunch_dining;
        label = 'Lunch Options';
        break;
      case 'dinner':
        icon = Icons.dinner_dining;
        label = 'Dinner Suggestions';
        break;
      default:
        icon = Icons.restaurant;
        label = 'Snack Ideas';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF45A049)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'AI-powered suggestions just for you',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard(String insight) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Row(
        children: [
          const Icon(Icons.lightbulb, color: Color(0xFFFFA500), size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              insight,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumLock(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFFD700).withOpacity(0.2),
            const Color(0xFFFFA500).withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFD700)),
      ),
      child: Row(
        children: [
          const Icon(Icons.lock, color: Color(0xFFFFD700)),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Unlock all 3 recommendations with Premium',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          TextButton(
            onPressed: () => _showPremiumDialog(context),
            child: const Text('Upgrade'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(Icons.restaurant_menu, size: 64, color: Colors.grey[700]),
            const SizedBox(height: 16),
            Text(
              'No recommendations yet',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Log more meals to get personalized suggestions',
              style: TextStyle(color: Colors.grey[700], fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showMealDetails(BuildContext context, Map<String, dynamic> rec) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2A2A2A),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => ListView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              rec['name'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildNutrientRow('Calories', '${rec['calories']} kcal', Icons.local_fire_department),
            _buildNutrientRow('Protein', '${rec['protein']}g', Icons.fitness_center),
            _buildNutrientRow('Carbs', '${rec['carbs']}g', Icons.grain),
            _buildNutrientRow('Fat', '${rec['fat']}g', Icons.water_drop),
            if (rec['fiber'] != null)
              _buildNutrientRow('Fiber', '${rec['fiber']}g', Icons.spa),
            const SizedBox(height: 24),
            const Text(
              'Ingredients',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            ...((rec['ingredients'] as List?) ?? []).map((ingredient) => 
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 16),
                    const SizedBox(width: 8),
                    Text(
                      ingredient.toString(),
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ).toList(),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.psychology, color: Color(0xFF4CAF50), size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Why we recommend this',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    rec['reason'] ?? 'Balanced nutrition for your goals',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF4CAF50), size: 20),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showPremiumDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const PremiumOverlay(),
    );
  }
}
