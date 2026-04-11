import '../../../models/booking/booking_details.dart';

abstract class BookingRepository {
  Future<BookingDetails?> fetchLatestBookingDetails(String userId);

  Future<BookingDetails> createBooking({
    required String userId,
    required String bikeId,
    required String stationId,
    required String slotId,
  });
}
