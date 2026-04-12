import 'package:flutter/material.dart';
import 'package:project/ui/screens/map/view_model/booking_view_model.dart';
import 'package:project/ui/screens/map/view_model/map_view_model.dart';
import 'package:provider/provider.dart';

import '../../../../theme/app_colors.dart';
import '../booking/booking_timer_screen.dart';
import 'map_search_bar.dart';
import 'layers/booking_banner_layer.dart';
import 'layers/map_stack_layer.dart';
import 'layers/station_sheet_layer.dart';

class MapScreenContent extends StatelessWidget {
  const MapScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final mapVm = context.watch<MapViewModel>();
    final bookingVm = context.read<BookingViewModel>();

    return ColoredBox(
      color: AppColors.surfaceMuted,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const MapStackLayer(),
          // const MapSearchBar(),
          StationSheetLayer(
            onBook: () async {
              final nav = Navigator.of(context);
              showDialog<void>(
                context: context,
                barrierDismissible: false,
                builder: (dialogContext) =>
                    const Center(child: CircularProgressIndicator()),
              );

              try {
                final details = await mapVm.bookSelectedBike(bookingVm);
                if (nav.canPop()) {
                  nav.pop();
                }
                if (!context.mounted) return;
                if (details == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Could not create booking')),
                  );
                  return;
                }
                nav.push<void>(
                  MaterialPageRoute<void>(
                    builder: (context) =>
                        ChangeNotifierProvider<BookingViewModel>.value(
                          value: bookingVm,
                          child: BookingTimerScreen(details: details),
                        ),
                  ),
                );
              } catch (_) {
                if (nav.canPop()) {
                  nav.pop();
                }
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Could not create booking')),
                );
              }
            },
            hasActiveBooking:
                context.watch<BookingViewModel>().state.details.data != null,
          ),
          const BookingBannerLayer(),
        ],
      ),
    );
  }
}
