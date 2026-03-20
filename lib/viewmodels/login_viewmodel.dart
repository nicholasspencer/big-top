import 'package:flutter/foundation.dart';
import 'package:state_notifier/state_notifier.dart';

import '../repositories/auth_repository.dart';
import '../services/github_auth_service.dart';

@immutable
class LoginState {
  final bool isPolling;
  final DeviceCodeResponse? deviceCode;
  final String? error;

  const LoginState({this.isPolling = false, this.deviceCode, this.error});

  LoginState copyWith({
    bool? isPolling,
    DeviceCodeResponse? deviceCode,
    String? error,
    bool clearDeviceCode = false,
    bool clearError = false,
  }) {
    return LoginState(
      isPolling: isPolling ?? this.isPolling,
      deviceCode: clearDeviceCode ? null : (deviceCode ?? this.deviceCode),
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class LoginViewModel extends StateNotifier<LoginState> {
  final AuthRepository _authRepo;

  LoginViewModel({required AuthRepository authRepo})
      : _authRepo = authRepo,
        super(const LoginState());

  Future<void> startLogin() async {
    state = state.copyWith(clearError: true, clearDeviceCode: true);
    try {
      final deviceCode = await _authRepo.startDeviceFlow();
      state = state.copyWith(deviceCode: deviceCode);

      // Start polling
      state = state.copyWith(isPolling: true);
      await _authRepo.pollForToken(deviceCode);
      if (mounted) {
        state = state.copyWith(isPolling: false);
      }
    } catch (e) {
      if (mounted) {
        state = state.copyWith(isPolling: false, error: e.toString());
      }
    }
  }

  void cancelLogin() {
    state = const LoginState();
  }
}
