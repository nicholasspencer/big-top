// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dependency.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Dependency _$DependencyFromJson(Map<String, dynamic> json) => _Dependency(
  issueId: json['issue_id'] as String,
  dependsOnId: json['depends_on_id'] as String,
  type: json['type'] as String? ?? 'blocks',
  createdAt: DateTime.parse(json['created_at'] as String),
  createdBy: json['created_by'] as String? ?? '',
  metadata: json['metadata'] as String? ?? '{}',
);

Map<String, dynamic> _$DependencyToJson(_Dependency instance) =>
    <String, dynamic>{
      'issue_id': instance.issueId,
      'depends_on_id': instance.dependsOnId,
      'type': instance.type,
      'created_at': instance.createdAt.toIso8601String(),
      'created_by': instance.createdBy,
      'metadata': instance.metadata,
    };
