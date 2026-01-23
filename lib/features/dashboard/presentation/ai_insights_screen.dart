import 'dart:ui';
import 'package:flutter/material.dart';

class AiInsightsScreen extends StatelessWidget {
  const AiInsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F2027),
              Color(0xFF203A43),
              Color(0xFF2C5364),
            ],
          ),
        ),

        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              20,
              20,
              20,
              160, // ✅ space for bottom bar + FAB
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "AI Insights 🤖",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () {},
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                Text(
                  "Get personalized nutrition insights based on your food history.",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),

                const SizedBox(height: 28),

                // GENERATE BUTTON (SAFE POSITION)
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFFFB86C),
                          Color(0xFFFF9F43),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orangeAccent.withOpacity(0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      icon: const Icon(
                        Icons.auto_awesome,
                        color: Colors.black,
                        size: 18,
                      ),
                      label: const Text(
                        "Generate Insights",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // INSIGHT CARDS
                const _InsightCard(
                  icon: Icons.lightbulb_outline,
                  title: "No Insights Yet",
                  subtitle:
                      "Log meals consistently to unlock AI-powered analysis.",
                ),

                const SizedBox(height: 16),

                const _InsightCard(
                  icon: Icons.trending_up,
                  title: "Trends & Patterns",
                  subtitle:
                      "Calories, protein balance, and habits will appear here.",
                ),

                const SizedBox(height: 16),

                const _InsightCard(
                  icon: Icons.health_and_safety_outlined,
                  title: "Health Suggestions",
                  subtitle:
                      "Actionable recommendations based on your diet.",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------- COMPONENT ----------------

class _InsightCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InsightCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white.withOpacity(0.12),
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.white.withOpacity(0.12),
                child: Icon(icon, color: Colors.orangeAccent),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




