import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/repositories/booking/booking_repository.dart';
import 'data/repositories/booking/booking_repository_firebase.dart';
import 'data/repositories/booking/booking_repository_mock.dart';
import 'data/repositories/subscription/subscription_repository.dart';
import 'data/repositories/subscription/subscription_repository_firebase.dart';
import 'data/repositories/subscription/subscription_repository_mock.dart';
import 'data/repositories/user_subscription/user_subscription_repository.dart';
import 'data/repositories/user_subscription/user_subscription_repository_firebase.dart';
import 'data/repositories/user_subscription/user_subscription_repository_mock.dart';
import 'ui/theme/app_colors.dart';
import 'ui/screens/home_shell.dart';

const bool _useFirebase = bool.fromEnvironment('USE_FIREBASE', defaultValue: false);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (_useFirebase) {
    await Firebase.initializeApp();
  }

  final SubscriptionRepository subscriptionRepository = _useFirebase
      ? SubscriptionRepositoryFirebase()
      : SubscriptionRepositoryMock();
  final UserSubscriptionRepository userSubscriptionRepository = _useFirebase
      ? UserSubscriptionRepositoryFirebase()
      : UserSubscriptionRepositoryMock(
          subscriptionRepository: subscriptionRepository,
        );
  final BookingRepository bookingRepository = _useFirebase
      ? BookingRepositoryFirebase()
      : BookingRepositoryMock();

  runApp(
    MultiProvider(
      providers: [
        Provider<SubscriptionRepository>.value(value: subscriptionRepository),
        Provider<UserSubscriptionRepository>.value(
          value: userSubscriptionRepository,
        ),
        Provider<BookingRepository>.value(value: bookingRepository),
      ],
      child: const VeloToulouseApp(),
    ),
  );
}

class VeloToulouseApp extends StatelessWidget {
  const VeloToulouseApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
    );

    return MaterialApp(
      title: 'Velo Toulouse',
      debugShowCheckedModeBanner: false,
      theme: base.copyWith(
        scaffoldBackgroundColor: Colors.white,
        navigationBarTheme: NavigationBarThemeData(
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            final selected = states.contains(WidgetState.selected);
            return TextStyle(
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              fontSize: 12,
              color: selected ? AppColors.primary : AppColors.textSecondary,
            );
          }),
        ),
      ),
      home: const HomeShell(),
    );
  }
}
