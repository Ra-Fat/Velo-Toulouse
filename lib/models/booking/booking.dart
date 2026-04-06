class Booking {
  const Booking({
    required this.id,
    required this.userId,
    required this.bikeId,
    required this.stationId,
    required this.slotId,
    required this.reservedAt,
  });

  final String id;
  final String userId;
  final String bikeId;
  final String stationId;
  final String slotId;
  final DateTime reservedAt;
}
