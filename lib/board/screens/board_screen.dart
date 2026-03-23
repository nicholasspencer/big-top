import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:provider/provider.dart';

import 'package:big_top/auth/repositories/auth_repository.dart';
import 'package:big_top/board/interactors/board_selector.dart';
import 'package:big_top/board/interactors/filter_interactor.dart';
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

    return StateNotifierProvider<BoardViewModel, AsyncValue<BoardData>>(
      create: (ctx) => BoardViewModel(
        interactor: ctx.read<ProjectInteractor>(),
        boardSelector: ctx.read<BoardSelector>(),
        filterInteractor: ctx.read<FilterInteractor>(),
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
    final boardState = context.watch<AsyncValue<BoardData>>();

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
          if (boardState.data case BoardData(:final username?, :final avatarUrl))
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
        child: _buildBody(context, theme, boardState),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    ThemeData theme,
    AsyncValue<BoardData> boardState,
  ) {
    if (boardState.hasData) {
      final data = boardState.data!;
      final columns = data.columns;
      final filter = data.activeFilter;

      // Collect available filter options from all issues
      final allIssues =
          columns.expand((c) => c.issues).toList();
      // For labels/assignees, we need to look at the unfiltered data.
      // Since filtering is applied upstream, we derive from what's available.
      // TODO: Consider passing unfiltered options separately for richer UX.

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FilterBar(filter: filter, issues: allIssues),
          const SizedBox(height: 8),
          Expanded(
            child: Row(
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
          ),
        ],
      );
    }

    if (boardState.hasError) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(boardState.error.toString()),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<BoardViewModel>().refresh(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return switch (boardState) {
      AsyncValueWaiting() || AsyncValueActive() => const Center(
          child: CircularProgressIndicator(),
        ),
      _ => const Center(
          child: Text('Select a project to get started'),
        ),
    };
  }
}

class _FilterBar extends StatelessWidget {
  final BoardFilter filter;
  final List<dynamic> issues;

  const _FilterBar({required this.filter, required this.issues});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final vm = context.read<BoardViewModel>();

    // Derive available options
    final availableLabels = <String>{};
    final availablePriorities = <int>{};
    final availableAssignees = <String>{};

    for (final issue in issues) {
      if (issue.labels case List<String> labels) {
        availableLabels.addAll(labels);
      }
      availablePriorities.add(issue.priority as int);
      if (issue.assignee case String a when a.isNotEmpty) {
        availableAssignees.add(a);
      }
    }

    // Also include currently-selected filter values (they may have been
    // filtered out of the visible issues)
    availableLabels.addAll(filter.labels);
    availablePriorities.addAll(filter.priorities);
    availableAssignees.addAll(filter.assignees);

    final sortedLabels = availableLabels.toList()..sort();
    final sortedPriorities = availablePriorities.toList()..sort();
    final sortedAssignees = availableAssignees.toList()..sort();

    if (sortedLabels.isEmpty &&
        sortedPriorities.isEmpty &&
        sortedAssignees.isEmpty &&
        !filter.isActive) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: [
        // Label chips
        for (final label in sortedLabels)
          FilterChip(
            label: Text(label),
            selected: filter.labels.contains(label),
            onSelected: (_) => vm.toggleLabelFilter(label),
            visualDensity: VisualDensity.compact,
            backgroundColor: theme.colorScheme.secondaryContainer,
          ),
        // Priority chips
        for (final p in sortedPriorities)
          FilterChip(
            label: Text(_priorityLabel(p)),
            selected: filter.priorities.contains(p),
            onSelected: (_) => vm.togglePriorityFilter(p),
            visualDensity: VisualDensity.compact,
          ),
        // Assignee chips
        for (final assignee in sortedAssignees)
          FilterChip(
            label: Text(assignee),
            selected: filter.assignees.contains(assignee),
            onSelected: (_) => vm.toggleAssigneeFilter(assignee),
            visualDensity: VisualDensity.compact,
            avatar: CircleAvatar(
              radius: 10,
              child: Text(assignee[0].toUpperCase(),
                  style: const TextStyle(fontSize: 10)),
            ),
          ),
        if (filter.isActive)
          ActionChip(
            label: const Text('Clear filters'),
            avatar: const Icon(Icons.clear, size: 16),
            onPressed: () => vm.clearFilters(),
            visualDensity: VisualDensity.compact,
          ),
      ],
    );
  }

  String _priorityLabel(int priority) {
    switch (priority) {
      case 0:
        return 'P0 Critical';
      case 1:
        return 'P1 High';
      case 2:
        return 'P2 Medium';
      case 3:
        return 'P3 Low';
      case 4:
        return 'P4 Backlog';
      default:
        return 'P$priority';
    }
  }
}
