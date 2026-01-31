// lib/features/recommendations/widgets/recommendation_card.dart

import 'package:flutter/material.dart';

class RecommendationCard extends StatelessWidget {
  final Map<String, dynamic> recommendation;
  final bool isLocked;
  final VoidCallback onTap;

  const RecommendationCard({
    Key? key,
    required this.recommendation,
    required this.isLocked,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isLocked ? const Color(0xFFFFD700) : const Color(0xFF3A3A3A),
          ),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        recommendation['name'],
                        style: TextStyle(
                          color: isLocked ? Colors.white54 : Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (isLocked)
                      const Icon(Icons.lock, color: Color(0xFFFFD700), size: 20),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Nutrient info
                Opacity(
                  opacity: isLocked ? 0.5 : 1.0,
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      _buildNutrientChip(
                        Icons.local_fire_department,
                        '${recommendation['calories']} kcal',
                        const Color(0xFFFF6B6B),
                      ),
                      _buildNutrientChip(
                        Icons.fitness_center,
                        '${recommendation['protein']}g protein',
                        const Color(0xFF4CAF50),
                      ),
                      _buildNutrientChip(
                        Icons.grain,
                        '${recommendation['carbs']}g carbs',
                        const Color(0xFF2196F3),
                      ),
                      _buildNutrientChip(
                        Icons.water_drop,
                        '${recommendation['fat']}g fat',
                        const Color(0xFFFFA726),
                      ),
                    ],
                  ),
                ),
                
                if (!isLocked && recommendation['reason'] != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    recommendation['reason'],
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
            
            if (isLocked)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.lock, color: Color(0xFFFFD700), size: 32),
                        SizedBox(height: 8),
                        Text(
                          'Premium Feature',
                          style: TextStyle(
                            color: Color(0xFFFFD700),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
