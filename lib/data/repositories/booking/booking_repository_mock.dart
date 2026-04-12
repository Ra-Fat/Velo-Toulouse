import '../../../services/app_session.dart';
import '../../../models/booking/booking.dart';
import '../../../models/booking/booking_details.dart';
import 'booking_repository.dart';

class BookingRepositoryMock implements BookingRepository {
  BookingRepositoryMock({this.artificialDelay = const Duration(milliseconds: 300)});

  final Duration artificialDelay;

  static final BookingDetails _seedUser1 = BookingDetails(
    booking: Booking(
      id: 'mock-booking-1',
      userId: AppSession.userId,
      bikeId: '1',
      stationId: '1',
      slotId: '1',
      reservedAt: DateTime.utc(2026, 4, 5, 12, 0),
      isActive: true,
    ),
    stationName: 'Capitole Main',
    bikeNumber: '1001',
    slotLabel: 'No. 01',
  );

  final Map<String, BookingDetails> _latestByUser = <String, BookingDetails>{
    AppSession.userId: _seedUser1,
  };

  @override
  Future<BookingDetails?> fetchLatestBookingDetails(String userId) async {
    await Future<void>.delayed(artificialDelay);
    return _latestByUser[userId];
  }

  @override
  Future<BookingDetails> createBooking({
    required String userId,
    required String bikeId,
    required String stationId,
    required String slotId,
  }) async {
    await Future<void>.delayed(artificialDelay);

    final now = DateTime.now().toUtc();
    final details = BookingDetails(
      booking: Booking(
        id: 'mock-booking-${now.microsecondsSinceEpoch}',
        userId: userId,
        bikeId: bikeId,
        stationId: stationId,
        slotId: slotId,
        isActive: true,
        reservedAt: now,
      ),
      stationName: _stationName(stationId),
      bikeNumber: _bikeNumber(bikeId),
      slotLabel: _slotLabel(slotId),
    );
    _latestByUser[userId] = details;
    return details;
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    await Future<void>.delayed(artificialDelay);

    for (final entry in _latestByUser.entries) {
      if (entry.value.booking.id == bookingId) {
        _latestByUser[entry.key] = BookingDetails(
          booking: Booking(
            id: entry.value.booking.id,
            userId: entry.value.booking.userId,
            bikeId: entry.value.booking.bikeId,
            stationId: entry.value.booking.stationId,
            slotId: entry.value.booking.slotId,
            isActive: false,
            reservedAt: entry.value.booking.reservedAt,
          ),
          stationName: entry.value.stationName,
          bikeNumber: entry.value.bikeNumber,
          slotLabel: entry.value.slotLabel,
        );
        break;
      }
    }
  }

  String _stationName(String stationId) {
    switch (stationId) {
      case '1':
        return 'Esquirol';
      case '2':
        return 'Carmes';
      case '3':
        return 'Grand Rond';
      case '4':
        return 'Victor Hugo';
      case '5':
        return 'Saint-Georges';
      default:
        return stationId;
    }
  }

  String _bikeNumber(String bikeId) {
    switch (bikeId) {
      case '2':
        return '1002';
      case '3':
        return '1003';
      case '10':
        return '4872';
      case '11':
        return '5021';
      case '12':
        return '5022';
      case '13':
        return '5023';
      default:
        return bikeId;
    }
  }

  String _slotLabel(String slotId) {
    if (slotId.length == 1) return 'No. 0$slotId';
    return 'No. $slotId';
  }
}
