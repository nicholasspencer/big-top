import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/logger.dart';

const _tag = 'AuthService';

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
    final token = prefs.getString(_tokenKey);
    Log.d(_tag, 'getSavedToken: ${token != null ? "found" : "null"}');
    return token;
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    Log.d(_tag, 'Token saved');
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    Log.d(_tag, 'Token cleared');
  }

  /// Step 1: Request a device code from GitHub.
  Future<DeviceCodeResponse> requestDeviceCode() async {
    final url = '$proxyUrl/github/device/code';
    Log.d(_tag, 'requestDeviceCode → POST $url');

    final http.Response response;
    try {
      response = await _client.post(
        Uri.parse(url),
        headers: {'Accept': 'application/json'},
        body: {
          'client_id': clientId,
          'scope': _scope,
        },
      ).timeout(_requestTimeout);
    } on TimeoutException {
      Log.e(_tag, 'requestDeviceCode TIMEOUT after ${_requestTimeout.inSeconds}s');
      throw Exception(
        'Request timed out. The auth proxy may be unreachable.',
      );
    } catch (e) {
      Log.e(_tag, 'requestDeviceCode FAILED', e);
      rethrow;
    }

    Log.d(_tag, 'requestDeviceCode ← ${response.statusCode} (${response.body.length} bytes)');

    if (response.statusCode != 200) {
      Log.e(_tag, 'requestDeviceCode bad status: ${response.statusCode} ${response.body}');
      throw Exception('Failed to request device code: ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    Log.d(_tag, 'Device code: ${json['user_code']}, interval: ${json['interval']}');

    return DeviceCodeResponse(
      deviceCode: json['device_code'] as String,
      userCode: json['user_code'] as String,
      verificationUri: json['verification_uri'] as String,
      expiresIn: json['expires_in'] as int,
      interval: json['interval'] as int,
    );
  }

  /// Step 2: Poll for the access token after user authorizes.
  Future<String?> pollForToken(DeviceCodeResponse deviceCode) async {
    final deadline =
        DateTime.now().add(Duration(seconds: deviceCode.expiresIn));
    final interval = Duration(seconds: deviceCode.interval);
    var attempt = 0;

    Log.d(_tag, 'pollForToken starting (expires in ${deviceCode.expiresIn}s)');

    while (DateTime.now().isBefore(deadline)) {
      await Future<void>.delayed(interval);
      attempt++;

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
        Log.d(_tag, 'pollForToken attempt #$attempt: timeout, retrying');
        continue;
      } catch (e) {
        Log.d(_tag, 'pollForToken attempt #$attempt: error ($e), retrying');
        continue;
      }

      if (response.statusCode != 200) {
        Log.d(_tag, 'pollForToken attempt #$attempt: status ${response.statusCode}');
        continue;
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final error = json['error'] as String?;

      if (error == null) {
        final token = json['access_token'] as String;
        Log.d(_tag, 'pollForToken attempt #$attempt: GOT TOKEN');
        await saveToken(token);
        return token;
      }

      Log.d(_tag, 'pollForToken attempt #$attempt: $error');

      if (error == 'expired_token' || error == 'access_denied') {
        return null;
      }

      // 'authorization_pending' or 'slow_down' — keep polling
      if (error == 'slow_down') {
        await Future<void>.delayed(const Duration(seconds: 5));
      }
    }

    Log.d(_tag, 'pollForToken: expired after $attempt attempts');
    return null;
  }

  /// Fetch the authenticated user's info.
  Future<Map<String, dynamic>?> fetchUser(String token) async {
    Log.d(_tag, 'fetchUser → GET api.github.com/user');
    final response = await _client.get(
      Uri.parse('https://api.github.com/user'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/vnd.github+json',
      },
    ).timeout(_requestTimeout);

    Log.d(_tag, 'fetchUser ← ${response.statusCode}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    return null;
  }
}
