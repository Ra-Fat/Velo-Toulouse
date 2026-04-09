import '../../../models/booking/booking_details.dart';

abstract class BookingRepository {
  Future<BookingDetails?> fetchLatestBookingDetails(String userId);
}
