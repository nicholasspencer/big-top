// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Event _$EventFromJson(Map<String, dynamic> json) => _Event(
  id: json['id'] as String,
  issueId: json['issue_id'] as String,
  eventType: json['event_type'] as String,
  actor: json['actor'] as String? ?? '',
  createdAt: DateTime.parse(json['created_at'] as String),
  data: json['data'] as Map<String, dynamic>? ?? const {},
);

Map<String, dynamic> _$EventToJson(_Event instance) => <String, dynamic>{
  'id': instance.id,
  'issue_id': instance.issueId,
  'event_type': instance.eventType,
  'actor': instance.actor,
  'created_at': instance.createdAt.toIso8601String(),
  'data': instance.data,
};
