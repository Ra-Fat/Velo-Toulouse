import 'dart:ui';

import 'map_bounds.dart';

/// Maps WGS84 to normalized [0,1] x/y for a Stack + Positioned overlay on the static map image.
/// x increases east; y increases down (north is smaller y).
Offset geoToMapFraction(double latitude, double longitude) {
  final w = MapToulouseBounds.westLongitude;
  final e = MapToulouseBounds.eastLongitude;
  final n = MapToulouseBounds.northLatitude;
  final s = MapToulouseBounds.southLatitude;
  final x = (longitude - w) / (e - w);
  final y = (n - latitude) / (n - s);
  return Offset(x.clamp(0.0, 1.0), y.clamp(0.0, 1.0));
}