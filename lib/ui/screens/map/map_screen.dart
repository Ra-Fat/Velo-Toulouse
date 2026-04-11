import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/repositories/bike/bike_repository.dart';
import '../../../data/repositories/booking/booking_repository.dart';
import '../../../data/repositories/station/station_repository.dart';
import 'view_model/booking_view_model.dart';
import 'view_model/map_view_model.dart';
import 'widgets/map/map_screen_content.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => BookingViewModel(
            repository: context.read<BookingRepository>(),
            userId: '1',
          )..load(),
        ),
        ChangeNotifierProvider(
          create: (context) => MapViewModel(
            stationRepository: context.read<StationRepository>(),
            bikeRepository: context.read<BikeRepository>(),
          )..loadStations(),
        ),
      ],
      child: const MapScreenContent(),
    );
  }
}
