import 'package:isar/isar.dart';

part 'user_profile.g.dart';

@collection
class UserProfile {
  Id id = Isar.autoIncrement;

  @Index(unique: true) // Optimize search
  late String userId;  
  
  late String name;
  late int age;
  late double weight;
  late double height;
  late String gender;
  late String goal;
  late int dailyCalorieTarget;
  
  double? weeklyBudget; 
}