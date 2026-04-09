import '../../../models/bike/bike.dart';

abstract class BikeRepository {
  Future<List<Bike>> fetchAvailableBikesForStation(String stationId);
}