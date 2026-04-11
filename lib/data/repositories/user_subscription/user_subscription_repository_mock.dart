import '../../../services/app_session.dart';
import '../../../utils/subscription_enums.dart';
import '../../../models/user_subscription/user_subscription.dart';
import '../subscription/subscription_repository.dart';
import 'user_subscription_repository.dart';

/// In-memory user pass; [recordSubscriptionPurchase] uses [subscriptionRepository] to resolve plan duration.
class UserSubscriptionRepositoryMock implements UserSubscriptionRepository {
  UserSubscriptionRepositoryMock({
    required SubscriptionRepository subscriptionRepository,
    this.artificialDelay = const Duration(milliseconds: 400),
    this.simulateActiveSubscription = false,
  }) : _subscriptionRepository = subscriptionRepository;

  final SubscriptionRepository _subscriptionRepository;
  final Duration artificialDelay;

  /// When true, [AppSession.userId] has an active monthly pass (for testing the “current subscription” UI).
  final bool simulateActiveSubscription;

  /// Set by [recordSubscriptionPurchase] so the next fetch reflects the purchase.
  UserSubscription? _purchaseOverride;

  static final UserSubscription _activeForUser1 = UserSubscription(
    id: 'mock-user-sub',
    userId: AppSession.userId,
    subscriptionId: 'monthly',
    startsAt: DateTime.utc(2026, 4, 1),
    expiresAt: DateTime.utc(2027, 5, 1),
    isActive: true,
    createdAt: DateTime.utc(2026, 4, 1),
  );

  @override
  Future<UserSubscription?> fetchActiveUserSubscription(String userId) async {
    await Future<void>.delayed(artificialDelay);
    if (_purchaseOverride != null && _purchaseOverride!.userId == userId) {
      return _purchaseOverride;
    }
    if (!simulateActiveSubscription) return null;
    if (userId == AppSession.userId) {
      return _activeForUser1;
    }
    return null;
  }

  @override
  Future<void> recordSubscriptionPurchase({
    required String userId,
    required String subscriptionId,
  }) async {
    await Future<void>.delayed(artificialDelay);
    final catalog = await _subscriptionRepository.fetchSubscriptions();
    final plan = catalog.firstWhere(
      (s) => s.id == subscriptionId,
      orElse: () => throw StateError('Unknown subscription id: $subscriptionId'),
    );
    final now = DateTime.now();
    final expires = _expiryForPlan(now, plan.durationKind);
    _purchaseOverride = UserSubscription(
      id: 'mock-purchase-${now.millisecondsSinceEpoch}',
      userId: userId,
      subscriptionId: subscriptionId,
      startsAt: now,
      expiresAt: expires,
      isActive: true,
      createdAt: now,
    );
  }

  static DateTime _expiryForPlan(DateTime start, SubscriptionType kind) {
    switch (kind) {
      case SubscriptionType.day:
        return start.add(const Duration(days: 1));
      case SubscriptionType.monthly:
        return DateTime(start.year, start.month + 1, start.day, start.hour,
            start.minute, start.second);
      case SubscriptionType.annual:
        return DateTime(start.year + 1, start.month, start.day, start.hour,
            start.minute, start.second);
    }
  }
}
