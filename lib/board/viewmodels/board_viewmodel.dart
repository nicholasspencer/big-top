import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:state_notifier/state_notifier.dart';

import 'package:big_top/board/interactors/board_selector.dart';
import 'package:big_top/project/interactors/project_interactor.dart';

part 'board_viewmodel.freezed.dart';

@freezed
sealed class BoardState with _$BoardState {
  const factory BoardState.loading() = BoardStateLoading;
  const factory BoardState.loaded({
    required List<BoardColumn> columns,
    String? username,
    String? avatarUrl,
  }) = BoardStateLoaded;
  const factory BoardState.empty() = BoardStateEmpty;
  const factory BoardState.error({required String message}) = BoardStateError;
}

class BoardViewModel extends StateNotifier<BoardState> {
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
        super(const BoardState.empty()) {
    _mapSelectorState(_boardSelector.state);
    _removeListener = _boardSelector.addListener(_mapSelectorState);
  }

  void _mapSelectorState(BoardSelectorState selectorState) {
    state = switch (selectorState) {
      BoardSelectorEmpty() => const BoardState.empty(),
      BoardSelectorLoading() => const BoardState.loading(),
      BoardSelectorLoaded(:final columns) => BoardState.loaded(
          columns: columns,
          username: _username,
          avatarUrl: _avatarUrl,
        ),
      BoardSelectorError(:final message) => BoardState.error(message: message),
    };
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
