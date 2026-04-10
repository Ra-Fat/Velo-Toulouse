import '../../../models/station/station.dart';
import 'station_repository.dart';

class StationRepositoryMock implements StationRepository {
  StationRepositoryMock({this.artificialDelay = const Duration(milliseconds: 250)});

  final Duration artificialDelay;

  static final List<Station> _stations = <Station>[
    const Station(
      id: '1',
      name: 'Esquirol',
      latitude: 43.600,
      longitude: 1.443,
      isActive: true,
      code: '12',
      availableBikesCount: 2,
    ),
    const Station(
      id: '2',
      name: 'Carmes',
      latitude: 43.597,
      longitude: 1.444,
      isActive: true,
      code: '18',
      availableBikesCount: 1,
    ),
    const Station(
      id: '3',
      name: 'Grand Rond',
      latitude: 43.595,
      longitude: 1.453,
      isActive: true,
      code: '07',
      availableBikesCount: 1,
    ),
    const Station(
      id: '4',
      name: 'Victor Hugo',
      latitude: 43.606,
      longitude: 1.446,
      isActive: true,
      code: '24',
      availableBikesCount: 1,
    ),
    const Station(
      id: '5',
      name: 'Saint-Georges',
      latitude: 43.603,
      longitude: 1.448,
      isActive: true,
      code: '31',
      availableBikesCount: 1,
    ),
  ];

  @override
  Future<List<Station>> fetchStations() async {
    await Future<void>.delayed(artificialDelay);
    return List<Station>.unmodifiable(_stations);
  }
}