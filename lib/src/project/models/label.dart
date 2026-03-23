import 'package:freezed_annotation/freezed_annotation.dart';

part 'label.freezed.dart';
part 'label.g.dart';

@freezed
sealed class Label with _$Label {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Label({
    required String issueId,
    required String label,
  }) = _Label;

  factory Label.fromJson(Map<String, dynamic> json) => _$LabelFromJson(json);
}
