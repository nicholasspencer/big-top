import 'package:big_top/src/core/async_value.dart';
import 'package:big_top/src/auth/repositories/auth_repository.dart';
import 'package:big_top/src/auth/services/github_auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

/// A fake GitHubAuthService for testing.
class FakeGitHubAuthService extends GitHubAuthService {
  String? savedToken;
  Map<String, dynamic>? userResponse;
  DeviceCodeResponse? deviceCodeResponse;
  String? pollResult;
  bool clearTokenCalled = false;

  FakeGitHubAuthService()
      : super(
            client:
                MockClient((_) async => http.Response('', 200)));

  @override
  Future<String?> getSavedToken() async => savedToken;

  @override
  Future<void> saveToken(String token) async {
    savedToken = token;
  }

  @override
  Future<void> clearToken() async {
    savedToken = null;
    clearTokenCalled = true;
  }

  @override
  Future<Map<String, dynamic>?> fetchUser(String token) async => userResponse;

  @override
  Future<DeviceCodeResponse> requestDeviceCode() async {
    if (deviceCodeResponse != null) return deviceCodeResponse!;
    throw Exception('No device code configured');
  }

  @override
  Future<String?> pollForToken(DeviceCodeResponse deviceCode) async =>
      pollResult;
}

void main() {
  group('AuthRepository', () {
    late FakeGitHubAuthService authService;
    late AuthRepository repo;

    setUp(() {
      authService = FakeGitHubAuthService();
      repo = AuthRepository(authService: authService);
    });

    tearDown(() {
      repo.dispose();
    });

    test('initial state is unauthenticated', () {
      expect(repo.isAuthenticated, isFalse);
      expect(repo.state, isA<AsyncValueNone>());
      expect(repo.state.data, isNull);
    });

    group('tryRestoreSession', () {
      test('restores session when saved token is valid', () async {
        authService.savedToken = 'valid-token';
        authService.userResponse = {
          'login': 'testuser',
          'avatar_url': 'https://example.com/avatar.png',
        };

        await repo.tryRestoreSession();

        expect(repo.isAuthenticated, isTrue);
        expect(repo.state.data?.token, 'valid-token');
        expect(repo.state.data?.username, 'testuser');
        expect(repo.state.data?.avatarUrl, 'https://example.com/avatar.png');
        expect(repo.state, isA<AsyncValueDone>());
      });

      test('clears invalid token', () async {
        authService.savedToken = 'invalid-token';
        authService.userResponse = null; // fetchUser returns null

        await repo.tryRestoreSession();

        expect(repo.isAuthenticated, isFalse);
        expect(repo.state, isA<AsyncValueNone>());
        expect(authService.clearTokenCalled, isTrue);
      });

      test('stays unauthenticated when no saved token', () async {
        authService.savedToken = null;

        await repo.tryRestoreSession();

        expect(repo.isAuthenticated, isFalse);
        expect(repo.state, isA<AsyncValueNone>());
      });
    });

    group('startDeviceFlow', () {
      test('returns device code on success', () async {
        final deviceCode = DeviceCodeResponse(
          deviceCode: 'dc-123',
          userCode: 'ABCD-1234',
          verificationUri: 'https://github.com/login/device',
          expiresIn: 900,
          interval: 5,
        );
        authService.deviceCodeResponse = deviceCode;

        final result = await repo.startDeviceFlow();

        expect(result.userCode, 'ABCD-1234');
        expect(repo.state, isA<AsyncValueActive>());
        expect(repo.state.hasError, isFalse);
      });

      test('sets error on failure', () async {
        authService.deviceCodeResponse = null;

        expect(
          () => repo.startDeviceFlow(),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('pollForToken', () {
      final deviceCode = DeviceCodeResponse(
        deviceCode: 'dc-123',
        userCode: 'ABCD-1234',
        verificationUri: 'https://github.com/login/device',
        expiresIn: 900,
        interval: 5,
      );

      test('authenticates on successful poll', () async {
        authService.pollResult = 'new-token';
        authService.userResponse = {
          'login': 'testuser',
          'avatar_url': 'https://example.com/avatar.png',
        };

        final success = await repo.pollForToken(deviceCode);

        expect(success, isTrue);
        expect(repo.isAuthenticated, isTrue);
        expect(repo.state.data?.token, 'new-token');
        expect(repo.state.data?.username, 'testuser');
      });

      test('sets error when poll returns null', () async {
        authService.pollResult = null;

        final success = await repo.pollForToken(deviceCode);

        expect(success, isFalse);
        expect(repo.isAuthenticated, isFalse);
        expect(repo.state.error.toString(),
            'Exception: Authorization expired or denied');
      });
    });

    group('logout', () {
      test('clears auth state and token', () async {
        // First authenticate
        authService.savedToken = 'token';
        authService.userResponse = {'login': 'user', 'avatar_url': ''};
        await repo.tryRestoreSession();
        expect(repo.isAuthenticated, isTrue);

        // Then logout
        await repo.logout();

        expect(repo.isAuthenticated, isFalse);
        expect(repo.state.data, isNull);
        expect(authService.clearTokenCalled, isTrue);
      });
    });
  });
}
