import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../core/async_value.dart';
import '../auth/models/auth_session.dart';
import '../project/models/project_data.dart';
import '../project/repositories/project_data_repository.dart';
import '../project/repositories/project_repository.dart';
import '../project/services/github_api_service.dart';

class AuthorizedDependencies extends SingleChildStatelessWidget {
  const AuthorizedDependencies({super.key, super.child});

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    final authValue = context.watch<AsyncValue<AuthSession>>();

    if (!authValue.hasData) return child!;

    return MultiProvider(
      providers: [
        StateNotifierProvider<ProjectDataRepository, AsyncValue<ProjectData>>(
          create: (ctx) => ProjectDataRepository(
            apiService: ctx.read<GitHubApiService>(),
            token: authValue.requireData().token,
          ),
        ),
        StateNotifierProvider<ProjectRepository, ProjectState>(
          create: (_) => ProjectRepository(),
        ),
      ],
      child: child!,
    );
  }
}
