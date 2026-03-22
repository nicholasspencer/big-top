import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:provider/provider.dart';

import 'package:big_top/auth/repositories/auth_repository.dart';
import 'package:big_top/board/interactors/board_selector.dart';
import 'package:big_top/board/viewmodels/board_viewmodel.dart';
import 'package:big_top/core/async_value.dart';
import 'package:big_top/auth/models/auth_session.dart';
import 'package:big_top/project/interactors/project_interactor.dart';
import '../widgets/status_column.dart';

class BoardScreen extends StatelessWidget {
  const BoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authValue = context.read<AsyncValue<AuthSession>>();
    final session = authValue.data;

    return StateNotifierProvider<BoardViewModel, BoardState>(
      create: (ctx) => BoardViewModel(
        interactor: ctx.read<ProjectInteractor>(),
        boardSelector: ctx.read<BoardSelector>(),
        username: session?.username,
        avatarUrl: session?.avatarUrl,
      ),
      child: const _BoardScreenContent(),
    );
  }
}

class _BoardScreenContent extends StatelessWidget {
  const _BoardScreenContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final boardState = context.watch<BoardState>();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.festival, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            const Text('Big Top'),
          ],
        ),
        actions: [
          if (boardState case BoardStateLoaded(:final username?, :final avatarUrl))
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Chip(
                avatar: avatarUrl != null
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(avatarUrl),
                      )
                    : null,
                label: Text(username),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
            onPressed: () => context.read<AuthRepository>().logout(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: switch (boardState) {
          BoardStateEmpty() => const Center(
              child: Text('Select a project to get started'),
            ),
          BoardStateLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
          BoardStateError(:final message) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<BoardViewModel>().refresh(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          BoardStateLoaded(:final columns) => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final column in columns)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: StatusColumn(
                        title: column.label,
                        status: column.status,
                        issues: column.issues,
                      ),
                    ),
                  ),
              ],
            ),
        },
      ),
    );
  }
}
