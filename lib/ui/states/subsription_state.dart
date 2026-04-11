import 'package:project/utils/async_value.dart';
import 'package:project/models/subscription/subscription.dart';
import 'package:project/models/user_subscription/user_subscription.dart';

class SubscriptionState {
  const SubscriptionState({
    required this.catalog,
    required this.activeSubscription,
    this.selected,
  });

  final AsyncValue<List<Subscription>> catalog;
  final AsyncValue<UserSubscription?> activeSubscription;
  final Subscription? selected;

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