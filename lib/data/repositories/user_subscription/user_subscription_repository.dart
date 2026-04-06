import '../../../models/user_subscription/user_subscription.dart';

abstract class UserSubscriptionRepository {
  /// Active pass for [userId], if any (seed: at most one `is_active`).
  Future<UserSubscription?> fetchActiveUserSubscription(String userId);

  /// Deactivates prior active rows and creates a new `user_subscriptions` document.
  Future<void> recordSubscriptionPurchase({
    required String userId,
    required String subscriptionId,
  });
}
