import 'comment.dart';
import 'dependency.dart';
import 'event.dart';
import 'issue.dart';
import 'label.dart';

/// All entity data for a single beads project.
class ProjectData {
  final List<Issue> issues;
  final List<Comment> comments;
  final List<Label> labels;
  final List<Dependency> dependencies;
  final List<Event> events;

  const ProjectData({
    this.issues = const [],
    this.comments = const [],
    this.labels = const [],
    this.dependencies = const [],
    this.events = const [],
  });
}
