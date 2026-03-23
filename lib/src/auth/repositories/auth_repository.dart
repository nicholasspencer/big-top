import 'package:state_notifier/state_notifier.dart';

import 'package:big_top/src/core/async_value.dart';
import '../../core/logger.dart';
import '../models/auth_session.dart';
import '../services/github_auth_service.dart';

const _tag = 'AuthRepo';

class AuthRepository extends StateNotifier<AsyncValue<AuthSession>> {
  final GitHubAuthService _authService;

  AuthRepository({required GitHubAuthService authService})
      : _authService = authService,
        super(const AsyncValue.none());

  bool get isAuthenticated => state.hasData;

  Future<void> tryRestoreSession() async {
    Log.d(_tag, 'tryRestoreSession starting');
    state = state.toWaiting();
    try {
      final token = await _authService.getSavedToken();
      if (token != null) {
        Log.d(_tag, 'Found saved token, validating...');
        final user = await _authService.fetchUser(token);
        if (user != null) {
          Log.d(_tag, 'Session restored for ${user['login']}');
          state = AsyncValue.done(
            data: AuthSession(
              token: token,
              username: user['login'] as String?,
              avatarUrl: user['avatar_url'] as String?,
            ),
          );
          return;
        }
        Log.d(_tag, 'Saved token invalid, clearing');
        await _authService.clearToken();
      }
      Log.d(_tag, 'No valid session, state → none');
      state = const AsyncValue.none();
    } catch (e, st) {
      Log.e(_tag, 'tryRestoreSession failed', e);
      state = AsyncValue.done(error: e, stackTrace: st);
    }
  }

  Future<DeviceCodeResponse> startDeviceFlow() async {
    Log.d(_tag, 'startDeviceFlow: state → waiting');
    state = state.toWaiting();
    try {
      final deviceCode = await _authService.requestDeviceCode();
      Log.d(_tag, 'startDeviceFlow: got code ${deviceCode.userCode}, state → active');
      state = state.toActive();
      return deviceCode;
    } catch (e, st) {
      Log.e(_tag, 'startDeviceFlow failed', e);
      state = AsyncValue.done(error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<bool> pollForToken(DeviceCodeResponse deviceCode) async {
    Log.d(_tag, 'pollForToken: state → active');
    state = state.toActive();
    try {
      final token = await _authService.pollForToken(deviceCode);
      if (token != null) {
        Log.d(_tag, 'pollForToken: got token, fetching user');
        final user = await _authService.fetchUser(token);
        Log.d(_tag, 'pollForToken: authenticated as ${user?['login']}');
        state = AsyncValue.done(
          data: AuthSession(
            token: token,
            username: user?['login'] as String?,
            avatarUrl: user?['avatar_url'] as String?,
          ),
        );
        return true;
      }
      Log.d(_tag, 'pollForToken: expired/denied');
      state = AsyncValue.done(
        error: Exception('Authorization expired or denied'),
      );
      return false;
    } catch (e, st) {
      Log.e(_tag, 'pollForToken failed', e);
      state = AsyncValue.done(error: e, stackTrace: st);
      return false;
    }
  }

  Future<void> logout() async {
    Log.d(_tag, 'logout');
    await _authService.clearToken();
    state = const AsyncValue.none();
  }
}
