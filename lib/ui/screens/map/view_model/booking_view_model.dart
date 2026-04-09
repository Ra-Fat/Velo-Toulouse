import 'package:flutter/foundation.dart';

import '../../../../data/repositories/booking/booking_repository.dart';
import '../../../../models/booking/booking_details.dart';
import '../../../states/booking_state.dart';
import '../../../utils/async_value.dart';

class BookingViewModel extends ChangeNotifier {
  BookingViewModel({
    required BookingRepository repository,
    this.userId = '1',
  }) : _repository = repository;

  final BookingRepository _repository;
  final String userId;

  BookingState _state = BookingState(
    details: AsyncValue<BookingDetails?>.loading(),
  );

  BookingState get state => _state;

  Future<void> load() async {
    _state = BookingState(details: AsyncValue<BookingDetails?>.loading());
    notifyListeners();
    try {
      final result = await _repository.fetchLatestBookingDetails(userId);
      _state = BookingState(
        details: AsyncValue<BookingDetails?>.success(result),
      );
    } catch (e) {
      _state = BookingState(
        details: AsyncValue<BookingDetails?>.error(e),
      );
    }
    notifyListeners();
  }
}
