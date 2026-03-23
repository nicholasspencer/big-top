import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../core/async_value.dart';
import '../auth/models/auth_session.dart';
import '../project/models/project_data.dart';
import '../project/repositories/project_data_repository.dart';
import '../board/interactors/board_selector.dart';
import '../project/interactors/project_interactor.dart';
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
        StateNotifierProvider<ProjectInteractor, ProjectInteractorState>(
          create: (ctx) => ProjectInteractor(
            dataRepo: ctx.read<ProjectDataRepository>(),
          ),
        ),
        StateNotifierProvider<BoardSelector, AsyncValue<List<BoardColumn>>>(
          create: (ctx) => BoardSelector(
            dataRepo: ctx.read<ProjectDataRepository>(),
          ),
        ),
      ],
      child: child!,
    );
  }
}
