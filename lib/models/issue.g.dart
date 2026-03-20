// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'issue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Issue _$IssueFromJson(Map<String, dynamic> json) => _Issue(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String? ?? '',
  status: json['status'] as String? ?? 'open',
  priority: (json['priority'] as num?)?.toInt() ?? 2,
  issueType: json['issue_type'] as String? ?? 'task',
  owner: json['owner'] as String? ?? '',
  createdAt: DateTime.parse(json['created_at'] as String),
  createdBy: json['created_by'] as String? ?? '',
  updatedAt: DateTime.parse(json['updated_at'] as String),
  dependencies:
      (json['dependencies'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  dependencyCount: (json['dependency_count'] as num?)?.toInt() ?? 0,
  commentCount: (json['comment_count'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$IssueToJson(_Issue instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'status': instance.status,
  'priority': instance.priority,
  'issue_type': instance.issueType,
  'owner': instance.owner,
  'created_at': instance.createdAt.toIso8601String(),
  'created_by': instance.createdBy,
  'updated_at': instance.updatedAt.toIso8601String(),
  'dependencies': instance.dependencies,
  'dependency_count': instance.dependencyCount,
  'comment_count': instance.commentCount,
};
