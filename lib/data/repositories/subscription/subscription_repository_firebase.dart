import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/firestore_paths.dart';
import '../../../models/subscription/subscription.dart';
import '../../dtos/subscription_dto.dart';
import 'subscription_repository.dart';

class SubscriptionRepositoryFirebase implements SubscriptionRepository {
  SubscriptionRepositoryFirebase({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  @override
  Future<List<Subscription>> fetchSubscriptions() async {
    final snapshot = await _db
        .collection(FirestorePaths.subscriptions)
        .orderBy(SubscriptionDto.sortOrderKey)
        .get();

    final list = <Subscription>[];
    for (final doc in snapshot.docs) {
      final sub = SubscriptionDto.fromFirestore(doc);
      if (sub.isActive) {
        list.add(sub);
      }
    }
    return list;
  }
}
