import 'package:freezed_annotation/freezed_annotation.dart';

part 'event.freezed.dart';
part 'event.g.dart';

@freezed
sealed class Event with _$Event {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Event({
    required String id,
    required String issueId,
    required String eventType,
    @Default('') String actor,
    required DateTime createdAt,
    @Default({}) Map<String, dynamic> data,
  }) = _Event;

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
}
