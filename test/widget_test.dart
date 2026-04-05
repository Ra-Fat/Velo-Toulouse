import 'package:flutter_test/flutter_test.dart';

import 'package:project/main.dart';

void main() {
  testWidgets('Subscription tab opens plan flow', (WidgetTester tester) async {
    await tester.pumpWidget(const VeloToulouseApp());

    expect(find.text('Choose a Plan'), findsNothing);

    await tester.tap(find.text('Subscription'));
    await tester.pumpAndSettle();

    expect(find.text('Choose a Plan'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });
}
