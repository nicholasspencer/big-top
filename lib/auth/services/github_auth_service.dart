import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DeviceCodeResponse {
  final String deviceCode;
  final String userCode;
  final String verificationUri;
  final int expiresIn;
  final int interval;

  const DeviceCodeResponse({
    required this.deviceCode,
    required this.userCode,
    required this.verificationUri,
    required this.expiresIn,
    required this.interval,
  });
}

class GitHubAuthService {
  static const String clientId = 'Ov23lif92fsHavSHF02v';
  static const String _tokenKey = 'github_access_token';
  static const String _scope = 'repo';

  /// CORS proxy URL for GitHub OAuth endpoints (device flow).
  /// Set via --dart-define=PROXY_URL=... at build time.
  /// Falls back to localhost for local dev.
  static const String proxyUrl = String.fromEnvironment(
    'PROXY_URL',
    defaultValue: 'http://localhost:8787',
  );

  /// Request timeout for auth endpoints.
  static const _requestTimeout = Duration(seconds: 15);

  final http.Client _client;

  GitHubAuthService({http.Client? client}) : _client = client ?? http.Client();

  Future<String?> getSavedToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  /// Step 1: Request a device code from GitHub.
  Future<DeviceCodeResponse> requestDeviceCode() async {
    final http.Response response;
    try {
      response = await _client.post(
        Uri.parse('$proxyUrl/github/device/code'),
        headers: {'Accept': 'application/json'},
        body: {
          'client_id': clientId,
          'scope': _scope,
        },
      ).timeout(_requestTimeout);
    } on TimeoutException {
      throw Exception(
        'Request timed out. The auth proxy may be unreachable.',
      );
    }

    if (response.statusCode != 200) {
      throw Exception('Failed to request device code: ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return DeviceCodeResponse(
      deviceCode: json['device_code'] as String,
      userCode: json['user_code'] as String,
      verificationUri: json['verification_uri'] as String,
      expiresIn: json['expires_in'] as int,
      interval: json['interval'] as int,
    );
  }

  /// Step 2: Poll for the access token after user authorizes.
  /// Returns the access token when the user completes authorization,
  /// or null if the device code expires.
  Future<String?> pollForToken(DeviceCodeResponse deviceCode) async {
    final deadline =
        DateTime.now().add(Duration(seconds: deviceCode.expiresIn));
    final interval = Duration(seconds: deviceCode.interval);

    while (DateTime.now().isBefore(deadline)) {
      await Future<void>.delayed(interval);

      final http.Response response;
      try {
        response = await _client.post(
          Uri.parse('$proxyUrl/github/oauth/token'),
          headers: {'Accept': 'application/json'},
          body: {
            'client_id': clientId,
            'device_code': deviceCode.deviceCode,
            'grant_type': 'urn:ietf:params:oauth:grant-type:device_code',
          },
        ).timeout(_requestTimeout);
      } on TimeoutException {
        continue; // retry on timeout during polling
      } catch (_) {
        continue; // retry on network errors during polling
      }

      if (response.statusCode != 200) continue;

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final error = json['error'] as String?;

      if (error == null) {
        final token = json['access_token'] as String;
        await saveToken(token);
        return token;
      }

      if (error == 'expired_token' || error == 'access_denied') {
        return null;
      }

      // 'authorization_pending' or 'slow_down' — keep polling
      if (error == 'slow_down') {
        await Future<void>.delayed(const Duration(seconds: 5));
      }
    }

    return null;
  }

  /// Fetch the authenticated user's info.
  Future<Map<String, dynamic>?> fetchUser(String token) async {
    final response = await _client.get(
      Uri.parse('https://api.github.com/user'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/vnd.github+json',
      },
    ).timeout(_requestTimeout);

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    return null;
  }
}
