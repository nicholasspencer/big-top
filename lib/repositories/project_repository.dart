import 'package:flutter/foundation.dart';
import 'package:state_notifier/state_notifier.dart';

@immutable
class ProjectState {
  final String? owner;
  final String? repo;
  final String? project;

  const ProjectState({this.owner, this.repo, this.project});

  bool get isSelected => owner != null && repo != null;

  String get fullName => '$owner/$repo';

  ProjectState copyWith({String? owner, String? repo, String? project}) {
    return ProjectState(
      owner: owner ?? this.owner,
      repo: repo ?? this.repo,
      project: project ?? this.project,
    );
  }
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
