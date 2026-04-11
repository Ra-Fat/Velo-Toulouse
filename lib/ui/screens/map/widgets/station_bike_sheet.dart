import 'package:flutter/material.dart';
import 'package:project/ui/screens/map/widgets/station_bike_list.dart';

import '../../../../models/bike/bike.dart';
import '../../../../models/station/station.dart';
import '../../../theme/app_colors.dart';
import '../../../../utils/async_value.dart';

class StationBikeSheet extends StatelessWidget {
  const StationBikeSheet({
    super.key,
    required this.station,
    required this.bikes,
    required this.selectedBikeId,
    required this.onSelectBike,
    required this.onBook,
    required this.onClose,
    required this.hasActiveBooking,
  });

  final Station station;
  final AsyncValue<List<Bike>> bikes;
  final String? selectedBikeId;
  final ValueChanged<String?> onSelectBike;
  final VoidCallback onBook;
  final VoidCallback onClose;
  final bool hasActiveBooking;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      elevation: 12,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 12, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          station.name,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Station #${station.code}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${station.availableBikesCount} ${station.availableBikesCount == 1 ? 'bike' : 'bikes'} available',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: onClose,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Text(
                'Choose a bike',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Expanded(
              child: StationBikeList(
                bikes: bikes,
                selectedBikeId: selectedBikeId,
                onSelectBike: onSelectBike,
                hasActiveBooking: hasActiveBooking,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: FilledButton(
                onPressed: selectedBikeId == null || hasActiveBooking
                    ? null
                    : onBook,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  hasActiveBooking
                      ? 'You currently have an active booking'
                      : 'Book',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

