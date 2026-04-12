import 'package:flutter/foundation.dart';

import '../../../../services/app_session.dart';
import '../../../../data/repositories/booking/booking_repository.dart';
import '../../../../models/booking/booking_details.dart';
import '../../../states/booking_state.dart';
import '../../../../utils/async_value.dart';

class BookingViewModel extends ChangeNotifier {
  BookingViewModel({
    required BookingRepository repository,
    this.userId = AppSession.userId,
  }) : _repository = repository;

  final BookingRepository _repository;
  final String userId;

  BookingState _state = BookingState(
    details: AsyncValue<BookingDetails?>.loading(),
    createResult: AsyncValue<BookingDetails?>.success(null),
  );

  BookingState get state => _state;

  // load latest booking for user
  Future<void> load() async {
    _state = _state.copyWith(details: AsyncValue<BookingDetails?>.loading());
    notifyListeners();
    try {
      final result = await _repository.fetchLatestBookingDetails(userId);
      _state = _state.copyWith(
        details: AsyncValue<BookingDetails?>.success(result),
      );
    } catch (e) {
      _state = _state.copyWith(details: AsyncValue<BookingDetails?>.error(e));
    }
    notifyListeners();
  }

  // create a new booking
  Future<BookingDetails?> createBooking({
    required String bikeId,
    required String stationId,
    required String slotId,
  }) async {
    _state = _state.copyWith(
      createResult: AsyncValue<BookingDetails?>.loading(),
    );
    notifyListeners();
    try {
      final details = await _repository.createBooking(
        userId: userId,
        bikeId: bikeId,
        stationId: stationId,
        slotId: slotId,
      );
      _state = _state.copyWith(
        createResult: AsyncValue<BookingDetails?>.success(details),
        details: AsyncValue<BookingDetails?>.success(details),
      );
      notifyListeners();
      return details;
    } catch (e) {
      _state = _state.copyWith(
        createResult: AsyncValue<BookingDetails?>.error(e),
      );
      notifyListeners();
      return null;
    }
  }

  // cancel the current booking
  Future<bool> cancelBooking(String bookingId) async {
    _state = _state.copyWith(
      createResult: AsyncValue<BookingDetails?>.loading(),
    );
    notifyListeners();
    try {
      await _repository.cancelBooking(bookingId);
      final result = await _repository.fetchLatestBookingDetails(userId);
      _state = _state.copyWith(
        details: AsyncValue<BookingDetails?>.success(result),
        createResult: AsyncValue<BookingDetails?>.success(null),
      );
      notifyListeners();
      return true;
    } catch (e) {
      _state = _state.copyWith(
        createResult: AsyncValue<BookingDetails?>.error(e),
      );
      notifyListeners();
      debugPrint('Error cancelling booking: $e');
      return false;
    }
  }
}
