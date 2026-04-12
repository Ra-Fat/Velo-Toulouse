import 'package:flutter/material.dart';
import 'package:project/ui/screens/map/view_model/booking_view_model.dart';
import 'package:project/ui/screens/map/view_model/map_view_model.dart';
import 'package:provider/provider.dart';

import '../../../theme/app_colors.dart';
import 'booking/booking_timer_content.dart';
import 'map/map_search_bar.dart';
import 'booking/booking_banner_layer.dart';
import 'map/layers/map_stack_layer.dart';
import 'map/layers/station_sheet_layer.dart';

class MapScreenContent extends StatelessWidget {
  const MapScreenContent({super.key});

  Future<void> _handleBook({
    required BuildContext context,
    required MapViewModel mapVm,
    required BookingViewModel bookingVm,
  }) async {
    final nav = Navigator.of(context);

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final details = await mapVm.createBookingFlow(bookingVm);

    if (nav.canPop()) nav.pop();
    if (!context.mounted) return;

    if (details == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not create booking')),
      );
      return;
    }

    nav.push(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: bookingVm,
          child: BookingTimerContent(details: details),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mapVm = context.watch<MapViewModel>();
    final bookingVm = context.read<BookingViewModel>();

    return Container(
      color: AppColors.surfaceMuted,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const MapStackLayer(),
          const MapSearchBar(),
          StationSheetLayer(
            onBook: () => _handleBook(
              context: context,
              mapVm: mapVm,
              bookingVm: bookingVm,
            ),
            hasActiveBooking:
                context.watch<BookingViewModel>().state.details.data != null,
          ),
          const BookingBannerLayer(),
        ],
      ),
    );
  }
}