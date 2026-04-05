/// Static catalog for the subscription UI (no backend).
class SubscriptionPlan {
  const SubscriptionPlan({
    required this.id,
    required this.title,
    required this.priceEuros,
    required this.description,
    required this.detailLine,
    this.promoLine,
  });

  final String id;
  final String title;
  final double priceEuros;
  final String description;
  final String detailLine;
  final String? promoLine;

  String get priceLabel {
    if (priceEuros == priceEuros.roundToDouble()) {
      return '€${priceEuros.toStringAsFixed(0)}';
    }
    return '€${priceEuros.toStringAsFixed(2)}';
  }
}

const List<SubscriptionPlan> kSubscriptionPlans = [
  SubscriptionPlan(
    id: 'monthly',
    title: 'Monthly Pass',
    priceEuros: 29.90,
    description: 'Unlimited 45 min rides — Auto-renews monthly',
    detailLine: 'Renews monthly — cancel anytime',
    promoLine: 'Free first 3 days',
  ),
  SubscriptionPlan(
    id: 'annual',
    title: 'Annual Pass',
    priceEuros: 249,
    description: 'Save 30% vs monthly — Best value',
    detailLine: 'Valid 12 months from start',
    promoLine: 'Cancel anytime',
  ),
  SubscriptionPlan(
    id: 'day',
    title: 'Day Pass',
    priceEuros: 4.90,
    description: 'Valid 24 hours — No commitment',
    detailLine: 'Single day access',
  ),
];

SubscriptionPlan planById(String id) =>
    kSubscriptionPlans.firstWhere((p) => p.id == id);
