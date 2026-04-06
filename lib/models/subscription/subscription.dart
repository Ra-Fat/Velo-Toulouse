import 'package:flutter/foundation.dart';

import '../../core/subscription_enums.dart';

/// Catalog subscription (immutable domain entity).
@immutable
class Subscription {
  const Subscription({
    required this.id,
    required this.name,
    required this.priceEuros,
    required this.durationKind,
    required this.isActive,
    required this.sortOrder,
  });

  final String id;
  final String name;
  final double priceEuros;
  final SubscriptionType durationKind;
  final bool isActive;
  final int sortOrder;

  @override
  String toString() {
    return 'Subscription(id: $id, name: $name, priceEuros: $priceEuros, durationKind: $durationKind, isActive: $isActive, sortOrder: $sortOrder)';
  }
}
