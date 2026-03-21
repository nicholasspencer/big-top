// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Comment _$CommentFromJson(Map<String, dynamic> json) => _Comment(
  id: json['id'] as String,
  issueId: json['issue_id'] as String,
  author: json['author'] as String? ?? '',
  content: json['content'] as String? ?? '',
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$CommentToJson(_Comment instance) => <String, dynamic>{
  'id': instance.id,
  'issue_id': instance.issueId,
  'author': instance.author,
  'content': instance.content,
  'created_at': instance.createdAt.toIso8601String(),
};
