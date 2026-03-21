import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../core/async_value.dart';
import '../auth/models/auth_session.dart';
import '../auth/repositories/auth_repository.dart';
import '../project/services/github_api_service.dart';
import '../auth/services/github_auth_service.dart';

class AppDependencies extends SingleChildStatelessWidget {
  const AppDependencies({super.key, super.child});

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return MultiProvider(
      providers: [
        Provider<GitHubAuthService>(create: (_) => GitHubAuthService()),
        Provider<GitHubApiService>(create: (_) => GitHubApiService()),
        StateNotifierProvider<AuthRepository, AsyncValue<AuthSession>>(
          create: (ctx) => AuthRepository(
            authService: ctx.read<GitHubAuthService>(),
          )..tryRestoreSession(),
        ),
      ],
      child: child!,
    );
  }
}
