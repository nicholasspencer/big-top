import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment.freezed.dart';
part 'comment.g.dart';

@freezed
sealed class Comment with _$Comment {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Comment({
    required String id,
    required String issueId,
    @Default('') String author,
    @Default('') String content,
    required DateTime createdAt,
  }) = _Comment;

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);
}
