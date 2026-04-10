import 'package:project/models/bike/bike.dart';
import 'package:project/models/station/station.dart';
import 'package:project/ui/utils/async_value.dart';

class MapState {
  const MapState({
    required this.stations,
    required this.selectedStationId,
    required this.bikesAtStation,
    required this.selectedBikeId,
  });

  final AsyncValue<List<Station>> stations;
  final String? selectedStationId;
  final AsyncValue<List<Bike>> bikesAtStation;
  final String? selectedBikeId;
}