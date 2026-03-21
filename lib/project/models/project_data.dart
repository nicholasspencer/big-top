import 'package:freezed_annotation/freezed_annotation.dart';

import 'comment.dart';
import 'dependency.dart';
import 'event.dart';
import 'issue.dart';
import 'label.dart';

part 'project_data.freezed.dart';

@freezed
sealed class ProjectData with _$ProjectData {
  const factory ProjectData({
    @Default([]) List<Issue> issues,
    @Default([]) List<Comment> comments,
    @Default([]) List<Label> labels,
    @Default([]) List<Dependency> dependencies,
    @Default([]) List<Event> events,
  }) = _ProjectData;
}
