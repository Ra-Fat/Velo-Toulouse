import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../../models/station/station.dart';
import '../../../../../../theme/app_colors.dart';
import '../../../../../../utils/async_value.dart';
import '../../../../../../utils/geo_to_map_fraction.dart';
import '../../../../view_model/map_view_model.dart';
import '../map_station_pin.dart';

class MapStackLayer extends StatelessWidget {
  const MapStackLayer({super.key});

  @override
  Widget build(BuildContext context) {
    final mapVm = context.watch<MapViewModel>();
    final stations = mapVm.state.stations;

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        return Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/map.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => ColoredBox(
                  color: AppColors.surfaceMuted,
                  child: Center(
                    child: Text(
                      'Add assets/map.png',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
              ),
            ),
            switch (stations.state) {
              AsyncValueState.loading => const SizedBox.shrink(),
              AsyncValueState.error => const SizedBox.shrink(),
              AsyncValueState.success => () {
                final list = stations.data ?? <Station>[];
                return Stack(
                  children: [
                    for (final station in list)
                      () {
                        final frac = geoToMapFraction(
                          station.latitude,
                          station.longitude,
                        );
                        final left = frac.dx * w - 18;
                        final top = frac.dy * h - 18;
                        final selected =
                            mapVm.state.selectedStationId == station.id;
                        return Positioned(
                          left: left.clamp(0.0, w - 36),
                          top: top.clamp(0.0, h - 36),
                          child: MapStationPin(
                            count: station.availableBikesCount,
                            selected: selected,
                            onTap: () {
                              if (selected) {
                                mapVm.selectStation(null);
                              } else {
                                mapVm.selectStation(station.id);
                              }
                            },
                          ),
                        );
                      }(),
                  ],
                );
              }(),
            },
          ],
        );
      },
    );
  }
}
