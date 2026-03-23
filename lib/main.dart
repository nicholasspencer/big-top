import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'src/app/app_dependencies.dart';
import 'src/app/authorized_dependencies.dart';
import 'src/app/router.dart';
import 'src/app/theme.dart';

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

class _BigTopRouter extends StatefulWidget {
  const _BigTopRouter();

  @override
  State<_BigTopRouter> createState() => _BigTopRouterState();
}

class _BigTopRouterState extends State<_BigTopRouter> {
  GoRouter? _router;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Create the router once, not on every auth state change.
    // The router's own refreshListenable handles auth redirects.
    _router ??= createRouter(context);
  }

  @override
  void dispose() {
    _router?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Big Top',
      theme: BigTopTheme.light,
      darkTheme: BigTopTheme.dark,
      themeMode: ThemeMode.dark,
      routerConfig: _router!,
      debugShowCheckedModeBanner: false,
    );
  }
}
