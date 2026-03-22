import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:state_notifier/state_notifier.dart';

import 'package:big_top/project/repositories/project_data_repository.dart';
import 'package:big_top/project/repositories/project_repository.dart';

part 'board_viewmodel.freezed.dart';

@freezed
sealed class BoardState with _$BoardState {
  const factory BoardState({
    @Default(false) bool isLoading,
    String? error,
  }) = _BoardState;
}

class BoardViewModel extends StateNotifier<BoardState> {
  final ProjectDataRepository _issuesRepo;
  final ProjectRepository _projectRepo;

  BoardViewModel({
    required ProjectDataRepository issuesRepo,
    required ProjectRepository projectRepo,
  })  : _issuesRepo = issuesRepo,
        _projectRepo = projectRepo,
        super(const BoardState());

  Future<void> selectProject({
    required String owner,
    required String repo,
    String? project,
  }) async {
    _projectRepo.selectProject(owner: owner, repo: repo, project: project);
    await refresh();
  }

  Future<void> refresh() async {
    final projectState = _projectRepo.state;
    if (!projectState.isSelected) return;

    state = state.copyWith(isLoading: true, error: null);
    try {
      await _issuesRepo.loadProject(
        owner: projectState.owner!,
        repo: projectState.repo!,
        project: projectState.project ?? projectState.repo!,
      );
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
