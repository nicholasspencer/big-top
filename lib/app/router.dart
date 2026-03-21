import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/async_value.dart';
import '../auth/models/auth_session.dart';
import '../board/screens/board_screen.dart';
import '../detail/screens/detail_screen.dart';
import '../auth/screens/login_screen.dart';

GoRouter createRouter(BuildContext context) {
  return GoRouter(
    initialLocation: '/',
    redirect: (BuildContext context, GoRouterState state) {
      final authValue = context.read<AsyncValue<AuthSession>>();
      final authed = authValue.hasData;
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
