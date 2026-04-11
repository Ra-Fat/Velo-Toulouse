import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../utils/firestore_paths.dart';
import '../../../models/station/station.dart';
import '../../dtos/station_dto.dart';
import 'station_repository.dart';

class StationRepositoryFirebase implements StationRepository {
  StationRepositoryFirebase({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  @override
  Future<List<Station>> fetchStations() async {
    final snapshot = await _db.collection(FirestorePaths.stations).get();
    final list = <Station>[];
    for (final doc in snapshot.docs) {
      final station = StationDto.fromFirestore(doc);
      if (station.isActive) {
        list.add(station);
      }
    }
    list.sort((a, b) => a.name.compareTo(b.name));
    return list;
  }
}