import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../auth/repositories/auth_repository.dart';
import '../board/screens/board_screen.dart';
import '../detail/screens/detail_screen.dart';
import '../auth/screens/login_screen.dart';

GoRouter createRouter(BuildContext context) {
  final authRepo = context.read<AuthRepository>();

  return GoRouter(
    initialLocation: '/',
    refreshListenable: _AuthNotifier(authRepo),
    redirect: (BuildContext context, GoRouterState state) {
      final authed = authRepo.isAuthenticated;
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

/// Bridges [AuthRepository] state changes to [GoRouter.refreshListenable].
/// Only notifies when authentication status actually changes (authed ↔ not authed),
/// NOT on intermediate state transitions (none → waiting → active).
class _AuthNotifier extends ChangeNotifier {
  bool _wasAuthenticated = false;
  Function()? _removeListener;

  _AuthNotifier(AuthRepository authRepo) {
    _wasAuthenticated = authRepo.isAuthenticated;
    _removeListener = authRepo.addListener((state) {
      final isAuthed = state.hasData;
      if (isAuthed != _wasAuthenticated) {
        _wasAuthenticated = isAuthed;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _removeListener?.call();
    super.dispose();
  }
}
