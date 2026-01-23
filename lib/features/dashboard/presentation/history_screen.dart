import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../data/local/isar_service.dart';
import '../../../data/local/entities/food_log.dart';

// ---------------- PROVIDERS ----------------

final isarProvider = Provider((ref) => IsarService());

final historyLogsProvider =
    FutureProvider.autoDispose<List<FoodLog>>((ref) async {
  final service = ref.read(isarProvider);
  return service.getAllLogs();
});

// ---------------- SCREEN ----------------

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(historyLogsProvider);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0F2027),
            Color(0xFF203A43),
            Color(0xFF2C5364),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),

          // ---------- HEADER ----------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: const [
                Text(
                  "Meal History 📜",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ---------- LIST ----------
          Expanded(
            child: logsAsync.when(
              data: (logs) {
                if (logs.isEmpty) {
                  return _emptyState();
                }

                final grouped = _groupByDate(logs);
                final dates = grouped.keys.toList()
                  ..sort((a, b) => b.compareTo(a));

                return ListView.builder(
                  padding:
                      const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  itemCount: dates.length,
                  itemBuilder: (context, index) {
                    final date = dates[index];
                    final dayLogs = grouped[date]!;

                    return _DaySection(
                      date: date,
                      logs: dayLogs,
                    );
                  },
                );
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (_, __) =>
                  const Center(child: Text("Failed to load history")),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- HELPERS ----------

  Map<DateTime, List<FoodLog>> _groupByDate(List<FoodLog> logs) {
    final Map<DateTime, List<FoodLog>> map = {};
    for (final log in logs) {
      final day =
          DateTime(log.timestamp.year, log.timestamp.month, log.timestamp.day);
      map.putIfAbsent(day, () => []).add(log);
    }
    return map;
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 52,
            color: Colors.white.withOpacity(0.35),
          ),
          const SizedBox(height: 12),
          const Text(
            "No history yet",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Text(
            "Your logged meals will appear here",
            style: TextStyle(color: Colors.white.withOpacity(0.6)),
          ),
        ],
      ),
    );
  }
}

// ---------------- DAY SECTION ----------------

class _DaySection extends StatelessWidget {
  final DateTime date;
  final List<FoodLog> logs;

  const _DaySection({
    required this.date,
    required this.logs,
  });

  @override
  Widget build(BuildContext context) {
    final totalCalories =
        logs.fold<double>(0, (s, e) => s + e.calories);
    final totalProtein =
        logs.fold<double>(0, (s, e) => s + e.protein);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ---------- DATE HEADER ----------
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('MMM dd, yyyy').format(date),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "${totalCalories.toInt()} kcal / ${totalProtein.toStringAsFixed(1)}g P",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),

        // ---------- MEALS ----------
        ...logs.map(
          (log) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              children: [
                const Icon(
                  Icons.circle,
                  size: 8,
                  color: Color(0xFFFFB86C),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        log.foodName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        DateFormat('hh:mm a').format(log.timestamp),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),

                Text(
                  "${log.calories.toInt()} kcal",
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),

        Divider(
          color: Colors.white.withOpacity(0.08),
          thickness: 1,
          height: 28,
        ),
      ],
    );
  }
}

