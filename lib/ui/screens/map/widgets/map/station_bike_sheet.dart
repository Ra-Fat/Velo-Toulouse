import 'package:flutter/material.dart';

import '../../../../../models/bike/bike.dart';
import '../../../../../models/station/station.dart';
import '../../../../theme/app_colors.dart';
import '../../../../../utils/async_value.dart';

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
      elevation: 0,
      borderRadius: BorderRadius.zero,
      color: Colors.white,
      child: SafeArea(
        top: true,
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
              child: _BikeListBody(
                bikes: bikes,
                selectedBikeId: selectedBikeId,
                onSelectBike: onSelectBike,
                hasActiveBooking: hasActiveBooking,
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
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
                  'Book',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 22, bottom: 12),
              child: Text(
                hasActiveBooking
                    ? "* You can't book while having an active booking"
                    : "",
                style: theme.textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BikeListBody extends StatelessWidget {
  const _BikeListBody({
    required this.bikes,
    required this.selectedBikeId,
    required this.onSelectBike,
    required this.hasActiveBooking,
  });

  final AsyncValue<List<Bike>> bikes;
  final String? selectedBikeId;
  final ValueChanged<String?> onSelectBike;
  final bool hasActiveBooking;

  @override
  Widget build(BuildContext context) {
    switch (bikes.state) {
      case AsyncValueState.loading:
        return const Center(child: CircularProgressIndicator());
      case AsyncValueState.error:
        return Center(
          child: Text(
            'Could not load bikes\n${bikes.error}',
            textAlign: TextAlign.center,
          ),
        );
      case AsyncValueState.success:
        final list = bikes.data ?? <Bike>[];
        if (list.isEmpty) {
          return const Center(child: Text('No bikes available right now.'));
        }
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: list.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, i) {
            final bike = list[i];
            final selected = bike.id == selectedBikeId;
            return Material(
              color: selected ? Colors.white : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: hasActiveBooking ? null : () => onSelectBike(bike.id),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selected
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      width: selected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bike #${bike.number}',
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'At this station',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.directions_bike,
                        color: AppColors.primary,
                        size: 32,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
    }
  }
}
