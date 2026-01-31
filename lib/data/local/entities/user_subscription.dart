import 'package:isar/isar.dart';

part 'user_subscription.g.dart';

@collection
class UserSubscription {
  Id id = Isar.autoIncrement;

  late String userId;
  late String subscriptionType; // free, premium, premium_plus
  
  late DateTime startDate;
  DateTime? endDate;
  
  bool isActive = true;
  bool autoRenew = false;
  
  // Usage tracking
  int dailyScanCount = 0;
  int dailyChatCount = 0;
  late DateTime lastResetDate;
  
  late DateTime createdAt;
  late DateTime updatedAt;
}