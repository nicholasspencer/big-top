import 'package:flutter/material.dart';

import 'package:big_top/project/models/issue.dart';

class IssueCard extends StatelessWidget {
  final Issue issue;
  final VoidCallback? onTap;

  const IssueCard({super.key, required this.issue, this.onTap});

  Color _priorityColor(int priority) {
    switch (priority) {
      case 0:
        return Colors.red;
      case 1:
        return Colors.orange;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.grey;
      default:
        return Colors.grey.shade400;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _priorityColor(issue.priority),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      issue.id,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  if (issue.assignee.isNotEmpty)
                    Tooltip(
                      message: issue.assignee,
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor:
                            theme.colorScheme.primaryContainer,
                        child: Text(
                          issue.assignee[0].toUpperCase(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontSize: 10,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                issue.title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (issue.labels.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    for (final label in issue.labels)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          label,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color:
                                theme.colorScheme.onSecondaryContainer,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
              if (issue.dependencyCount > 0 || issue.commentCount > 0) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (issue.dependencyCount > 0) ...[
                      Icon(
                        Icons.link,
                        size: 14,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${issue.dependencyCount}',
                        style: theme.textTheme.labelSmall,
                      ),
                      const SizedBox(width: 8),
                    ],
                    if (issue.commentCount > 0) ...[
                      Icon(
                        Icons.comment_outlined,
                        size: 14,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${issue.commentCount}',
                        style: theme.textTheme.labelSmall,
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
