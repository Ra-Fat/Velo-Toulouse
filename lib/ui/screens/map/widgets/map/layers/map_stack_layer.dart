import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../../../../../models/station/station.dart';
import '../../../../../../utils/async_value.dart';
import '../../../view_model/map_view_model.dart';
import '../map_station_pin.dart';

class MapStackLayer extends StatelessWidget {
  const MapStackLayer({super.key});

  @override
  Widget build(BuildContext context) {
    final stationsAsync = context.select(
      (MapViewModel vm) => vm.state.stations,
    );

    final selectedStationId = context.select(
      (MapViewModel vm) => vm.state.selectedStationId,
    );

    final stationList = switch (stationsAsync.state) {
      AsyncValueState.success => stationsAsync.data ?? <Station>[],
      AsyncValueState.loading => <Station>[],
      AsyncValueState.error => <Station>[],
    };

    return FlutterMap(
      options: const MapOptions(
        initialCenter: LatLng(11.5306, 104.8783),
        initialZoom: 15,
        minZoom: 11,
        maxZoom: 19,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.velo.toulouse.app',
        ),

        MarkerLayer(
          markers: [
            for (final station in stationList)
              Marker(
                point: LatLng(station.latitude, station.longitude),
                width: 36,
                height: 36,
                child: MapStationPin(
                  count: station.availableBikesCount,
                  selected: selectedStationId == station.id,
                  onTap: () {
                    context.read<MapViewModel>().toggleStation(station.id);
                  },
                ),
              ),
          ],
        ),

        const RichAttributionWidget(
          attributions: [
            TextSourceAttribution('OpenStreetMap contributors'),
          ],
        ),
      ],
    );
  }
}