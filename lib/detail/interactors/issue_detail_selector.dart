import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:state_notifier/state_notifier.dart';

import 'package:big_top/core/async_value.dart';
import 'package:big_top/project/models/comment.dart';
import 'package:big_top/project/models/dependency.dart';
import 'package:big_top/project/models/issue.dart';
import 'package:big_top/project/models/label.dart';
import 'package:big_top/project/models/project_data.dart';
import 'package:big_top/project/repositories/project_data_repository.dart';

part 'issue_detail_selector.freezed.dart';

@freezed
sealed class IssueDetail with _$IssueDetail {
  const factory IssueDetail({
    required Issue issue,
    @Default([]) List<Comment> comments,
    @Default([]) List<Label> labels,
    @Default([]) List<Dependency> dependencies,
  }) = _IssueDetail;
}

/// Derives detail for a single issue from the project data repository.
///
/// State is `AsyncValue<IssueDetail>` — mirrors the repo's async state,
/// mapping the inner [ProjectData] to an [IssueDetail] for [_issueId].
/// When the repo has data but the issue isn't found, emits
/// `AsyncValue.done()` with null data.
class IssueDetailSelector extends StateNotifier<AsyncValue<IssueDetail>> {
  final ProjectDataRepository _dataRepo;
  final String _issueId;
  late final void Function() _removeListener;

  IssueDetailSelector({
    required ProjectDataRepository dataRepo,
    required String issueId,
  })  : _dataRepo = dataRepo,
        _issueId = issueId,
        super(const AsyncValue.none()) {
    _recompute(_dataRepo.state);
    _removeListener = _dataRepo.addListener(_recompute);
  }

  void _recompute(AsyncValue<ProjectData> asyncValue) {
    if (asyncValue.hasData) {
      final data = asyncValue.data!;
      final issue = data.issues.where((i) => i.id == _issueId).firstOrNull;
      if (issue == null) {
        // Data loaded but issue not found — done with null data.
        state = const AsyncValue.done();
        return;
      }
      state = asyncValue.map((_) => IssueDetail(
            issue: issue,
            comments:
                data.comments.where((c) => c.issueId == _issueId).toList(),
            labels: data.labels.where((l) => l.issueId == _issueId).toList(),
            dependencies: data.dependencies
                .where(
                    (d) => d.issueId == _issueId || d.dependsOnId == _issueId)
                .toList(),
          ));
      return;
    }

    // No data — propagate the async state as-is (none/waiting/active/done/error).
    state = asyncValue.map((_) => throw StateError('unreachable'));
  }

  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }
}
