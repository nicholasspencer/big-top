import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:state_notifier/state_notifier.dart';

import 'package:big_top/board/interactors/board_selector.dart';
import 'package:big_top/board/interactors/filter_interactor.dart';
import 'package:big_top/core/async_value.dart';
import 'package:big_top/project/interactors/project_interactor.dart';

part 'board_viewmodel.freezed.dart';

@freezed
sealed class BoardData with _$BoardData {
  const factory BoardData({
    required List<BoardColumn> columns,
    required BoardFilter activeFilter,
    String? username,
    String? avatarUrl,
  }) = _BoardData;
}

class BoardViewModel extends StateNotifier<AsyncValue<BoardData>> {
  final ProjectInteractor _interactor;
  final BoardSelector _boardSelector;
  final FilterInteractor _filterInteractor;
  final String? _username;
  final String? _avatarUrl;
  late final void Function() _removeBoardListener;
  late final void Function() _removeFilterListener;

  BoardViewModel({
    required ProjectInteractor interactor,
    required BoardSelector boardSelector,
    required FilterInteractor filterInteractor,
    String? username,
    String? avatarUrl,
  })  : _interactor = interactor,
        _boardSelector = boardSelector,
        _filterInteractor = filterInteractor,
        _username = username,
        _avatarUrl = avatarUrl,
        super(const AsyncValue.none()) {
    _mapState();
    _removeBoardListener = _boardSelector.addListener((_) => _mapState());
    _removeFilterListener =
        _filterInteractor.addListener((_) => _mapState());
  }

  void _mapState() {
    final selectorState = _boardSelector.state;
    state = selectorState.map((columns) => BoardData(
          columns: columns,
          activeFilter: _filterInteractor.state,
          username: _username,
          avatarUrl: _avatarUrl,
        ));
  }

  void toggleLabelFilter(String label) => _filterInteractor.toggleLabel(label);
  void togglePriorityFilter(int priority) =>
      _filterInteractor.togglePriority(priority);
  void toggleAssigneeFilter(String assignee) =>
      _filterInteractor.toggleAssignee(assignee);
  void clearFilters() => _filterInteractor.clearAll();

  Future<void> selectProject({
    required String owner,
    required String repo,
    String? project,
  }) async {
    await _interactor.selectProject(
      owner: owner,
      repo: repo,
      project: project,
    );
  }

  Future<void> refresh() async {
    await _interactor.refresh();
  }

  @override
  void dispose() {
    _removeBoardListener();
    _removeFilterListener();
    super.dispose();
  }
}
