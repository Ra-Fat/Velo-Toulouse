import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/models/subscription/subscription.dart';

import '../../core/subscription_enums.dart';

class SubscriptionDto {
  static const String idKey = 'id';
  static const String nameKey = 'name';
  static const String priceEurosKey = 'price_euros';
  static const String durationKindKey = 'duration_kind';
  static const String isActiveKey = 'is_active';
  static const String sortOrderKey = 'sort_order';

  static Subscription fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Subscription document ${doc.id} has no data');
    }

    assert(data[nameKey] is String);
    assert(data[priceEurosKey] is num);
    assert(data[durationKindKey] is String);
    assert(data[isActiveKey] is bool);
    assert(data[sortOrderKey] is num);

    return Subscription(
      id: doc.id,
      name: data[nameKey],
      priceEuros: (data[priceEurosKey] as num).toDouble(),
      durationKind: SubscriptionTypeX.fromDurationKind(data[durationKindKey] as String),
      isActive: data[isActiveKey],
      sortOrder: (data[sortOrderKey] as num).toInt(),
    );
  }

  /// Convert Subscription to Firestore-compatible map
  static Map<String, dynamic> toFirestore(Subscription subscription) {
    return {
      idKey: subscription.id,
      nameKey: subscription.name,
      priceEurosKey: subscription.priceEuros,
      durationKindKey: subscription.durationKind.name,
      isActiveKey: subscription.isActive,
      sortOrderKey: subscription.sortOrder,
    };
  }
}
