import 'package:flutter/material.dart';
import 'package:project/models/bike/bike.dart';
import 'package:project/ui/theme/app_colors.dart';
import 'package:project/utils/async_value.dart';

class StationBikeList extends StatelessWidget {
  const StationBikeList({
    super.key,
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
