import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../utils/async_value.dart';
import '../../../../view_model/booking_view_model.dart';
import '../../../../view_model/map_view_model.dart';
import '../../../booking/active_booking_banner.dart';
import '../../../booking/booking_timer_screen.dart';

class BookingBannerLayer extends StatelessWidget {
  const BookingBannerLayer({super.key});

  @override
  Widget build(BuildContext context) {
    final mapVm = context.watch<MapViewModel>();
    final sheetOpen = mapVm.state.selectedStationId != null;

    if (sheetOpen) {
      return const SizedBox.shrink();
    }

    return Positioned(
      left: 16,
      right: 16,
      bottom: 16,
      child: const _BookingOverlay(),
    );
  }
}

class _BookingOverlay extends StatelessWidget {
  const _BookingOverlay();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BookingViewModel>();
    final s = vm.state;

    switch (s.details.state) {
      case AsyncValueState.loading:
        return const SizedBox.shrink();
      case AsyncValueState.error:
        return Material(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Could not load booking',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                TextButton(
                  onPressed: () => vm.load(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        );
      case AsyncValueState.success:
        final data = s.details.data;
        if (data == null) return const SizedBox.shrink();
        return ActiveBookingBanner(
          details: data,
          onTap: () {
            Navigator.of(context).push<void>(
              MaterialPageRoute<void>(
                builder: (context) => BookingTimerScreen(details: data),
              ),
            );
          },
        );
    }
  }
}
