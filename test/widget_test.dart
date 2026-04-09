import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:project/data/repositories/booking/booking_repository.dart';
import 'package:project/data/repositories/booking/booking_repository_mock.dart';
import 'package:project/data/repositories/subscription/subscription_repository.dart';
import 'package:project/data/repositories/subscription/subscription_repository_mock.dart';
import 'package:project/data/repositories/user_subscription/user_subscription_repository.dart';
import 'package:project/data/repositories/user_subscription/user_subscription_repository_mock.dart';
import 'package:project/main.dart';

void main() {
  testWidgets('Subscription tab opens plan flow', (WidgetTester tester) async {
    final subscriptionRepository =
        SubscriptionRepositoryMock(artificialDelay: Duration.zero);
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<SubscriptionRepository>.value(
            value: subscriptionRepository,
          ),
          Provider<UserSubscriptionRepository>.value(
            value: UserSubscriptionRepositoryMock(
              subscriptionRepository: subscriptionRepository,
              artificialDelay: Duration.zero,
            ),
          ),
          Provider<BookingRepository>.value(
            value: BookingRepositoryMock(artificialDelay: Duration.zero),
          ),
        ],
        child: const VeloToulouseApp(),
      ),
    );

    expect(find.text('Choose a Plan'), findsNothing);

    await tester.tap(find.text('Subscription'));
    await tester.pumpAndSettle();

    expect(find.text('Choose a Plan'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });
}
