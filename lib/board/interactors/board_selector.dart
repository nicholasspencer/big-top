import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:state_notifier/state_notifier.dart';

import 'package:big_top/core/async_value.dart';
import 'package:big_top/project/models/issue.dart';
import 'package:big_top/project/models/project_data.dart';
import 'package:big_top/project/repositories/project_data_repository.dart';

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
  late final void Function() _removeListener;

  BoardSelector({required ProjectDataRepository dataRepo})
      : _dataRepo = dataRepo,
        super(const AsyncValue.none()) {
    _recompute(_dataRepo.state);
    _removeListener = _dataRepo.addListener(_recompute);
  }

  void _recompute(AsyncValue<ProjectData> asyncValue) {
    state = asyncValue.map((data) => _buildColumns(data.issues));
  }

  static List<BoardColumn> _buildColumns(List<Issue> issues) {
    final grouped = <String, List<Issue>>{};
    for (final issue in issues) {
      (grouped[issue.status] ??= []).add(issue);
    }
    return [
      for (final (status, label) in _columnDefs)
        BoardColumn(
          status: status,
          label: label,
          issues: (grouped[status] ?? [])..sort((a, b) => a.priority.compareTo(b.priority)),
        ),
    ];
  }

  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }
}
