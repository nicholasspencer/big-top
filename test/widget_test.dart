import 'package:big_top/app/authorized_dependencies.dart';
import 'package:big_top/app/router.dart';
import 'package:big_top/app/theme.dart';
import 'package:big_top/core/async_value.dart';
import 'package:big_top/auth/models/auth_session.dart';
import 'package:big_top/auth/repositories/auth_repository.dart';
import 'package:big_top/project/services/github_api_service.dart';
import 'package:big_top/auth/services/github_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:provider/provider.dart';

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

  testWidgets('App with stubbed services renders login screen',
      (WidgetTester tester) async {
    // Create a mock HTTP client that returns empty responses
    final mockClient = MockClient((request) async {
      return http.Response('{}', 200);
    });

    final authService = GitHubAuthService(client: mockClient);
    final apiService = GitHubApiService(client: mockClient);
    final authRepo = AuthRepository(authService: authService);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<GitHubAuthService>.value(value: authService),
          Provider<GitHubApiService>.value(value: apiService),
          StateNotifierProvider<AuthRepository,
              AsyncValue<AuthSession>>.value(
            value: authRepo,
          ),
          const AuthorizedDependencies(),
        ],
        child: Builder(
          builder: (context) {
            context.watch<AsyncValue<AuthSession>>();
            return MaterialApp.router(
              title: 'Big Top',
              theme: BigTopTheme.light,
              darkTheme: BigTopTheme.dark,
              themeMode: ThemeMode.dark,
              routerConfig: createRouter(context),
              debugShowCheckedModeBanner: false,
            );
          },
        ),
      ),
    );

    await tester.pump(const Duration(seconds: 1));

    // Should show login screen since we're not authenticated
    expect(find.text('Big Top'), findsOneWidget);
    expect(find.text('Sign in with GitHub to continue'), findsOneWidget);

    authRepo.dispose();
  });
}
