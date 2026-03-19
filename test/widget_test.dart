import 'package:flutter_test/flutter_test.dart';

import 'package:big_top/main.dart';

void main() {
  testWidgets('BigTopApp renders', (WidgetTester tester) async {
    await tester.pumpWidget(const BigTopApp());
    await tester.pumpAndSettle();

    // App should render and show the login screen (not authenticated)
    expect(find.text('Big Top'), findsOneWidget);
  });
}
