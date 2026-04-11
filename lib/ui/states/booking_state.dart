import 'package:project/models/booking/booking_details.dart';
import 'package:project/ui/utils/async_value.dart';

class BookingState {
  const BookingState({
    required this.details,
    required this.createResult,
  });

  final AsyncValue<BookingDetails?> details;
  final AsyncValue<BookingDetails?> createResult;

  bool get isLoading => details.state == AsyncValueState.loading;

  bool get hasError => details.state == AsyncValueState.error;

  bool get isCreating => createResult.state == AsyncValueState.loading;

  BookingState copyWith({
    AsyncValue<BookingDetails?>? details,
    AsyncValue<BookingDetails?>? createResult,
  }) {
    return BookingState(
      details: details ?? this.details,
      createResult: createResult ?? this.createResult,
    );
  }
}
