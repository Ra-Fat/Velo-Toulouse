import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'data/repositories/bike/bike_repository.dart';
import 'data/repositories/bike/bike_repository_mock.dart';
import 'data/repositories/bike/bike_repository_firebase.dart';

import 'data/repositories/booking/booking_repository.dart';
import 'data/repositories/booking/booking_repository_mock.dart';
import 'data/repositories/booking/booking_repository_firebase.dart';

import 'data/repositories/station/station_repository.dart';
import 'data/repositories/station/station_repository_mock.dart';
import 'data/repositories/station/station_repository_firebase.dart';

import 'data/repositories/subscription/subscription_repository.dart';
import 'data/repositories/subscription/subscription_repository_mock.dart';
import 'data/repositories/subscription/subscription_repository_firebase.dart';

import 'data/repositories/user_subscription/user_subscription_repository.dart';
import 'data/repositories/user_subscription/user_subscription_repository_mock.dart';
import 'data/repositories/user_subscription/user_subscription_repository_firebase.dart';

import 'main_common.dart';
import 'firebase_options.dart';

const bool _useFirebase = bool.fromEnvironment(
  'USE_FIREBASE',
  defaultValue: true,
);

List<InheritedProvider> get devProviders {
  final subscriptionRepository = _useFirebase
      ? SubscriptionRepositoryFirebase()
      : SubscriptionRepositoryMock();

  return [
    Provider<SubscriptionRepository>(create: (_) => subscriptionRepository),

    Provider<UserSubscriptionRepository>(
      create: (_) => _useFirebase
          ? UserSubscriptionRepositoryFirebase()
          : UserSubscriptionRepositoryMock(
              subscriptionRepository: subscriptionRepository,
            ),
    ),

    Provider<BookingRepository>(
      create: (_) =>
          _useFirebase ? BookingRepositoryFirebase() : BookingRepositoryMock(),
    ),

    Provider<StationRepository>(
      create: (_) =>
          _useFirebase ? StationRepositoryFirebase() : StationRepositoryMock(),
    ),

    Provider<BikeRepository>(
      create: (_) =>
          _useFirebase ? BikeRepositoryFirebase() : BikeRepositoryMock(),
    ),
  ];
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (_useFirebase) {
    print('Using Firebase repositories');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  mainCommon(devProviders);
}
