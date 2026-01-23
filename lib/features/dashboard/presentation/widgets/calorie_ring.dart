// lib/features/dashboard/presentation/widgets/calorie_ring.dart - CREATE THIS FILE 📝

import 'package:flutter/material.dart';

class CalorieRing extends StatelessWidget {
  final double consumed;
  final double target;

  const CalorieRing({
    Key? key,
    required this.consumed,
    required this.target,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = (consumed / target).clamp(0.0, 1.0);
    
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 160,
          height: 160,
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: 14,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation(
              progress > 0.9 ? Colors.orange : Color(0xFF2E7D32),
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${consumed.toInt()}',
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              'of ${target.toInt()} Cal',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
