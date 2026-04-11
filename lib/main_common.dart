import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ui/screens/map/map_screen.dart';
import 'ui/screens/subscription/subscription_screen.dart';
import 'ui/theme/app_colors.dart';

///
/// Launch the application with the given list of providers
///
void mainCommon(List<InheritedProvider> providers) {
  runApp(
    MultiProvider(
      providers: providers,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: Colors.white,
        ),
        home: const VeloToulouseNavApp(),
      ),
    ),
  );
}

class VeloToulouseNavApp extends StatefulWidget {
  const VeloToulouseNavApp({super.key});

  @override
  State<VeloToulouseNavApp> createState() => _VeloToulouseNavAppState();
}

class _VeloToulouseNavAppState extends State<VeloToulouseNavApp> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    MapPlaceholderScreen(),
    SubscriptionFlowScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        height: 64,
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        indicatorColor: AppColors.primary.withOpacity(0.14),
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
