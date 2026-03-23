import 'package:freezed_annotation/freezed_annotation.dart';

part 'issue.freezed.dart';
part 'issue.g.dart';

@freezed
sealed class Issue with _$Issue {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Issue({
    required String id,
    required String title,
    @Default('') String description,
    @Default('open') String status,
    @Default(2) int priority,
    @Default('task') String issueType,
    @Default('') String owner,
    required DateTime createdAt,
    @Default('') String createdBy,
    required DateTime updatedAt,
    @Default([]) List<String> dependencies,
    @Default(0) int dependencyCount,
    @Default(0) int commentCount,
    @Default([]) List<String> labels,
    @Default('') String assignee,
  }) = _Issue;

  factory Issue.fromJson(Map<String, dynamic> json) => _$IssueFromJson(json);
}
