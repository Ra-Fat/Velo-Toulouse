import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/station/station.dart';
import '../../theme/app_colors.dart';
import '../../utils/async_value.dart';
import '../../utils/geo_to_map_fraction.dart';
import 'book_bike_placeholder_screen.dart';
import 'view_model/booking_view_model.dart';
import 'view_model/map_view_model.dart';
import 'widgets/active_booking_banner.dart';
import 'widgets/map_search_bar.dart';
import 'widgets/map_station_pin.dart';
import 'widgets/station_bike_sheet.dart';

class MapPlaceholderScreen extends StatelessWidget {
  const MapPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surfaceMuted,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const _MapStack(),
          const MapSearchBar(),
          const _StationSheetLayer(),
          const _BookingBannerLayer(),
        ],
      ),
    );
  }
}

class _MapStack extends StatelessWidget {
  const _MapStack();

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

class _StationSheetLayer extends StatelessWidget {
  const _StationSheetLayer();

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
        onBook: () {
          final id = mapVm.state.selectedBikeId;
          if (id == null) return;
          final bikes = mapVm.state.bikesAtStation.data;
          if (bikes == null) return;
          String? bikeNumber;
          for (final b in bikes) {
            if (b.id == id) {
              bikeNumber = b.number;
              break;
            }
          }
          if (bikeNumber == null) return;
          final bikeNumberStr = bikeNumber;
          Navigator.of(context).push<void>(
            MaterialPageRoute<void>(
              builder: (context) => BookBikePlaceholderScreen(
                stationName: station.name,
                bikeNumber: bikeNumberStr,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _BookingBannerLayer extends StatelessWidget {
  const _BookingBannerLayer();

  @override
  Widget build(BuildContext context) {
    final mapVm = context.watch<MapViewModel>();
    final sheetOpen = mapVm.state.selectedStationId != null;
    final bottomInset = sheetOpen
        ? MediaQuery.sizeOf(context).height * 0.42 + 8
        : 16.0;

    return Positioned(
      left: 16,
      right: 16,
      bottom: bottomInset,
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
        return ActiveBookingBanner(details: data);
    }
  }
}