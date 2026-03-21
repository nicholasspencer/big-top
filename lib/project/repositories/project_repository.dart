import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:state_notifier/state_notifier.dart';

part 'project_repository.freezed.dart';

@freezed
sealed class ProjectState with _$ProjectState {
  const ProjectState._();

  const factory ProjectState({
    String? owner,
    String? repo,
    String? project,
  }) = _ProjectState;

  bool get isSelected => owner != null && repo != null;
  String get fullName => '$owner/$repo';
}

class ProjectRepository extends StateNotifier<ProjectState> {
  ProjectRepository() : super(const ProjectState());

  void selectProject({
    required String owner,
    required String repo,
    String? project,
  }) {
    state = ProjectState(owner: owner, repo: repo, project: project);
  }

  void clear() {
    state = const ProjectState();
  }
}
