// lib/features/dashboard/presentation/widgets/macro_bars.dart - CREATE THIS FILE 📝

import 'package:flutter/material.dart';

class MacroProgressBar extends StatelessWidget {
  final String name;
  final double consumed;
  final double target;
  final Color color;

  const MacroProgressBar({
    Key? key,
    required this.name,
    required this.consumed,
    required this.target,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final percentage = ((consumed / target) * 100).toInt();
    final progress = (consumed / target).clamp(0.0, 1.0);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$name: $percentage%',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            Text(
              '${consumed.toInt()}g / ${target.toInt()}g',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
        SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}
