import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:state_notifier/state_notifier.dart';

import '../repositories/auth_repository.dart';
import '../services/github_auth_service.dart';

part 'login_viewmodel.freezed.dart';

@freezed
sealed class LoginState with _$LoginState {
  const factory LoginState({
    @Default(false) bool isPolling,
    DeviceCodeResponse? deviceCode,
    String? error,
  }) = _LoginState;
}

class LoginViewModel extends StateNotifier<LoginState> {
  final AuthRepository _authRepo;

  LoginViewModel({required AuthRepository authRepo})
      : _authRepo = authRepo,
        super(const LoginState());

  Future<void> startLogin() async {
    state = const LoginState();
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
