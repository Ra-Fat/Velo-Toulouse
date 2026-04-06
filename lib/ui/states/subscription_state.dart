import 'package:project/models/subscription/subscription.dart';
import 'package:project/models/user_subscription/user_subscription.dart';
import 'package:project/ui/utils/async_value.dart';

class SubscriptionState {
  const SubscriptionState({
    required this.catalog,
    required this.activeSubscription,
    this.selected,
  });

  final AsyncValue<List<Subscription>> catalog;
  final AsyncValue<UserSubscription?> activeSubscription;
  final Subscription? selected;

  bool get isLoading {
    return catalog.state == AsyncValueState.loading ||
        activeSubscription.state == AsyncValueState.loading;
  }

  bool get hasError {
    return catalog.state == AsyncValueState.error ||
        activeSubscription.state == AsyncValueState.error;
  }

  /// Valid paid pass: active row, not expired.
  bool get hasActivePass {
    if (catalog.state != AsyncValueState.success ||
        activeSubscription.state != AsyncValueState.success) {
      return false;
    }
    final UserSubscription? active = activeSubscription.data;
    if (active == null || !active.isActive) return false;
    return active.expiresAt.isAfter(DateTime.now());
  }

  SubscriptionState copyWith({
    AsyncValue<List<Subscription>>? catalog,
    AsyncValue<UserSubscription?>? activeSubscription,
    Subscription? selected,
  }) {
    return SubscriptionState(
      catalog: catalog ?? this.catalog,
      activeSubscription: activeSubscription ?? this.activeSubscription,
      selected: selected ?? this.selected,
    );
  }
}
