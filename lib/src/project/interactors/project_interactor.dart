import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:state_notifier/state_notifier.dart';

import 'package:big_top/src/core/async_value.dart';
import '../models/project_data.dart';
import '../repositories/project_data_repository.dart';

part 'project_interactor.freezed.dart';

@freezed
sealed class ProjectSelection with _$ProjectSelection {
  const factory ProjectSelection.none() = ProjectSelectionNone;
  const factory ProjectSelection.selected({
    required String owner,
    required String repo,
    required String project,
  }) = ProjectSelectionSelected;
}

@freezed
sealed class ProjectInteractorState with _$ProjectInteractorState {
  const factory ProjectInteractorState({
    @Default(ProjectSelection.none()) ProjectSelection selection,
    @Default(AsyncValue<ProjectData>.none()) AsyncValue<ProjectData> data,
  }) = _ProjectInteractorState;
}

class ProjectInteractor extends StateNotifier<ProjectInteractorState> {
  final ProjectDataRepository _dataRepo;
  late final void Function() _removeListener;

  ProjectInteractor({required ProjectDataRepository dataRepo})
      : _dataRepo = dataRepo,
        super(const ProjectInteractorState()) {
    _removeListener = _dataRepo.addListener((dataState) {
      state = state.copyWith(data: dataState);
    });
  }

  Future<void> selectProject({
    required String owner,
    required String repo,
    String? project,
  }) async {
    final resolvedProject = project ?? repo;
    state = state.copyWith(
      selection: ProjectSelection.selected(
        owner: owner,
        repo: repo,
        project: resolvedProject,
      ),
    );
    await refresh();
  }

  Future<void> refresh() async {
    final sel = state.selection;
    if (sel is! ProjectSelectionSelected) return;
    await _dataRepo.loadProject(
      owner: sel.owner,
      repo: sel.repo,
      project: sel.project,
    );
  }

  void clear() {
    state = const ProjectInteractorState();
  }

  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }
}
