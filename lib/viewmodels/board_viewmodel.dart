import 'package:flutter/foundation.dart';
import 'package:state_notifier/state_notifier.dart';

import '../repositories/issues_repository.dart';
import '../repositories/project_repository.dart';

@immutable
class BoardState {
  final bool isLoading;
  final String? error;

  const BoardState({this.isLoading = false, this.error});

  BoardState copyWith({bool? isLoading, String? error, bool clearError = false}) {
    return BoardState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
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

    state = state.copyWith(isLoading: true, clearError: true);
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
