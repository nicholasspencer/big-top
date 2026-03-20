import 'package:flutter/foundation.dart';
import 'package:state_notifier/state_notifier.dart';

import '../models/comment.dart';
import '../models/dependency.dart';
import '../models/issue.dart';
import '../models/label.dart';
import '../repositories/issues_repository.dart';

@immutable
class DetailState {
  final Issue? issue;
  final List<Comment> comments;
  final List<Label> labels;
  final List<Dependency> dependencies;

  const DetailState({
    this.issue,
    this.comments = const [],
    this.labels = const [],
    this.dependencies = const [],
  });
}

class DetailViewModel extends StateNotifier<DetailState> {
  final IssuesRepository _issuesRepo;
  final String issueId;
  late final Function() _removeListener;

  DetailViewModel({
    required IssuesRepository issuesRepo,
    required this.issueId,
  })  : _issuesRepo = issuesRepo,
        super(const DetailState()) {
    // Populate from current issues state
    _update(_issuesRepo.state);
    // Listen for future changes
    _removeListener = _issuesRepo.addListener(_update);
  }

  void _update(IssuesState issuesState) {
    final issue = issuesState.issues
        .where((i) => i.id == issueId)
        .firstOrNull;
    state = DetailState(
      issue: issue,
      comments:
          issuesState.comments.where((c) => c.issueId == issueId).toList(),
      labels:
          issuesState.labels.where((l) => l.issueId == issueId).toList(),
      dependencies: issuesState.dependencies
          .where((d) => d.issueId == issueId || d.dependsOnId == issueId)
          .toList(),
    );
  }

  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }
}
