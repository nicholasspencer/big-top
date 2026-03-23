import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:state_notifier/state_notifier.dart';

import 'package:big_top/core/async_value.dart';
import 'package:big_top/project/models/issue.dart';
import 'package:big_top/project/models/label.dart';
import 'package:big_top/project/models/project_data.dart';
import 'package:big_top/project/repositories/project_data_repository.dart';

import 'filter_interactor.dart';

part 'board_selector.freezed.dart';

@freezed
sealed class BoardColumn with _$BoardColumn {
  const factory BoardColumn({
    required String status,
    required String label,
    @Default([]) List<Issue> issues,
  }) = _BoardColumn;
}

const _columnDefs = [
  ('open', 'Open'),
  ('in_progress', 'In Progress'),
  ('blocked', 'Blocked'),
  ('closed', 'Closed'),
];

class BoardSelector extends StateNotifier<AsyncValue<List<BoardColumn>>> {
  final ProjectDataRepository _dataRepo;
  final FilterInteractor? _filterInteractor;
  late final void Function() _removeDataListener;
  void Function()? _removeFilterListener;

  AsyncValue<ProjectData> _lastData = const AsyncValue.none();

  BoardSelector({
    required ProjectDataRepository dataRepo,
    FilterInteractor? filterInteractor,
  })  : _dataRepo = dataRepo,
        _filterInteractor = filterInteractor,
        super(const AsyncValue.none()) {
    _lastData = _dataRepo.state;
    _recompute(_dataRepo.state);
    _removeDataListener = _dataRepo.addListener(_onDataChanged);
    if (_filterInteractor != null) {
      _removeFilterListener =
          _filterInteractor.addListener(_onFilterChanged);
    }
  }

  void _onDataChanged(AsyncValue<ProjectData> asyncValue) {
    _lastData = asyncValue;
    _rebuild();
  }

  void _onFilterChanged(BoardFilter filter) {
    _rebuild();
  }

  void _rebuild() {
    _recompute(_lastData);
  }

  void _recompute(AsyncValue<ProjectData> asyncValue) {
    state = asyncValue.map((data) {
      final filter = _filterInteractor?.state ?? const BoardFilter();
      return _buildColumns(data.issues, data.labels, filter);
    });
  }

  static List<BoardColumn> _buildColumns(
    List<Issue> issues,
    List<Label> labels,
    BoardFilter filter,
  ) {
    // Denormalize labels onto issues
    final labelsByIssue = <String, List<String>>{};
    for (final label in labels) {
      (labelsByIssue[label.issueId] ??= []).add(label.label);
    }

    final enrichedIssues = issues.map((issue) {
      final issueLabels = labelsByIssue[issue.id] ?? [];
      return issue.copyWith(
        labels: issueLabels.isNotEmpty ? issueLabels : issue.labels,
      );
    }).toList();

    // Apply filters
    final filtered = _applyFilters(enrichedIssues, filter);

    // Group by status
    final grouped = <String, List<Issue>>{};
    for (final issue in filtered) {
      (grouped[issue.status] ??= []).add(issue);
    }

    return [
      for (final (status, label) in _columnDefs)
        BoardColumn(
          status: status,
          label: label,
          issues: (grouped[status] ?? [])
            ..sort((a, b) => a.priority.compareTo(b.priority)),
        ),
    ];
  }

  static List<Issue> _applyFilters(List<Issue> issues, BoardFilter filter) {
    if (!filter.isActive) return issues;

    return issues.where((issue) {
      if (filter.labels.isNotEmpty) {
        if (!issue.labels.any((l) => filter.labels.contains(l))) {
          return false;
        }
      }
      if (filter.priorities.isNotEmpty) {
        if (!filter.priorities.contains(issue.priority)) {
          return false;
        }
      }
      if (filter.assignees.isNotEmpty) {
        if (!filter.assignees.contains(issue.assignee)) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  @override
  void dispose() {
    _removeDataListener();
    _removeFilterListener?.call();
    super.dispose();
  }
}
