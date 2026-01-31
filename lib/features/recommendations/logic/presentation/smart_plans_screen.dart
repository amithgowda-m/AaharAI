// lib/features/recommendations/presentation/smart_plans_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aaharai/features/recommendations/logic/recommendation_provider.dart';
import 'package:aaharai/features/recommendations/logic/subscription_provider.dart';
import 'package:aaharai/features/recommendations/presentation/meal_recommendations_tab.dart';
import 'package:aaharai/features/recommendations/presentation/diet_plan_tab.dart';
import 'package:aaharai/features/recommendations/presentation/insights_tab.dart';
import 'package:aaharai/features/recommendations/presentation/premium_overlay.dart';

class SmartPlansScreen extends StatefulWidget {
  const SmartPlansScreen({Key? key}) : super(key: key);

  @override
  State<SmartPlansScreen> createState() => _SmartPlansScreenState();
}

class _SmartPlansScreenState extends State<SmartPlansScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // Load recommendations on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RecommendationProvider>(context, listen: false)
          .loadRecommendations();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        title: const Text(
          'Smart Plans',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Consumer<SubscriptionProvider>(
            builder: (context, subProvider, child) {
              return GestureDetector(
                onTap: () => _showSubscriptionDialog(context),
                child: Container(
                  margin: const EdgeInsets.only(right: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: subProvider.isPremium
                        ? const LinearGradient(
                            colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                          )
                        : null,
                    color: subProvider.isPremium ? null : Colors.grey[800],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        subProvider.isPremium ? Icons.star : Icons.star_outline,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        subProvider.isPremium ? 'Premium' : 'Free',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF4CAF50),
          indicatorWeight: 3,
          labelColor: const Color(0xFF4CAF50),
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'For You'),
            Tab(text: 'Diet Plans'),
            Tab(text: 'Insights'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          MealRecommendationsTab(),
          DietPlanTab(),
          InsightsTab(),
        ],
      ),
    );
  }

  void _showSubscriptionDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const PremiumOverlay(),
    );
  }
}
