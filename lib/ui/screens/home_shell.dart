import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/bike/bike_repository.dart';
import '../../data/repositories/booking/booking_repository.dart';
import '../../data/repositories/station/station_repository.dart';
import '../theme/app_colors.dart';
import 'map/map_screen.dart';
import 'map/view_model/booking_view_model.dart';
import 'map/view_model/map_view_model.dart';
import 'subscription/subscription_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        sizing: StackFit.expand,
        children: [
          MultiProvider(
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
            child: const MapPlaceholderScreen(),
          ),
          SubscriptionFlowScreen(
            onBackToMap: () => setState(() => _index = 0),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        height: 64,
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        indicatorColor: AppColors.primary.withValues(alpha: 0.14),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map_rounded, color: AppColors.primary),
            label: 'Map',
          ),
          NavigationDestination(
            icon: Icon(Icons.card_membership_outlined),
            selectedIcon: Icon(Icons.card_membership_rounded, color: AppColors.primary),
            label: 'Subscription',
          ),
        ],
      ),
    );
  }
}