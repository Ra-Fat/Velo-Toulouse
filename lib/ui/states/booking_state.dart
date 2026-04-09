import 'package:project/models/booking/booking_details.dart';
import 'package:project/ui/utils/async_value.dart';

class BookingState {
  const BookingState({required this.details});

  final AsyncValue<BookingDetails?> details;

  bool get isLoading => details.state == AsyncValueState.loading;

  bool get hasError => details.state == AsyncValueState.error;

  BookingState copyWith({AsyncValue<BookingDetails?>? details}) {
    return BookingState(details: details ?? this.details);
  }
}
