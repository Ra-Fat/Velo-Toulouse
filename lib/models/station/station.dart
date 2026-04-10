class Station {
  const Station({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.isActive,
    required this.code,
    required this.availableBikesCount,
  });

  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final bool isActive;
  final String code;
  final int availableBikesCount;
}