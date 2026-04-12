import 'package:flutter/material.dart';
import 'package:project/ui/screens/map/widgets/bike/bike_title.dart';

import '../../../../../models/bike/bike.dart';
import '../../../../../utils/async_value.dart';


class BikeListSection extends StatelessWidget {
  const BikeListSection({
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
          child: Text('Could not load bikes\n${bikes.error}'),
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

            return BikeTile(
              bike: bike,
              selected: bike.id == selectedBikeId,
              enabled: !hasActiveBooking,
              onTap: () => onSelectBike(bike.id),
            );
          },
        );
    }
  }
}