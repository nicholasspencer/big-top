import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:provider/provider.dart';

import 'app/router.dart';
import 'app/theme.dart';
import 'providers/auth_provider.dart';
import 'providers/issues_provider.dart';
import 'providers/project_provider.dart';
import 'services/github_api_service.dart';

void main() {
  runApp(const BigTopApp());
}

class BigTopApp extends StatefulWidget {
  const BigTopApp({super.key});

  @override
  State<BigTopApp> createState() => _BigTopAppState();
}

class _BigTopAppState extends State<BigTopApp> {
  late final AuthProvider _authProvider;
  late final IssuesProvider _issuesProvider;
  late final ProjectProvider _projectProvider;
  late final GitHubApiService _apiService;

  @override
  void initState() {
    super.initState();
    _apiService = GitHubApiService();
    _authProvider = AuthProvider();
    _issuesProvider = IssuesProvider(apiService: _apiService);
    _projectProvider = ProjectProvider();

    _authProvider.tryRestoreSession();
  }

  @override
  void dispose() {
    _authProvider.dispose();
    _issuesProvider.dispose();
    _projectProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StateNotifierProvider<AuthProvider, AuthState>.value(
          value: _authProvider,
        ),
        StateNotifierProvider<IssuesProvider, IssuesState>.value(
          value: _issuesProvider,
        ),
        StateNotifierProvider<ProjectProvider, ProjectState>.value(
          value: _projectProvider,
        ),
        Provider<GitHubApiService>.value(value: _apiService),
      ],
      child: _AppWithRouter(authProvider: _authProvider),
    );
  }
}

class _AppWithRouter extends StatefulWidget {
  final AuthProvider authProvider;

  const _AppWithRouter({required this.authProvider});

  @override
  State<_AppWithRouter> createState() => _AppWithRouterState();
}

class _AppWithRouterState extends State<_AppWithRouter> {
  late final _router = createRouter(
    () => widget.authProvider.isAuthenticated,
  );

  @override
  Widget build(BuildContext context) {
    // Listen to auth state to trigger router refresh
    context.watch<AuthState>();

    return MaterialApp.router(
      title: 'Big Top',
      theme: BigTopTheme.light,
      darkTheme: BigTopTheme.dark,
      themeMode: ThemeMode.dark,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
