import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../utils/firestore_paths.dart';
import '../../../utils/subscription_enums.dart';
import '../../../models/user_subscription/user_subscription.dart';
import '../../dtos/subscription_dto.dart';
import '../../dtos/user_subscription_dto.dart';
import 'user_subscription_repository.dart';

class UserSubscriptionRepositoryFirebase implements UserSubscriptionRepository {
  UserSubscriptionRepositoryFirebase({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  @override
  Future<UserSubscription?> fetchActiveUserSubscription(String userId) async {
    final snapshot = await _db
        .collection(FirestorePaths.userSubscriptions)
        .where(UserSubscriptionDto.userIdKey, isEqualTo: userId)
        .where(UserSubscriptionDto.isActiveKey, isEqualTo: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    final doc = snapshot.docs.single;
    return UserSubscriptionDto.fromFirestore(doc.id, doc.data());
  }

  @override
  Future<void> recordSubscriptionPurchase({
    required String userId,
    required String subscriptionId,
  }) async {
    final planRef =
        _db.collection(FirestorePaths.subscriptions).doc(subscriptionId);
    final planSnap = await planRef.get();
    if (!planSnap.exists) {
      throw StateError('Unknown subscription id: $subscriptionId');
    }
    final plan = SubscriptionDto.fromFirestore(planSnap);
    final now = DateTime.now();
    final expires = _expiryForPlan(now, plan.durationKind);

    final batch = _db.batch();
    final existing = await _db
        .collection(FirestorePaths.userSubscriptions)
        .where(UserSubscriptionDto.userIdKey, isEqualTo: userId)
        .where(UserSubscriptionDto.isActiveKey, isEqualTo: true)
        .get();

    for (final d in existing.docs) {
      batch.update(d.reference, {UserSubscriptionDto.isActiveKey: false});
    }

    final newRef = _db.collection(FirestorePaths.userSubscriptions).doc();
    batch.set(newRef, <String, dynamic>{
      UserSubscriptionDto.userIdKey: userId,
      UserSubscriptionDto.subscriptionIdKey: subscriptionId,
      UserSubscriptionDto.startsAtKey: FieldValue.serverTimestamp(),
      UserSubscriptionDto.expiresAtKey: Timestamp.fromDate(expires),
      UserSubscriptionDto.isActiveKey: true,
      UserSubscriptionDto.createdAtKey: FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  static DateTime _expiryForPlan(DateTime start, SubscriptionType kind) {
    switch (kind) {
      case SubscriptionType.day:
        return start.add(const Duration(days: 1));
      case SubscriptionType.monthly:
        return DateTime(
          start.year,
          start.month + 1,
          start.day,
          start.hour,
          start.minute,
          start.second,
        );
      case SubscriptionType.annual:
        return DateTime(
          start.year + 1,
          start.month,
          start.day,
          start.hour,
          start.minute,
          start.second,
        );
    }
  }
}
