// lib/features/recommendations/logic/subscription_provider.dart

import 'package:flutter/material.dart';
import 'package:aahar_ai/services/subscription_service.dart';

class SubscriptionProvider with ChangeNotifier {
  final SubscriptionService _subscriptionService;

  SubscriptionProvider(this._subscriptionService) {
    _checkSubscription();
  }

  bool _isPremium = false;
  int _remainingScanCount = 5;
  int _remainingChatCount = 10;

  bool get isPremium => _isPremium;
  int get remainingScanCount => _remainingScanCount;
  int get remainingChatCount => _remainingChatCount;

  Future<void> _checkSubscription() async {
    _isPremium = await _subscriptionService.isPremiumActive();
    _remainingScanCount = await _subscriptionService.getRemainingScanCount();
    _remainingChatCount = await _subscriptionService.getRemainingChatCount();
    notifyListeners();
  }

  Future<bool> upgradeToPremium({String? transactionId}) async {
    final success = await _subscriptionService.upgradeToPremium(transactionId: transactionId);
    if (success) {
      await _checkSubscription();
    }
    return success;
  }

  Future<void> refreshSubscriptionStatus() async {
    await _checkSubscription();
  }

  Future<void> cancelSubscription() async {
    await _subscriptionService.cancelSubscription();
    await _checkSubscription();
  }
}
