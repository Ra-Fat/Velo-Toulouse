import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/bike/bike.dart';

class BikeDto {
  static const String numberKey = 'number';
  static const String statusKey = 'status';
  static const String currentStationIdKey = 'current_station_id';
  static const String currentSlotIdKey = 'current_slot_id';

  static BikeStatus _mapStatus(String status) {
    switch (status) {
      case 'available':
        return BikeStatus.available;
      case 'reserved':
        return BikeStatus.reserved;
      case 'maintenance':
        return BikeStatus.maintenance;
      default:
        throw ArgumentError('Unknown bike status: $status');
    }
  }

  static String _mapStatusToString(BikeStatus status) {
    switch (status) {
      case BikeStatus.available:
        return 'available';
      case BikeStatus.reserved:
        return 'reserved';
      case BikeStatus.maintenance:
        return 'maintenance';
    }
  }

  static Bike fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Bike ${doc.id} has no data');
    }

    return Bike(
      id: doc.id,
      number: data[numberKey] as String,
      status: _mapStatus(data[statusKey] as String),
      currentStationId: data[currentStationIdKey] as String,
      currentSlotId: data[currentSlotIdKey] as String,
    );
  }

  static Map<String, dynamic> toFirestore(Bike bike) {
    return {
      numberKey: bike.number,
      statusKey: _mapStatusToString(bike.status),
      currentStationIdKey: bike.currentStationId,
      currentSlotIdKey: bike.currentSlotId,
    };
  }
}