import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../view_model/map_view_model.dart';
import '../station_bike_sheet.dart';

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

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      height: MediaQuery.sizeOf(context).height * 0.42,
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
