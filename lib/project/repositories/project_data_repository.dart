import 'package:http/http.dart' as http;
import 'package:state_notifier/state_notifier.dart';

import 'package:big_top/core/async_value.dart';
import '../models/project_data.dart';
import '../services/github_api_service.dart';

class ProjectDataRepository extends StateNotifier<AsyncValue<ProjectData>> {
  final GitHubApiService _apiService;
  final String _token;
  final int _maxRetries;

  ProjectDataRepository({
    required GitHubApiService apiService,
    required String token,
    int maxRetries = 3,
  })  : _apiService = apiService,
        _token = token,
        _maxRetries = maxRetries,
        super(const AsyncValue.none());

  /// Load all data for a project. Retry on transient failures.
  Future<void> loadProject({
    required String owner,
    required String repo,
    required String project,
  }) async {
    state = state.toActive(); // preserves previous data during refresh
    try {
      final data = await _fetchWithRetry(
        () => _apiService.fetchAllProjectData(
          token: _token,
          owner: owner,
          repo: repo,
          project: project,
        ),
      );
      state = AsyncValue.done(data: data);
    } catch (e, st) {
      state = AsyncValue.done(error: e, stackTrace: st, data: state.data);
    }
  }

  /// Retry with exponential backoff for transient errors.
  Future<T> _fetchWithRetry<T>(Future<T> Function() fn) async {
    for (var attempt = 0; attempt <= _maxRetries; attempt++) {
      try {
        return await fn();
      } on HttpException catch (e) {
        if (e.statusCode >= 500 && attempt < _maxRetries) {
          await Future<void>.delayed(
              Duration(milliseconds: 500 * (1 << attempt)));
          continue;
        }
        rethrow;
      } on http.ClientException {
        if (attempt >= _maxRetries) rethrow;
        await Future<void>.delayed(
            Duration(milliseconds: 500 * (1 << attempt)));
      }
    }
    throw StateError('Retry loop exited unexpectedly');
  }
}
