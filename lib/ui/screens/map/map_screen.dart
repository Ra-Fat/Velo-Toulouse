import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/app_colors.dart';
import '../../utils/async_value.dart';
import 'view_model/booking_view_model.dart';
import 'widgets/active_booking_banner.dart';
import 'widgets/map_search_bar.dart';

class MapPlaceholderScreen extends StatelessWidget {
  const MapPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surfaceMuted,
      child: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Map',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Station map placeholder',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
            const MapSearchBar(),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: _BookingOverlay(),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingOverlay extends StatelessWidget {
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
        return ActiveBookingBanner(details: data);
    }
  }
}
