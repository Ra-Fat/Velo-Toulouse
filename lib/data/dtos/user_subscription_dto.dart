import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/models/user_subscription/user_subscription.dart';

class UserSubscriptionDto {
  static const String userIdKey = 'user_id';
  static const String subscriptionIdKey = 'subscription_id';
  static const String startsAtKey = 'starts_at';
  static const String expiresAtKey = 'expires_at';
  static const String isActiveKey = 'is_active';
  static const String createdAtKey = 'created_at';

  final String id;
  final String userId;
  final String subscriptionId;
  final DateTime startsAt;
  final DateTime expiresAt;
  final bool isActive;
  final DateTime createdAt;

  const UserSubscriptionDto({
    required this.id,
    required this.userId,
    required this.subscriptionId,
    required this.startsAt,
    required this.expiresAt,
    required this.isActive,
    required this.createdAt,
  });

  static UserSubscription fromFirestore(String id, Map<String, dynamic> json) {
    assert(json[userIdKey] is String);
    assert(json[subscriptionIdKey] is String);
    assert(json[startsAtKey] is Timestamp);
    assert(json[expiresAtKey] is Timestamp);
    assert(json[isActiveKey] is bool);
    assert(json[createdAtKey] is Timestamp);

    return UserSubscription(
      id: id,
      userId: json[userIdKey],
      subscriptionId: json[subscriptionIdKey],
      startsAt: (json[startsAtKey] as Timestamp).toDate(),
      expiresAt: (json[expiresAtKey] as Timestamp).toDate(),
      isActive: json[isActiveKey],
      createdAt: (json[createdAtKey] as Timestamp).toDate(),
    );
  }

  /// Convert UserSubscriptionDto to Firestore JSON
  Map<String, dynamic> toFirestore() {
    return {
      userIdKey: userId,
      subscriptionIdKey: subscriptionId,
      startsAtKey: Timestamp.fromDate(startsAt),
      expiresAtKey: Timestamp.fromDate(expiresAt),
      isActiveKey: isActive,
      createdAtKey: Timestamp.fromDate(createdAt),
    };
  }
}
