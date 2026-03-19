import 'package:flutter/foundation.dart';
import 'package:state_notifier/state_notifier.dart';

@immutable
class ProjectState {
  final String? owner;
  final String? repo;

  const ProjectState({this.owner, this.repo});

  bool get isSelected => owner != null && repo != null;

  String get fullName => '$owner/$repo';

  ProjectState copyWith({String? owner, String? repo}) {
    return ProjectState(
      owner: owner ?? this.owner,
      repo: repo ?? this.repo,
    );
  }
}

class ProjectProvider extends StateNotifier<ProjectState> {
  ProjectProvider() : super(const ProjectState());

  void selectProject({required String owner, required String repo}) {
    state = ProjectState(owner: owner, repo: repo);
  }

  void clear() {
    state = const ProjectState();
  }
}
