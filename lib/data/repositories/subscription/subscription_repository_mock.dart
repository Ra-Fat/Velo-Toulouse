import '../../../utils/subscription_enums.dart';
import '../../../models/subscription/subscription.dart';
import 'subscription_repository.dart';

/// Offline catalog aligned with `lib/scripts/seed/index.js`.
class SubscriptionRepositoryMock implements SubscriptionRepository {
  SubscriptionRepositoryMock({this.artificialDelay = const Duration(milliseconds: 400)});

  final Duration artificialDelay;

  static final List<Subscription> _catalog = <Subscription>[
    Subscription(
      id: 'day',
      name: 'Day Pass',
      priceEuros: 2,
      durationKind: SubscriptionType.day,
      isActive: true,
      sortOrder: 0,
    ),
    Subscription(
      id: 'monthly',
      name: 'Monthly Pass',
      priceEuros: 29.9,
      durationKind: SubscriptionType.monthly,
      isActive: true,
      sortOrder: 1,
    ),
    Subscription(
      id: 'annual',
      name: 'Annual Pass',
      priceEuros: 150,
      durationKind: SubscriptionType.annual,
      isActive: true,
      sortOrder: 2,
    ),
  ];

  @override
  Future<List<Subscription>> fetchSubscriptions() async {
    await Future<void>.delayed(artificialDelay);
    return List<Subscription>.unmodifiable(_catalog);
  }
}
