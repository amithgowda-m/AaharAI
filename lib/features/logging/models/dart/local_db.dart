// lib/features/logging/data/local_db.dart
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarService {
  static late Isar isar;
  
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [MealEntrySchema],
      directory: dir.path,
    );
  }
  
  // CRUD Operations
  Future<void> saveMeal(MealEntry meal) async {
    await isar.writeTxn(() async {
      await isar.mealEntrys.put(meal);
    });
  }
  
  Stream<List<MealEntry>> watchTodayMeals() {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    
    return isar.mealEntrys
      .filter()
      .timestampGreaterThan(startOfDay)
      .watch(fireImmediately: true);
  }
  
  Future<List<MealEntry>> getMealsByDateRange(DateTime start, DateTime end) async {
    return await isar.mealEntrys
      .filter()
      .timestampBetween(start, end)
      .sortByTimestampDesc()
      .findAll();
  }
}
