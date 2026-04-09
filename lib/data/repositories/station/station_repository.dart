import '../../../models/station/station.dart';

abstract class StationRepository {
  Future<List<Station>> fetchStations();
}