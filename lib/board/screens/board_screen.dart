import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:big_top/core/async_value.dart';
import 'package:big_top/auth/models/auth_session.dart';
import 'package:big_top/auth/repositories/auth_repository.dart';
import '../widgets/status_column.dart';

class BoardScreen extends StatelessWidget {
  const BoardScreen({super.key});

  static const _columns = ['open', 'in_progress', 'blocked', 'closed'];
  static const _columnLabels = {
    'open': 'Open',
    'in_progress': 'In Progress',
    'blocked': 'Blocked',
    'closed': 'Closed',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authValue = context.watch<AsyncValue<AuthSession>>();
    final session = authValue.data;

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
          if (session?.username != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Chip(
                avatar: session?.avatarUrl != null
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(session!.avatarUrl!),
                      )
                    : null,
                label: Text(session!.username!),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final status in _columns)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: StatusColumn(
                    title: _columnLabels[status] ?? status,
                    status: status,
                    issues: const [],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
