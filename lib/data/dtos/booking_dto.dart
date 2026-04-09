import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/booking/booking.dart';

class BookingDto {
  static const String userIdKey = 'user_id';
  static const String bikeIdKey = 'bike_id';
  static const String stationIdKey = 'station_id';
  static const String slotIdKey = 'slot_id';
  static const String reservedAtKey = 'reserved_at';

  static Booking fromFirestore(
    String id,
    Map<String, dynamic> data,
  ) {
    final reservedRaw = data[reservedAtKey];
    if (reservedRaw is! Timestamp) {
      throw FormatException('booking.$reservedAtKey must be Timestamp');
    }
    return Booking(
      id: id,
      userId: data[userIdKey] as String,
      bikeId: data[bikeIdKey] as String,
      stationId: data[stationIdKey] as String,
      slotId: data[slotIdKey] as String,
      reservedAt: reservedRaw.toDate(),
    );
  }
}
