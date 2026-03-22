import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:state_notifier/state_notifier.dart';

import 'package:big_top/project/interactors/project_interactor.dart';

part 'board_viewmodel.freezed.dart';

@freezed
sealed class BoardState with _$BoardState {
  const factory BoardState({
    @Default(false) bool isLoading,
    String? error,
  }) = _BoardState;
}

class BoardViewModel extends StateNotifier<BoardState> {
  final ProjectInteractor _interactor;

  BoardViewModel({
    required ProjectInteractor interactor,
  })  : _interactor = interactor,
        super(const BoardState());

  Future<void> selectProject({
    required String owner,
    required String repo,
    String? project,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _interactor.selectProject(
        owner: owner,
        repo: repo,
        project: project,
      );
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _interactor.refresh();
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
