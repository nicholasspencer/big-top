import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:provider/provider.dart';

import 'package:big_top/detail/interactors/issue_detail_selector.dart';
import 'package:big_top/detail/viewmodels/detail_viewmodel.dart';
import 'package:big_top/project/repositories/project_data_repository.dart';

class DetailScreen extends StatelessWidget {
  final String issueId;

  const DetailScreen({super.key, required this.issueId});

  @override
  Widget build(BuildContext context) {
    return StateNotifierProvider<DetailViewModel, IssueDetailState>(
      create: (ctx) => DetailViewModel(
        selector: IssueDetailSelector(
          dataRepo: ctx.read<ProjectDataRepository>(),
          issueId: issueId,
        ),
      ),
      child: const _DetailScreenContent(),
    );
  }
}

class _DetailScreenContent extends StatelessWidget {
  const _DetailScreenContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final detailState = context.watch<IssueDetailState>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          switch (detailState) {
            IssueDetailLoaded(:final issue) => issue.title,
            _ => 'Issue Detail',
          },
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: switch (detailState) {
            IssueDetailEmpty() || IssueDetailLoading() =>
              const CircularProgressIndicator(),
            IssueDetailNotFound() => const Text('Issue not found'),
            IssueDetailError(:final message) => Text(message),
            IssueDetailLoaded(
              :final issue,
              :final comments,
              :final labels,
            ) =>
              SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          issue.title,
                          style: theme.textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 8),
                        Chip(label: Text(issue.status)),
                        if (issue.description.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Text(
                            issue.description,
                            style: theme.textTheme.bodyLarge,
                          ),
                        ],
                        if (labels.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 8,
                            children: [
                              for (final label in labels)
                                Chip(label: Text(label.label)),
                            ],
                          ),
                        ],
                        if (comments.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          Text(
                            'Comments',
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          for (final comment in comments) ...[
                            ListTile(
                              title: Text(comment.author),
                              subtitle: Text(comment.content),
                              trailing: Text(
                                comment.createdAt.toLocal().toString(),
                                style: theme.textTheme.bodySmall,
                              ),
                            ),
                            const Divider(),
                          ],
                        ],
                      ],
                    ),
                  ),
                ),
              ),
          },
        ),
      ),
    );
  }
}
