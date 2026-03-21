import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/app_dependencies.dart';
import 'app/authorized_dependencies.dart';
import 'app/router.dart';
import 'app/theme.dart';
import 'core/async_value.dart';
import 'auth/models/auth_session.dart';

void main() {
  runApp(const BigTopApp());
}

class BigTopApp extends StatelessWidget {
  const BigTopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        AppDependencies(),
        AuthorizedDependencies(),
      ],
      child: const _BigTopRouter(),
    );
  }
}

class _BigTopRouter extends StatelessWidget {
  const _BigTopRouter();

  @override
  Widget build(BuildContext context) {
    // Watch auth state so router refreshes on auth changes
    context.watch<AsyncValue<AuthSession>>();

    return MaterialApp.router(
      title: 'Big Top',
      theme: BigTopTheme.light,
      darkTheme: BigTopTheme.dark,
      themeMode: ThemeMode.dark,
      routerConfig: createRouter(context),
      debugShowCheckedModeBanner: false,
    );
  }
}
