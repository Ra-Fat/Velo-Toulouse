import 'package:flutter/foundation.dart';

import '../../../../data/repositories/bike/bike_repository.dart';
import '../../../../data/repositories/station/station_repository.dart';
import '../../../../models/booking/booking_details.dart';
import '../../../../models/bike/bike.dart';
import '../../../../models/station/station.dart';
import 'booking_view_model.dart';
import '../../../states/map_state.dart';
import '../../../../utils/async_value.dart';

class MapViewModel extends ChangeNotifier {
  MapViewModel({
    required StationRepository stationRepository,
    required BikeRepository bikeRepository,
  }) : _stationRepository = stationRepository,
       _bikeRepository = bikeRepository;

  final StationRepository _stationRepository;
  final BikeRepository _bikeRepository;

  MapState _state = MapState(
    stations: AsyncValue<List<Station>>.loading(),
    selectedStationId: null,
    bikesAtStation: AsyncValue<List<Bike>>.success(<Bike>[]),
    selectedBikeId: null,
  );

  MapState get state => _state;

  Station? get selectedStation {
    final id = _state.selectedStationId;
    if (id == null) return null;
    final list = _state.stations.data;
    if (list == null) return null;
    for (final s in list) {
      if (s.id == id) return s;
    }
    return null;
  }

  Bike? get selectedBike {
    final selectedBikeId = _state.selectedBikeId;
    if (selectedBikeId == null) return null;
    final bikes = _state.bikesAtStation.data;
    if (bikes == null) return null;
    for (final bike in bikes) {
      if (bike.id == selectedBikeId) return bike;
    }
    return null;
  }

  Future<void> loadStations() async {
    _state = MapState(
      stations: AsyncValue<List<Station>>.loading(),
      selectedStationId: _state.selectedStationId,
      bikesAtStation: _state.bikesAtStation,
      selectedBikeId: _state.selectedBikeId,
    );
    notifyListeners();
    try {
      final list = await _stationRepository.fetchStations();
      _state = MapState(
        stations: AsyncValue<List<Station>>.success(list),
        selectedStationId: _state.selectedStationId,
        bikesAtStation: _state.bikesAtStation,
        selectedBikeId: _state.selectedBikeId,
      );
    } catch (e) {
      _state = MapState(
        stations: AsyncValue<List<Station>>.error(e),
        selectedStationId: _state.selectedStationId,
        bikesAtStation: _state.bikesAtStation,
        selectedBikeId: _state.selectedBikeId,
      );
    }
    notifyListeners();
  }

  Future<void> selectStation(String? stationId) async {
    if (stationId == null) {
      _state = MapState(
        stations: _state.stations,
        selectedStationId: null,
        bikesAtStation: AsyncValue<List<Bike>>.success(<Bike>[]),
        selectedBikeId: null,
      );
      notifyListeners();
      return;
    }

    _state = MapState(
      stations: _state.stations,
      selectedStationId: stationId,
      bikesAtStation: AsyncValue<List<Bike>>.loading(),
      selectedBikeId: null,
    );
    notifyListeners();

    try {
      final bikes = await _bikeRepository.fetchAvailableBikesForStation(
        stationId,
      );
      _state = MapState(
        stations: _state.stations,
        selectedStationId: stationId,
        bikesAtStation: AsyncValue<List<Bike>>.success(bikes),
        selectedBikeId: null,
      );
    } catch (e) {
      _state = MapState(
        stations: _state.stations,
        selectedStationId: stationId,
        bikesAtStation: AsyncValue<List<Bike>>.error(e),
        selectedBikeId: null,
      );
    }
    notifyListeners();
  }

  void selectBike(String? bikeId) {
    _state = MapState(
      stations: _state.stations,
      selectedStationId: _state.selectedStationId,
      bikesAtStation: _state.bikesAtStation,
      selectedBikeId: bikeId,
    );
    notifyListeners();
  }

  // Future<BookingDetails?> bookSelectedBike(
  //   BookingViewModel bookingViewModel,
  // ) async {
  //   final station = selectedStation;
  //   final bike = selectedBike;
  //   if (station == null || bike == null) return null;

  //   return bookingViewModel.createBooking(
  //     bikeId: bike.id,
  //     stationId: station.id,
  //     slotId: bike.currentSlotId,
  //   );
  // }

  Future<BookingDetails?> createBookingFlow(BookingViewModel bookingVm) async {
    final station = selectedStation;
    final bike = selectedBike;

    if (station == null || bike == null) return null;

    return bookingVm.createBooking(
      bikeId: bike.id,
      stationId: station.id,
      slotId: bike.currentSlotId,
    );
  }

  void toggleStation(String stationId) {
    if (_state.selectedStationId == stationId) {
      selectStation(null);
    } else {
      selectStation(stationId);
    }
  }
}
