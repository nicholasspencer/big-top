import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_session.freezed.dart';

@freezed
sealed class AuthSession with _$AuthSession {
  const factory AuthSession({
    required String token,
    String? username,
    String? avatarUrl,
  }) = _AuthSession;
}
