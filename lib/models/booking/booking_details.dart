import 'booking.dart';

class BookingDetails {
  const BookingDetails({
    required this.booking,
    required this.stationName,
    required this.bikeNumber,
    required this.slotLabel,
  });

  final Booking booking;
  final String stationName;
  final String bikeNumber;
  final String slotLabel;
}
