import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../utils/firestore_paths.dart';
import '../../../models/bike/bike.dart';
import '../../dtos/bike_dto.dart';
import 'bike_repository.dart';

class BikeRepositoryFirebase implements BikeRepository {
  BikeRepositoryFirebase({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  @override
  Future<List<Bike>> fetchAvailableBikesForStation(String stationId) async {
    final snapshot = await _db
        .collection(FirestorePaths.bikes)
        .where(BikeDto.currentStationIdKey, isEqualTo: stationId)
        .where(BikeDto.statusKey, isEqualTo: 'available')
        .get();

    final list = snapshot.docs.map(BikeDto.fromFirestore).toList();
    list.sort((a, b) => a.number.compareTo(b.number));
    return list;
  }
}