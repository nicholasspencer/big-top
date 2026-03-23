import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:state_notifier/state_notifier.dart';

import 'package:big_top/src/board/interactors/board_selector.dart';
import 'package:big_top/src/core/async_value.dart';
import 'package:big_top/src/project/interactors/project_interactor.dart';

part 'board_viewmodel.freezed.dart';

@freezed
sealed class BoardData with _$BoardData {
  const factory BoardData({
    required List<BoardColumn> columns,
    String? username,
    String? avatarUrl,
  }) = _BoardData;
}

class BoardViewModel extends StateNotifier<AsyncValue<BoardData>> {
  final ProjectInteractor _interactor;
  final BoardSelector _boardSelector;
  final String? _username;
  final String? _avatarUrl;
  late final void Function() _removeListener;

  BoardViewModel({
    required ProjectInteractor interactor,
    required BoardSelector boardSelector,
    String? username,
    String? avatarUrl,
  })  : _interactor = interactor,
        _boardSelector = boardSelector,
        _username = username,
        _avatarUrl = avatarUrl,
        super(const AsyncValue.none()) {
    _mapSelectorState(_boardSelector.state);
    _removeListener = _boardSelector.addListener(_mapSelectorState);
  }

  void _mapSelectorState(AsyncValue<List<BoardColumn>> selectorState) {
    state = selectorState.map((columns) => BoardData(
          columns: columns,
          username: _username,
          avatarUrl: _avatarUrl,
        ));
  }

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
    _removeListener();
    super.dispose();
  }
}
