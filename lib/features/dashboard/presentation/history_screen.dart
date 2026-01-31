import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:isar/isar.dart'; // REQUIRED for .watch()
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Services & Entities
import 'package:aahar_ai/data/local/isar_service.dart';
import 'package:aahar_ai/data/local/entities/food_log.dart';
import 'package:aahar_ai/data/local/entities/user_profile.dart'; // To get the name
import 'package:aahar_ai/services/pdf_service.dart'; // To generate the PDF

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  String get _userId => Supabase.instance.client.auth.currentUser?.id ?? 'local_user';

  @override
  Widget build(BuildContext context) {
    // 1. Get the IsarService
    final isarService = context.read<IsarService>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Meal History",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        
        // --- PDF EXPORT BUTTON ---
        actions: [
          FutureBuilder<Isar>(
            future: isarService.db,
            builder: (context, snapshot) {
              // Wait for DB to be ready
              if (!snapshot.hasData) return const SizedBox.shrink();
              
              return IconButton(
                icon: const Icon(Icons.picture_as_pdf, color: Color(0xFF2E7D32)),
                tooltip: 'Export Professional Report',
                onPressed: () async {
                  final isar = snapshot.data!;
                  
                  // A. Fetch all logs for this user (Snapshot, not stream)
                  final logs = await isar.foodLogs
                      .filter()
                      .userIdEqualTo(_userId)
                      .sortByTimestampDesc()
                      .findAll();
                  
                  if (logs.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("No meals to export yet!")),
                    );
                    return;
                  }

                  // B. Fetch Real User Name
                  String userName = "Aahar User"; 
                  final profile = await isar.userProfiles.where().findFirst();
                  if (profile != null && profile.name.isNotEmpty) {
                    userName = profile.name;
                  }

                  // C. Generate PDF
                  await PdfService.generateAndPrintLog(logs, userName);
                },
              );
            },
          ),
          const SizedBox(width: 8),
        ],
        // -------------------------
      ),
      body: FutureBuilder<Isar>(
        // 2. Wait for DB to initialize
        future: isarService.db,
        builder: (context, dbSnapshot) {
          if (!dbSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF2E7D32)));
          }

          final isar = dbSnapshot.data!;

          // 3. WATCH the database for changes (Real-time updates)
          return StreamBuilder<List<FoodLog>>(
            stream: isar.foodLogs
                .filter()
                .userIdEqualTo(_userId)
                .sortByTimestampDesc()
                .watch(fireImmediately: true), 
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFF2E7D32)));
              }

              final logs = snapshot.data ?? [];

              if (logs.isEmpty) {
                return _emptyState();
              }

              // 4. Group logic by Date
              final grouped = _groupByDate(logs);
              final dates = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(height: 1),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                      itemCount: dates.length,
                      itemBuilder: (context, index) {
                        final date = dates[index];
                        final dayLogs = grouped[date]!;

                        return _DaySection(
                          date: date,
                          logs: dayLogs,
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  // ---------- HELPERS ----------

  Map<DateTime, List<FoodLog>> _groupByDate(List<FoodLog> logs) {
    final Map<DateTime, List<FoodLog>> map = {};
    for (final log in logs) {
      final day = DateTime(log.timestamp.year, log.timestamp.month, log.timestamp.day);
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
            Icons.history_rounded,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            "No meals logged yet",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Your food logs will appear here",
            style: TextStyle(color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}

// ---------------- DAY SECTION WIDGET ----------------

class _DaySection extends StatelessWidget {
  final DateTime date;
  final List<FoodLog> logs;

  const _DaySection({
    Key? key,
    required this.date,
    required this.logs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalCalories = logs.fold<double>(0, (s, e) => s + e.totalCalories);
    final totalProtein = logs.fold<double>(0, (s, e) => s + e.totalProtein);

    final isToday = DateUtils.isSameDay(date, DateTime.now());
    final dateString = isToday ? "Today" : DateFormat('EEEE, MMM dd').format(date);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ---------- DATE HEADER ----------
        Padding(
          padding: const EdgeInsets.only(bottom: 12, top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateString,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${totalCalories.toInt()} kcal • ${totalProtein.toStringAsFixed(1)}g P",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ),
            ],
          ),
        ),

        // ---------- MEALS LIST ----------
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey[200]!),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: logs.length,
            separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey[100]),
            itemBuilder: (context, index) {
              final log = logs[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      _getMealEmoji(log.mealType),
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                title: Text(
                  log.foodName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                subtitle: Text(
                  "${log.mealType} • ${DateFormat('hh:mm a').format(log.timestamp)}",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "${log.totalCalories.toInt()} kcal",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      "${log.totalProtein.toStringAsFixed(1)}g protein",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  String _getMealEmoji(String mealType) {
    switch (mealType.toLowerCase()) {
      case 'breakfast': return '🍳';
      case 'lunch': return '🍲';
      case 'dinner': return '🍽️';
      case 'snack': 
      case 'morning snack':
      case 'evening snack':
      case 'late night snack':
        return '🍎';
      default: return '🍱';
    }
  }
}