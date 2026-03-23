import 'package:freezed_annotation/freezed_annotation.dart';

part 'dependency.freezed.dart';
part 'dependency.g.dart';

@freezed
sealed class Dependency with _$Dependency {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Dependency({
    required String issueId,
    required String dependsOnId,
    @Default('blocks') String type,
    required DateTime createdAt,
    @Default('') String createdBy,
    @Default('{}') String metadata,
  }) = _Dependency;

  factory Dependency.fromJson(Map<String, dynamic> json) =>
      _$DependencyFromJson(json);
}
