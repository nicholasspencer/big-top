import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../repositories/auth_repository.dart';
import '../services/github_api_service.dart';
import '../services/github_auth_service.dart';

class AppDependencies extends SingleChildStatelessWidget {
  const AppDependencies({super.key, super.child});

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return MultiProvider(
      providers: [
        Provider<GitHubAuthService>(create: (_) => GitHubAuthService()),
        Provider<GitHubApiService>(create: (_) => GitHubApiService()),
        StateNotifierProvider<AuthRepository, AuthState>(
          create: (ctx) => AuthRepository(
            authService: ctx.read<GitHubAuthService>(),
          )..tryRestoreSession(),
        ),
      ],
      child: child!,
    );
  }
}
