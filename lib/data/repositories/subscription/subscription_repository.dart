import '../../../models/subscription/subscription.dart';


abstract class SubscriptionRepository {
  Future<List<Subscription>> fetchSubscriptions();
}
