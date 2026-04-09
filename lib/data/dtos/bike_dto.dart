import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/bike/bike.dart';

class BikeDto {
  static const String numberKey = 'number';
  static const String statusKey = 'status';
  static const String currentStationIdKey = 'current_station_id';
  static const String currentSlotIdKey = 'current_slot_id';

  static const String statusAvailable = 'available';

  static Bike fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Bike ${doc.id} has no data');
    }
    return Bike(
      id: doc.id,
      number: data[numberKey] as String,
      status: data[statusKey] as String,
      currentStationId: data[currentStationIdKey] as String,
      currentSlotId: data[currentSlotIdKey] as String,
    );
  }
}