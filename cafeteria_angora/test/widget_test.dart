import 'package:flutter_test/flutter_test.dart';

import 'package:cafeteria_angora/main.dart';

void main() {
  testWidgets('App renders header', (WidgetTester tester) async {
    await tester.pumpWidget(const CafeteriaAngoraApp());
    await tester.pumpAndSettle();

    expect(find.text('MENU DIGITAL • PREMIUM'), findsOneWidget);
  });
}
