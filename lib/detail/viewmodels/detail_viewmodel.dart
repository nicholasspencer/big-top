import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:state_notifier/state_notifier.dart';

import 'package:big_top/core/async_value.dart';
import 'package:big_top/project/models/comment.dart';
import 'package:big_top/project/models/dependency.dart';
import 'package:big_top/project/models/issue.dart';
import 'package:big_top/project/models/label.dart';
import 'package:big_top/project/models/project_data.dart';
import 'package:big_top/project/repositories/issues_repository.dart';

part 'detail_viewmodel.freezed.dart';

@freezed
sealed class DetailState with _$DetailState {
  const factory DetailState({
    Issue? issue,
    @Default([]) List<Comment> comments,
    @Default([]) List<Label> labels,
    @Default([]) List<Dependency> dependencies,
  }) = _DetailState;
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

  void _update(AsyncValue<ProjectData> value) {
    final data = value.data;
    if (data == null) {
      state = const DetailState();
      return;
    }
    state = DetailState(
      issue: data.issues.where((i) => i.id == issueId).firstOrNull,
      comments:
          data.comments.where((c) => c.issueId == issueId).toList(),
      labels:
          data.labels.where((l) => l.issueId == issueId).toList(),
      dependencies: data.dependencies
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
