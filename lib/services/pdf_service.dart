import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:aahar_ai/data/local/entities/food_log.dart';

class PdfService {
  
  static Future<void> generateAndPrintLog(List<FoodLog> logs, String userName) async {
    final pdf = pw.Document();
    
    // Sort logs by date (newest first)
    logs.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    // --- ANALYTICS LOGIC ---
    final Map<String, List<FoodLog>> foodGroups = {};
    
    for (var log in logs) {
      final key = log.foodName.trim().toLowerCase();
      if (!foodGroups.containsKey(key)) {
        foodGroups[key] = [];
      }
      foodGroups[key]!.add(log);
    }

    final List<Map<String, dynamic>> stats = [];
    foodGroups.forEach((key, list) {
      double totalCals = 0;
      for (var item in list) totalCals += item.totalCalories;
      
      stats.add({
        'name': list.first.foodName, 
        'count': list.length,
        'avg_cal': (totalCals / list.length).round(),
        'total_cal': totalCals.round(),
      });
    });

    stats.sort((a, b) => (b['count'] as int).compareTo(a['count'] as int));
    final topFoods = stats.take(5).toList();

    // --- PDF GENERATION ---
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        
        // FIX: Footer is the ONLY place where pageNumber works correctly
        footer: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Divider(color: PdfColors.grey300),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Aahar AI - Personalized Nutrition', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
                  pw.Text('Page ${context.pageNumber} of ${context.pagesCount}', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
                ],
              ),
            ],
          );
        },
        
        build: (pw.Context context) {
          return [
            // 1. Header Section
            _buildProfessionalHeader(userName, logs.length),
            pw.SizedBox(height: 20),

            // 2. "Eating Habits" Insight Section
            pw.Text('Eating Habits Analysis', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.green800)),
            pw.SizedBox(height: 8),
            _buildStatsTable(topFoods),
            pw.SizedBox(height: 24),

            // 3. Detailed Logs Section
            pw.Text('Detailed Meal History', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.green800)),
            pw.SizedBox(height: 8),
            _buildLogTable(logs),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'AaharAI_Report_${DateFormat('yyyyMMdd').format(DateTime.now())}',
    );
  }

  static pw.Widget _buildProfessionalHeader(String name, int count) {
    return pw.Container(
      decoration: const pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: PdfColors.green, width: 2)),
      ),
      padding: const pw.EdgeInsets.only(bottom: 10),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('AAHAR AI', style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold, color: PdfColors.green900)),
              pw.Text('Nutrition Report', style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700)),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(name, style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.Text(DateFormat('MMMM d, yyyy').format(DateTime.now()), style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700)),
              pw.Text('Total Entries: $count', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildStatsTable(List<Map<String, dynamic>> stats) {
    if (stats.isEmpty) return pw.Text("Not enough data for analysis.");

    return pw.TableHelper.fromTextArray(
      headers: ['Top Food Item', 'Times Eaten', 'Avg Cals / Serving', 'Total Consumption'],
      data: stats.map((item) {
        return [
          item['name'],
          '${item['count']}x',
          '${item['avg_cal']} kcal',
          '${item['total_cal']} kcal',
        ];
      }).toList(),
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white, fontSize: 10),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.green700),
      cellStyle: const pw.TextStyle(fontSize: 10),
      cellHeight: 25,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.center,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.centerRight,
      },
      oddRowDecoration: const pw.BoxDecoration(color: PdfColors.grey100),
    );
  }

  static pw.Widget _buildLogTable(List<FoodLog> logs) {
    return pw.TableHelper.fromTextArray(
      headers: ['Date', 'Time', 'Meal', 'Food Item', 'Calories', 'Protein'],
      data: logs.map((log) {
        return [
          DateFormat('MMM d').format(log.timestamp),
          DateFormat('h:mm a').format(log.timestamp),
          log.mealType,
          log.foodName,
          '${log.totalCalories.round()}',
          '${log.totalProtein.round()}g',
        ];
      }).toList(),
      border: pw.TableBorder.symmetric(inside: const pw.BorderSide(color: PdfColors.grey300, width: 0.5)),
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.black, fontSize: 10),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
      cellStyle: const pw.TextStyle(fontSize: 9),
      cellHeight: 22,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerLeft,
        3: pw.Alignment.centerLeft,
        4: pw.Alignment.centerRight,
        5: pw.Alignment.centerRight,
      },
    );
  }
}