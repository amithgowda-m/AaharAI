import 'package:aahar_ai/data/local/isar_service.dart';
import 'package:aahar_ai/data/local/entities/user_subscription.dart';

class SubscriptionService {
  final IsarService _isarService;

  SubscriptionService(this._isarService);

  Future<void> initializeFreeSubscription() async {
    final existing = await _isarService.getSubscription();
    if (existing == null) {
      final now = DateTime.now();
      final sub = UserSubscription()
        ..userId = 'local_user' // Replace with actual ID if available
        ..subscriptionType = 'free'
        ..startDate = now
        ..isActive = true
        ..dailyScanCount = 0
        ..dailyChatCount = 0
        ..lastResetDate = now
        ..createdAt = now
        ..updatedAt = now;
      
      await _isarService.saveSubscription(sub);
    }
  }

  Future<bool> isPremiumActive() async {
    final sub = await _isarService.getSubscription();
    if (sub == null) return false;
    return sub.isActive && (sub.subscriptionType == 'premium' || sub.subscriptionType == 'premium_plus');
  }

  Future<int> getRemainingScanCount() async {
    return await _isarService.getRemainingScanCount();
  }

  Future<int> getRemainingChatCount() async {
    return await _isarService.getRemainingChatCount();
  }

  Future<bool> upgradeToPremium({String? transactionId}) async {
    final sub = await _isarService.getSubscription();
    if (sub != null) {
      sub.subscriptionType = 'premium';
      sub.updatedAt = DateTime.now();
      await _isarService.saveSubscription(sub);
      return true;
    }
    return false;
  }

  Future<void> cancelSubscription() async {
    final sub = await _isarService.getSubscription();
    if (sub != null) {
      sub.subscriptionType = 'free';
      sub.updatedAt = DateTime.now();
      await _isarService.saveSubscription(sub);
    }
  }
}