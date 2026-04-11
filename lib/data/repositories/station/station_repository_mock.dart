import '../../../models/station/station.dart';
import 'station_repository.dart';

class StationRepositoryMock implements StationRepository {
  StationRepositoryMock({
    this.artificialDelay = const Duration(milliseconds: 250),
  });

  final Duration artificialDelay;

  static final List<Station> _stations = <Station>[
    const Station(
      id: '1',
      name: 'Stueng Meanchey Tmei',
      latitude: 11.5306,
      longitude: 104.8783,
      isActive: true,
      code: '12',
      availableBikesCount: 2,
    ),
    const Station(
      id: '2',
      name: 'Kmall',
      latitude: 11.5289,
      longitude: 104.8794,
      isActive: true,
      code: '18',
      availableBikesCount: 1,
    ),
    const Station(
      id: '3',
      name: 'Prey Sor',
      latitude: 11.5278,
      longitude: 104.8822,
      isActive: true,
      code: '07',
      availableBikesCount: 1,
    ),
    const Station(
      id: '4',
      name: 'Beltei International School',
      latitude: 11.5334,
      longitude: 104.8776,
      isActive: true,
      code: '24',
      availableBikesCount: 1,
    ),
    const Station(
      id: '5',
      name: 'Terk Lu Stueng Meanchey',
      latitude: 11.5321,
      longitude: 104.8801,
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
