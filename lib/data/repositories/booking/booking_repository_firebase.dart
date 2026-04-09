import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/firestore_paths.dart';
import '../../../models/booking/booking_details.dart';
import '../../dtos/booking_dto.dart';
import 'booking_repository.dart';

class BookingRepositoryFirebase implements BookingRepository {
  BookingRepositoryFirebase({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  @override
  Future<BookingDetails?> fetchLatestBookingDetails(String userId) async {
    // Composite index: user_id ASC, reserved_at DESC
    final snapshot = await _db
        .collection(FirestorePaths.bookings)
        .where(BookingDto.userIdKey, isEqualTo: userId)
        .orderBy(BookingDto.reservedAtKey, descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;

    final doc = snapshot.docs.single;
    final booking = BookingDto.fromFirestore(doc.id, doc.data());
    final stationSnap =
        await _db.collection(FirestorePaths.stations).doc(booking.stationId).get();
    final bikeSnap =
        await _db.collection(FirestorePaths.bikes).doc(booking.bikeId).get();
    final slotSnap =
        await _db.collection(FirestorePaths.slots).doc(booking.slotId).get();

    final stationName = stationSnap.data()?['name'] as String? ?? booking.stationId;
    final bikeNumber = bikeSnap.data()?['number'] as String? ?? booking.bikeId;
    final slotLabel = slotSnap.data()?['label'] as String? ?? booking.slotId;

    return BookingDetails(
      booking: booking,
      stationName: stationName,
      bikeNumber: bikeNumber,
      slotLabel: slotLabel,
    );
  }
}
