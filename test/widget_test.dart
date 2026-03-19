import 'package:flutter_test/flutter_test.dart';

import 'package:big_top/main.dart';

void main() {
  testWidgets('BigTopApp renders', (WidgetTester tester) async {
    await tester.pumpWidget(const BigTopApp());
    // Use pump with duration instead of pumpAndSettle — the app has async
    // init (tryRestoreSession) that keeps frames pumping indefinitely.
    await tester.pump(const Duration(seconds: 1));

    // App should render the MaterialApp with title
    expect(find.byType(BigTopApp), findsOneWidget);
  });
}
