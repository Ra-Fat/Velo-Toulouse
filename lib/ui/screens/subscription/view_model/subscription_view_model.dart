import 'package:flutter/foundation.dart';

import '../../../../data/repositories/subscription/subscription_repository.dart';
import '../../../../data/repositories/user_subscription/user_subscription_repository.dart';
import '../../../../models/subscription/subscription.dart';
import '../../../../models/user_subscription/user_subscription.dart';
import '../../../states/subscription_state.dart';
import '../../../../utils/async_value.dart';

class SubscriptionViewModel extends ChangeNotifier {
  SubscriptionViewModel({
    required SubscriptionRepository subscriptionRepository,
    required UserSubscriptionRepository userSubscriptionRepository,
    this.userId = '1',
  })  : _subscriptionRepository = subscriptionRepository,
        _userSubscriptionRepository = userSubscriptionRepository;

  final SubscriptionRepository _subscriptionRepository;
  final UserSubscriptionRepository _userSubscriptionRepository;
  final String userId;

  SubscriptionState _state = SubscriptionState(
    catalog: AsyncValue<List<Subscription>>.loading(),
    activeSubscription: AsyncValue<UserSubscription?>.loading(),
  );

  SubscriptionState get state => _state;

  Future<void> load() async {
    _state = _state.copyWith(
      catalog: AsyncValue<List<Subscription>>.loading(),
      activeSubscription: AsyncValue<UserSubscription?>.loading(),
    );
    notifyListeners();

    try {
      final catalog = await _subscriptionRepository.fetchSubscriptions();
      final active =
          await _userSubscriptionRepository.fetchActiveUserSubscription(userId);
      final picked = _pickDefaultSelection(catalog, _state.selected);
      _state = SubscriptionState(
        catalog: AsyncValue<List<Subscription>>.success(catalog),
        activeSubscription: AsyncValue<UserSubscription?>.success(active),
        selected: picked,
      );
    } catch (e) {
      _state = SubscriptionState(
        catalog: AsyncValue<List<Subscription>>.error(e),
        activeSubscription: AsyncValue<UserSubscription?>.error(e),
        selected: _state.selected,
      );
    }
    notifyListeners();
  }

  void select(Subscription subscription) {
    _state = _state.copyWith(selected: subscription);
    notifyListeners();
  }

  static Subscription? _pickDefaultSelection(
    List<Subscription> catalog,
    Subscription? current,
  ) {
    if (current != null) {
      for (final s in catalog) {
        if (s.id == current.id) return s;
      }
    }
    for (final s in catalog) {
      if (s.id == 'monthly') return s;
    }
    return catalog.isNotEmpty ? catalog.first : null;
  }
}
