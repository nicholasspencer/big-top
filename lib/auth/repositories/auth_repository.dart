import 'package:state_notifier/state_notifier.dart';

import 'package:big_top/core/async_value.dart';
import '../models/auth_session.dart';
import '../services/github_auth_service.dart';

class AuthRepository extends StateNotifier<AsyncValue<AuthSession>> {
  final GitHubAuthService _authService;

  AuthRepository({required GitHubAuthService authService})
      : _authService = authService,
        super(const AsyncValue.none());

  bool get isAuthenticated => state.hasData;

  Future<void> tryRestoreSession() async {
    state = state.toWaiting();
    try {
      final token = await _authService.getSavedToken();
      if (token != null) {
        final user = await _authService.fetchUser(token);
        if (user != null) {
          state = AsyncValue.done(
            data: AuthSession(
              token: token,
              username: user['login'] as String?,
              avatarUrl: user['avatar_url'] as String?,
            ),
          );
          return;
        }
        await _authService.clearToken();
      }
      state = const AsyncValue.none();
    } catch (e, st) {
      state = AsyncValue.done(error: e, stackTrace: st);
    }
  }

  Future<DeviceCodeResponse> startDeviceFlow() async {
    state = state.toWaiting();
    try {
      final deviceCode = await _authService.requestDeviceCode();
      state = state.toActive();
      return deviceCode;
    } catch (e, st) {
      state = AsyncValue.done(error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<bool> pollForToken(DeviceCodeResponse deviceCode) async {
    state = state.toActive();
    try {
      final token = await _authService.pollForToken(deviceCode);
      if (token != null) {
        final user = await _authService.fetchUser(token);
        state = AsyncValue.done(
          data: AuthSession(
            token: token,
            username: user?['login'] as String?,
            avatarUrl: user?['avatar_url'] as String?,
          ),
        );
        return true;
      }
      state = AsyncValue.done(
        error: Exception('Authorization expired or denied'),
      );
      return false;
    } catch (e, st) {
      state = AsyncValue.done(error: e, stackTrace: st);
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.clearToken();
    state = const AsyncValue.none();
  }
}
