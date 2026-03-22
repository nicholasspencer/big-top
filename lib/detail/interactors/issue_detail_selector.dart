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
sealed class IssueDetailState with _$IssueDetailState {
  const factory IssueDetailState.empty() = IssueDetailEmpty;
  const factory IssueDetailState.loading() = IssueDetailLoading;
  const factory IssueDetailState.loaded({
    required Issue issue,
    required List<Comment> comments,
    required List<Label> labels,
    required List<Dependency> dependencies,
  }) = IssueDetailLoaded;
  const factory IssueDetailState.notFound() = IssueDetailNotFound;
  const factory IssueDetailState.error({
    required String message,
  }) = IssueDetailError;
}

class IssueDetailSelector extends StateNotifier<IssueDetailState> {
  final ProjectDataRepository _dataRepo;
  final String _issueId;
  late final void Function() _removeListener;

  IssueDetailSelector({
    required ProjectDataRepository dataRepo,
    required String issueId,
  })  : _dataRepo = dataRepo,
        _issueId = issueId,
        super(const IssueDetailState.empty()) {
    _recompute(_dataRepo.state);
    _removeListener = _dataRepo.addListener(_recompute);
  }

  void _recompute(AsyncValue<ProjectData> asyncValue) {
    if (asyncValue.hasData) {
      final data = asyncValue.data!;
      final issue = data.issues.where((i) => i.id == _issueId).firstOrNull;
      if (issue == null) {
        state = const IssueDetailState.notFound();
        return;
      }
      state = IssueDetailState.loaded(
        issue: issue,
        comments: data.comments.where((c) => c.issueId == _issueId).toList(),
        labels: data.labels.where((l) => l.issueId == _issueId).toList(),
        dependencies: data.dependencies
            .where((d) => d.issueId == _issueId || d.dependsOnId == _issueId)
            .toList(),
      );
      return;
    }

    if (asyncValue.hasError) {
      state = IssueDetailState.error(
        message: asyncValue.error.toString(),
      );
      return;
    }

    state = switch (asyncValue) {
      AsyncValueNone() => const IssueDetailState.empty(),
      AsyncValueWaiting() || AsyncValueActive() =>
        const IssueDetailState.loading(),
      AsyncValueDone() => const IssueDetailState.empty(),
    };
  }

  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }
}
