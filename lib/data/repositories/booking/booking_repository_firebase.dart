import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../utils/firestore_paths.dart';
import '../../../models/booking/booking.dart';
import '../../../models/booking/booking_details.dart';
import '../../dtos/booking_dto.dart';
import 'booking_repository.dart';

class BookingRepositoryFirebase implements BookingRepository {
  BookingRepositoryFirebase({FirebaseFirestore? firestore})
    : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  Future<BookingDetails> _hydrateDetails(Booking booking) async {
    final stationSnap = await _db
        .collection(FirestorePaths.stations)
        .doc(booking.stationId)
        .get();
    final bikeSnap = await _db
        .collection(FirestorePaths.bikes)
        .doc(booking.bikeId)
        .get();
    final slotSnap = await _db
        .collection(FirestorePaths.slots)
        .doc(booking.slotId)
        .get();

    final stationName =
        stationSnap.data()?['name'] as String? ?? booking.stationId;
    final bikeNumber = bikeSnap.data()?['number'] as String? ?? booking.bikeId;
    final slotLabel = slotSnap.data()?['label'] as String? ?? booking.slotId;

    return BookingDetails(
      booking: booking,
      stationName: stationName,
      bikeNumber: bikeNumber,
      slotLabel: slotLabel,
    );
  }

  @override
  Future<BookingDetails?> fetchLatestBookingDetails(String userId) async {
    try {
      final snapshot = await _db
          .collection(FirestorePaths.bookings)
          .where(BookingDto.userIdKey, isEqualTo: userId)
          .orderBy(BookingDto.reservedAtKey, descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;

      final latest = BookingDto.fromFirestore(
        snapshot.docs.first.id,
        snapshot.docs.first.data(),
      );
      if (!latest.isActive) return null;
      return _hydrateDetails(latest);
    } on FirebaseException catch (e) {
      if (e.code != 'failed-precondition') rethrow;

      // Fallback when composite index is not created yet.
      final snapshot = await _db
          .collection(FirestorePaths.bookings)
          .where(BookingDto.userIdKey, isEqualTo: userId)
          .get();

      Booking? latest;
      for (final doc in snapshot.docs) {
        final booking = BookingDto.fromFirestore(doc.id, doc.data());
        if (!booking.isActive) continue;
        if (latest == null || booking.reservedAt.isAfter(latest.reservedAt)) {
          latest = booking;
        }
      }

      if (latest == null) return null;
      return _hydrateDetails(latest);
    }
  }

  @override
  Future<BookingDetails> createBooking({
    required String userId,
    required String bikeId,
    required String stationId,
    required String slotId,
  }) async {
    final reservedAt = Timestamp.now();
    final bookingRef = _db.collection(FirestorePaths.bookings).doc();

    await _db.runTransaction((tx) async {
      tx.update(_db.collection(FirestorePaths.bikes).doc(bikeId), {
        'status': 'reserved',
      });
      tx.set(bookingRef, {
        BookingDto.userIdKey: userId,
        BookingDto.bikeIdKey: bikeId,
        BookingDto.stationIdKey: stationId,
        BookingDto.slotIdKey: slotId,
        BookingDto.isActiveKey: true,
        BookingDto.reservedAtKey: reservedAt,
      });
    });

    final booking = Booking(
      id: bookingRef.id,
      userId: userId,
      bikeId: bikeId,
      stationId: stationId,
      slotId: slotId,
      isActive: true,
      reservedAt: reservedAt.toDate(),
    );
    return _hydrateDetails(booking);
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    final bookingRef = _db.collection(FirestorePaths.bookings).doc(bookingId);
    final bookingSnap = await bookingRef.get();
    if (!bookingSnap.exists) return;

    final booking = BookingDto.fromFirestore(
      bookingSnap.id,
      bookingSnap.data()!,
    );

    await _db.runTransaction((tx) async {
      tx.update(_db.collection(FirestorePaths.bikes).doc(booking.bikeId), {
        'status': 'available',
      });
      tx.update(bookingRef, {BookingDto.isActiveKey: false});
    });
  }
}
