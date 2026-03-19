import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
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
    final authState = context.watch<AuthState>();

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
          if (authState.username != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Chip(
                avatar: authState.avatarUrl != null
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(authState.avatarUrl!),
                      )
                    : null,
                label: Text(authState.username!),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
            onPressed: () => context.read<AuthProvider>().logout(),
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
