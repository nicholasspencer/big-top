import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:state_notifier/state_notifier.dart';

import 'package:big_top/src/auth/models/auth_session.dart';
import 'package:big_top/src/auth/repositories/auth_repository.dart';
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
  final AuthRepository _authRepo;
  late final void Function() _removeBoardListener;
  late final void Function() _removeAuthListener;

  String? _username;
  String? _avatarUrl;

  BoardViewModel({
    required ProjectInteractor interactor,
    required BoardSelector boardSelector,
    required AuthRepository authRepo,
  })  : _interactor = interactor,
        _boardSelector = boardSelector,
        _authRepo = authRepo,
        super(const AsyncValue.none()) {
    // Seed auth state from current value.
    _syncAuth(_authRepo.state);
    _removeAuthListener = _authRepo.addListener(_syncAuth);

    _mapSelectorState(_boardSelector.state);
    _removeBoardListener = _boardSelector.addListener(_mapSelectorState);
  }

  void _syncAuth(AsyncValue<AuthSession> authState) {
    final session = authState.data;
    _username = session?.username;
    _avatarUrl = session?.avatarUrl;
    // Re-map the board state so username/avatarUrl update in the UI.
    _mapSelectorState(_boardSelector.state);
  }

  void _mapSelectorState(AsyncValue<List<BoardColumn>> selectorState) {
    state = selectorState.map((columns) => BoardData(
          columns: columns,
          username: _username,
          avatarUrl: _avatarUrl,
        ));
  }

  Future<void> logout() async {
    await _authRepo.logout();
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
    _removeBoardListener();
    _removeAuthListener();
    super.dispose();
  }
}
