import '../../../models/bike/bike.dart';
import 'bike_repository.dart';

class BikeRepositoryMock implements BikeRepository {
  BikeRepositoryMock({this.artificialDelay = const Duration(milliseconds: 200)});

  final Duration artificialDelay;

  static final List<Bike> _bikes = <Bike>[
    const Bike(
      id: '2',
      number: '1002',
      status: 'available',
      currentStationId: '1',
      currentSlotId: '2',
    ),
    const Bike(
      id: '10',
      number: '4872',
      status: 'available',
      currentStationId: '1',
      currentSlotId: '10',
    ),
    const Bike(
      id: '3',
      number: '1003',
      status: 'available',
      currentStationId: '2',
      currentSlotId: '4',
    ),
    const Bike(
      id: '11',
      number: '5021',
      status: 'available',
      currentStationId: '3',
      currentSlotId: '11',
    ),
    const Bike(
      id: '12',
      number: '5022',
      status: 'available',
      currentStationId: '4',
      currentSlotId: '12',
    ),
    const Bike(
      id: '13',
      number: '5023',
      status: 'available',
      currentStationId: '5',
      currentSlotId: '13',
    ),
    const Bike(
      id: '1',
      number: '1001',
      status: 'reserved',
      currentStationId: '1',
      currentSlotId: '1',
    ),
  ];

  @override
  Future<List<Bike>> fetchAvailableBikesForStation(String stationId) async {
    await Future<void>.delayed(artificialDelay);
    final list = _bikes
        .where((b) => b.currentStationId == stationId && b.isAvailable)
        .toList();
    list.sort((a, b) => a.number.compareTo(b.number));
    return list;
  }
}