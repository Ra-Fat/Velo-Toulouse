import '../../../../../models/subscription/subscription.dart';

class SubscriptionCopy {
  static String description(Subscription plan) {
    switch (plan.id) {
      case 'day':
        return 'Unlimited rides for one calendar day.';
      case 'monthly':
        return 'Best for regular commuters — billed monthly.';
      case 'annual':
        return 'Lowest per-day cost when you ride often.';
      default:
        return 'Flexible access to the bike network.';
    }
  }

  static String? promoLine(Subscription plan) {
    if (plan.id == 'annual') {
      return 'Save vs monthly';
    }
    return null;
  }
}