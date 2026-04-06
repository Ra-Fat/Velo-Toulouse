import '../../../models/booking/booking.dart';
import '../../../models/booking/booking_details.dart';
import 'booking_repository.dart';

/// Matches `lib/scripts/seed/index.js` for user "1".
class BookingRepositoryMock implements BookingRepository {
  BookingRepositoryMock({this.artificialDelay = const Duration(milliseconds: 300)});

  final Duration artificialDelay;

  static final BookingDetails _seedUser1 = BookingDetails(
    booking: Booking(
      id: 'mock-booking-1',
      userId: '1',
      bikeId: '1',
      stationId: '1',
      slotId: '1',
      reservedAt: DateTime.utc(2026, 4, 5, 12, 0),
    ),
    stationName: 'Capitole Main',
    bikeNumber: '1001',
    slotLabel: 'No. 01',
  );

  @override
  Future<BookingDetails?> fetchLatestBookingDetails(String userId) async {
    await Future<void>.delayed(artificialDelay);
    if (userId == '1') {
      return _seedUser1;
    }
    return null;
  }
}
