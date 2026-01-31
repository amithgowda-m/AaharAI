// lib/features/recommendations/presentation/premium_overlay.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aaharai/features/recommendations/logic/subscription_provider.dart';

class PremiumOverlay extends StatelessWidget {
  const PremiumOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.star, color: Colors.white, size: 48),
                      SizedBox(height: 12),
                      Text(
                        'Upgrade to Premium',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Unlock the full power of AI nutrition tracking',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),

                // Features list
                _buildFeatureItem(
                  Icons.qr_code_scanner,
                  'Unlimited Food Scanning',
                  'Scan as many meals as you want',
                ),
                _buildFeatureItem(
                  Icons.restaurant_menu,
                  'AI Meal Recommendations',
                  '3 personalized suggestions for every meal',
                ),
                _buildFeatureItem(
                  Icons.calendar_month,
                  'Weekly Diet Plans',
                  'AI-generated meal plans for 7 days',
                ),
                _buildFeatureItem(
                  Icons.chat_bubble,
                  'Unlimited AI Chat',
                  'Ask Nutria anything, anytime',
                ),
                _buildFeatureItem(
                  Icons.insights,
                  'Advanced Insights',
                  'Track 84 nutrients & long-term patterns',
                ),
                _buildFeatureItem(
                  Icons.shopping_cart,
                  'Smart Shopping Lists',
                  'Auto-generated from your meal plans',
                ),
                _buildFeatureItem(
                  Icons.notifications_active,
                  'Intelligent Reminders',
                  'Context-aware meal notifications',
                ),
                _buildFeatureItem(
                  Icons.support_agent,
                  'Priority Support',
                  '24/7 assistance from our team',
                ),

                const SizedBox(height: 32),

                // Pricing
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFFD700)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            '₹499',
                            style: TextStyle(
                              color: Color(0xFFFFD700),
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text(
                              '/year',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'or ₹69/month',
                        style: TextStyle(color: Colors.grey[500], fontSize: 14),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Save 40% with annual plan',
                        style: TextStyle(
                          color: Color(0xFF4CAF50),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // CTA Button
                ElevatedButton(
                  onPressed: () => _handleUpgrade(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD700),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Start Premium Now',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Maybe Later',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  '✓ Cancel anytime\n✓ 7-day money-back guarantee\n✓ Secure payment',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF4CAF50), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(color: Colors.white60, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleUpgrade(BuildContext context) async {
    // Mock payment - replace with actual payment integration
    final subProvider = context.read<SubscriptionProvider>();
    
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFFFFD700)),
      ),
    );

    // Simulate payment process
    await Future.delayed(const Duration(seconds: 2));
    
    // Upgrade to premium
    final success = await subProvider.upgradeToPremium(
      transactionId: 'MOCK_${DateTime.now().millisecondsSinceEpoch}',
    );

    if (context.mounted) {
      Navigator.pop(context); // Close loading
      Navigator.pop(context); // Close premium overlay

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🎉 Welcome to Premium!'),
            backgroundColor: Color(0xFF4CAF50),
          ),
        );
      }
    }
  }
}
