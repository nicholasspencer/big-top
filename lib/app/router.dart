import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/board_screen.dart';
import '../screens/detail_screen.dart';
import '../screens/login_screen.dart';

GoRouter createRouter(bool Function() isAuthenticated) {
  return GoRouter(
    initialLocation: '/',
    redirect: (BuildContext context, GoRouterState state) {
      final authed = isAuthenticated();
      final isLoggingIn = state.matchedLocation == '/login';

      if (!authed && !isLoggingIn) return '/login';
      if (authed && isLoggingIn) return '/';
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const BoardScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/issue/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return DetailScreen(issueId: id);
        },
      ),
    ],
  );
}
