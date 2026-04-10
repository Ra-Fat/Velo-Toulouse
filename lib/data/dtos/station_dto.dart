import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/station/station.dart';

class StationDto {
  static const String nameKey = 'name';
  static const String isActiveKey = 'is_active';
  static const String latitudeKey = 'latitude';
  static const String longitudeKey = 'longitude';
  static const String codeKey = 'code';
  static const String availableBikesCountKey = 'available_bikes_count';

  static Station fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Station ${doc.id} has no data');
    }
    return Station(
      id: doc.id,
      name: data[nameKey] as String,
      isActive: data[isActiveKey] as bool,
      latitude: (data[latitudeKey] as num).toDouble(),
      longitude: (data[longitudeKey] as num).toDouble(),
      code: data[codeKey] as String? ?? doc.id,
      availableBikesCount: (data[availableBikesCountKey] as num?)?.toInt() ?? 0,
    );
  }
}