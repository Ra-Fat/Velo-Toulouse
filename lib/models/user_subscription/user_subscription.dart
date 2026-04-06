import 'package:flutter/foundation.dart';

/// User's purchase / entitlement to a catalog subscription.
@immutable
class UserSubscription {
  const UserSubscription({
    required this.id,
    required this.userId,
    required this.subscriptionId,
    required this.startsAt,
    required this.expiresAt,
    required this.isActive,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final String subscriptionId;
  final DateTime startsAt;
  final DateTime expiresAt;
  final bool isActive;
  final DateTime createdAt;

  @override
  String toString() {
    return 'UserSubscription(id: $id, userId: $userId, subscriptionId: $subscriptionId, startsAt: $startsAt, expiresAt: $expiresAt, isActive: $isActive, createdAt: $createdAt)';
  }
}
