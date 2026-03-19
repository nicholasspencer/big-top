import 'package:flutter/foundation.dart';
import 'package:state_notifier/state_notifier.dart';

import '../services/github_auth_service.dart';

@immutable
class AuthState {
  final bool isLoading;
  final String? token;
  final String? username;
  final String? avatarUrl;
  final String? error;

  const AuthState({
    this.isLoading = false,
    this.token,
    this.username,
    this.avatarUrl,
    this.error,
  });

  bool get isAuthenticated => token != null;

  AuthState copyWith({
    bool? isLoading,
    String? token,
    String? username,
    String? avatarUrl,
    String? error,
    bool clearToken = false,
    bool clearError = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      token: clearToken ? null : (token ?? this.token),
      username: clearToken ? null : (username ?? this.username),
      avatarUrl: clearToken ? null : (avatarUrl ?? this.avatarUrl),
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class AuthProvider extends StateNotifier<AuthState> {
  final GitHubAuthService _authService;

  AuthProvider({GitHubAuthService? authService})
      : _authService = authService ?? GitHubAuthService(),
        super(const AuthState());

  bool get isAuthenticated => state.isAuthenticated;

  Future<void> tryRestoreSession() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final token = await _authService.getSavedToken();
      if (token != null) {
        final user = await _authService.fetchUser(token);
        if (user != null) {
          state = state.copyWith(
            isLoading: false,
            token: token,
            username: user['login'] as String?,
            avatarUrl: user['avatar_url'] as String?,
          );
          return;
        }
        // Token is invalid, clear it
        await _authService.clearToken();
      }
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<DeviceCodeResponse> startDeviceFlow() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final deviceCode = await _authService.requestDeviceCode();
      state = state.copyWith(isLoading: false);
      return deviceCode;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  Future<bool> pollForToken(DeviceCodeResponse deviceCode) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final token = await _authService.pollForToken(deviceCode);
      if (token != null) {
        final user = await _authService.fetchUser(token);
        state = state.copyWith(
          isLoading: false,
          token: token,
          username: user?['login'] as String?,
          avatarUrl: user?['avatar_url'] as String?,
        );
        return true;
      }
      state = state.copyWith(
        isLoading: false,
        error: 'Authorization expired or denied',
      );
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.clearToken();
    state = const AuthState();
  }
}
