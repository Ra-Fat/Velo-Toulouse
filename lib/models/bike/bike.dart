enum BikeStatus { available, reserved, maintenance }

class Bike {
  const Bike({
    required this.id,
    required this.number,
    required this.status,
    required this.currentStationId,
    required this.currentSlotId,
  });

  final String id;
  final String number;
  final BikeStatus status;
  final String currentStationId;
  final String currentSlotId;

  bool get isAvailable => status == BikeStatus.available;
}