import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../view_model/map_view_model.dart';
import '../../bike/station_bike_sheet.dart';

class StationSheetLayer extends StatelessWidget {
  const StationSheetLayer({
    super.key,
    required this.onBook,
    required this.hasActiveBooking,
  });

  final VoidCallback onBook;
  final bool hasActiveBooking;

  @override
  Widget build(BuildContext context) {
    final mapVm = context.watch<MapViewModel>();
    final station = mapVm.selectedStation;
    if (station == null) return const SizedBox.shrink();

    return Positioned.fill(
      child: StationBikeSheet(
        station: station,
        bikes: mapVm.state.bikesAtStation,
        selectedBikeId: mapVm.state.selectedBikeId,
        onSelectBike: mapVm.selectBike,
        onClose: () => mapVm.selectStation(null),
        onBook: onBook,
        hasActiveBooking: hasActiveBooking,
      ),
    );
  }
}
