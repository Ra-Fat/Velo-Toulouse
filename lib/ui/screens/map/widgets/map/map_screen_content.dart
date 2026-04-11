import 'package:flutter/material.dart';
import 'package:project/ui/screens/map/view_model/booking_view_model.dart';
import 'package:project/ui/screens/map/view_model/map_view_model.dart';
import 'package:provider/provider.dart';

import '../../../../../../../models/bike/bike.dart';
import '../../../../theme/app_colors.dart';
import '../booking/booking_timer_screen.dart';
import 'content/map_search_bar.dart';
import 'content/layers/booking_banner_layer.dart';
import 'content/layers/map_stack_layer.dart';
import 'content/layers/station_sheet_layer.dart';

class MapScreenContent extends StatelessWidget {
  const MapScreenContent({super.key});

  VoidCallback _buildOnBook(BuildContext context, MapViewModel mapVm) {
    return () {
      final station = mapVm.selectedStation;
      if (station == null) return;

      final selectedBikeId = mapVm.state.selectedBikeId;
      if (selectedBikeId == null) return;

      final bikes = mapVm.state.bikesAtStation.data;
      if (bikes == null) return;

      Bike? selectedBike;
      for (final bike in bikes) {
        if (bike.id == selectedBikeId) {
          selectedBike = bike;
          break;
        }
      }
      if (selectedBike == null) return;

      final bookingVm = context.read<BookingViewModel>();
      final nav = Navigator.of(context);
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) =>
            const Center(child: CircularProgressIndicator()),
      );

      bookingVm
          .createBooking(
            bikeId: selectedBike.id,
            stationId: station.id,
            slotId: selectedBike.currentSlotId,
          )
          .then((details) {
            nav.pop();
            if (!context.mounted) return;
            if (details == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Could not create booking')),
              );
              return;
            }
            nav.push<void>(
              MaterialPageRoute<void>(
                builder: (context) => BookingTimerScreen(details: details),
              ),
            );
          })
          .catchError((_) {
            nav.pop();
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Could not create booking')),
            );
          });
    };
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surfaceMuted,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const MapStackLayer(),
          const MapSearchBar(),
          StationSheetLayer(
            onBook: _buildOnBook(context, context.watch<MapViewModel>()),
            hasActiveBooking:
                context.watch<BookingViewModel>().state.details.data != null,
          ),
          const BookingBannerLayer(),
        ],
      ),
    );
  }
}
