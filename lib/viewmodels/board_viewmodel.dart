import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:state_notifier/state_notifier.dart';

import '../repositories/issues_repository.dart';
import '../repositories/project_repository.dart';

part 'board_viewmodel.freezed.dart';

@freezed
sealed class BoardState with _$BoardState {
  const factory BoardState({
    @Default(false) bool isLoading,
    String? error,
  }) = _BoardState;
}

class BoardViewModel extends StateNotifier<BoardState> {
  final IssuesRepository _issuesRepo;
  final ProjectRepository _projectRepo;

  BoardViewModel({
    required IssuesRepository issuesRepo,
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
