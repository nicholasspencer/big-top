import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/comment.dart';
import '../models/dependency.dart';
import '../models/event.dart';
import '../models/issue.dart';
import '../models/label.dart';

/// Exception thrown when the GitHub API returns a 404.
class GitHubNotFoundException implements Exception {
  final String path;
  const GitHubNotFoundException(this.path);

  @override
  String toString() => 'GitHub resource not found: $path';
}

/// Exception thrown when the GitHub API rate limit is exceeded.
class GitHubRateLimitException implements Exception {
  final DateTime resetAt;
  const GitHubRateLimitException(this.resetAt);

  @override
  String toString() =>
      'GitHub API rate limit exceeded. Resets at $resetAt';
}

/// All entity data for a single beads project.
class ProjectData {
  final List<Issue> issues;
  final List<Comment> comments;
  final List<Label> labels;
  final List<Dependency> dependencies;
  final List<Event> events;

  const ProjectData({
    this.issues = const [],
    this.comments = const [],
    this.labels = const [],
    this.dependencies = const [],
    this.events = const [],
  });
}

class GitHubApiService {
  final http.Client _client;
  final int _maxRetries;

  GitHubApiService({http.Client? client, int maxRetries = 3})
      : _client = client ?? http.Client(),
        _maxRetries = maxRetries;

  Map<String, String> _headers(String token) => {
        'Authorization': 'Bearer $token',
        'Accept': 'application/vnd.github.raw+json',
      };

  /// Build the Contents API URL for a file in a repo.
  String _contentsUrl(String owner, String repo, String path) =>
      'https://api.github.com/repos/$owner/$repo/contents/$path';

  /// Perform a GET request with retry and exponential backoff.
  Future<http.Response> _getWithRetry(Uri uri, Map<String, String> headers) async {
    for (var attempt = 0; attempt <= _maxRetries; attempt++) {
      try {
        final response = await _client.get(uri, headers: headers);

        // Check rate limiting.
        final remaining = response.headers['x-ratelimit-remaining'];
        if (remaining != null && int.parse(remaining) == 0) {
          final resetEpoch =
              int.parse(response.headers['x-ratelimit-reset'] ?? '0');
          throw GitHubRateLimitException(
            DateTime.fromMillisecondsSinceEpoch(resetEpoch * 1000),
          );
        }

        // Retry on server errors (5xx).
        if (response.statusCode >= 500 && attempt < _maxRetries) {
          await Future<void>.delayed(
            Duration(milliseconds: 500 * (1 << attempt)),
          );
          continue;
        }

        return response;
      } on http.ClientException {
        if (attempt >= _maxRetries) rethrow;
        await Future<void>.delayed(
          Duration(milliseconds: 500 * (1 << attempt)),
        );
      }
    }
    // Unreachable, but satisfies the analyzer.
    throw StateError('Retry loop exited unexpectedly');
  }

  /// Handle non-200 responses with typed exceptions.
  void _checkResponse(http.Response response, String path) {
    if (response.statusCode == 200) return;
    if (response.statusCode == 404) {
      throw GitHubNotFoundException(path);
    }
    throw Exception(
      'GitHub API error ${response.statusCode} for $path',
    );
  }

  /// Generic JSONL fetcher: downloads a file and parses each line with [fromJson].
  Future<List<T>> _fetchJsonl<T>({
    required String token,
    required String owner,
    required String repo,
    required String path,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final url = _contentsUrl(owner, repo, path);
    final response =
        await _getWithRetry(Uri.parse(url), _headers(token));
    _checkResponse(response, path);

    final lines = const LineSplitter().convert(response.body);
    return lines
        .where((line) => line.trim().isNotEmpty)
        .map((line) => fromJson(jsonDecode(line) as Map<String, dynamic>))
        .toList();
  }

  /// Fetch issues JSONL from a beads-tracking repository.
  Future<List<Issue>> fetchIssues({
    required String token,
    required String owner,
    required String repo,
    required String project,
  }) {
    return _fetchJsonl(
      token: token,
      owner: owner,
      repo: repo,
      path: 'data/$project/issues.jsonl',
      fromJson: Issue.fromJson,
    );
  }

  /// Fetch comments JSONL.
  Future<List<Comment>> fetchComments({
    required String token,
    required String owner,
    required String repo,
    required String project,
  }) {
    return _fetchJsonl(
      token: token,
      owner: owner,
      repo: repo,
      path: 'data/$project/comments.jsonl',
      fromJson: Comment.fromJson,
    );
  }

  /// Fetch labels JSONL.
  Future<List<Label>> fetchLabels({
    required String token,
    required String owner,
    required String repo,
    required String project,
  }) {
    return _fetchJsonl(
      token: token,
      owner: owner,
      repo: repo,
      path: 'data/$project/labels.jsonl',
      fromJson: Label.fromJson,
    );
  }

  /// Fetch dependencies JSONL.
  Future<List<Dependency>> fetchDependencies({
    required String token,
    required String owner,
    required String repo,
    required String project,
  }) {
    return _fetchJsonl(
      token: token,
      owner: owner,
      repo: repo,
      path: 'data/$project/dependencies.jsonl',
      fromJson: Dependency.fromJson,
    );
  }

  /// Fetch events JSONL.
  Future<List<Event>> fetchEvents({
    required String token,
    required String owner,
    required String repo,
    required String project,
  }) {
    return _fetchJsonl(
      token: token,
      owner: owner,
      repo: repo,
      path: 'data/$project/events.jsonl',
      fromJson: Event.fromJson,
    );
  }

  /// Fetch the manifest.json that lists available projects.
  Future<Map<String, dynamic>> fetchManifest({
    required String token,
    required String owner,
    required String repo,
  }) async {
    final path = 'data/manifest.json';
    final url = _contentsUrl(owner, repo, path);
    final response =
        await _getWithRetry(Uri.parse(url), _headers(token));
    _checkResponse(response, path);

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  /// Load all entity types for a project in parallel.
  Future<ProjectData> fetchAllProjectData({
    required String token,
    required String owner,
    required String repo,
    required String project,
  }) async {
    final results = await Future.wait([
      fetchIssues(
          token: token, owner: owner, repo: repo, project: project),
      fetchComments(
          token: token, owner: owner, repo: repo, project: project),
      fetchLabels(
          token: token, owner: owner, repo: repo, project: project),
      fetchDependencies(
          token: token, owner: owner, repo: repo, project: project),
      fetchEvents(
          token: token, owner: owner, repo: repo, project: project),
    ]);

    return ProjectData(
      issues: results[0] as List<Issue>,
      comments: results[1] as List<Comment>,
      labels: results[2] as List<Label>,
      dependencies: results[3] as List<Dependency>,
      events: results[4] as List<Event>,
    );
  }

  /// Trigger a GitHub Actions workflow dispatch.
  Future<void> triggerWorkflowDispatch({
    required String token,
    required String owner,
    required String repo,
    required String workflowId,
    String ref = 'main',
    Map<String, dynamic>? inputs,
  }) async {
    final url =
        'https://api.github.com/repos/$owner/$repo/actions/workflows/$workflowId/dispatches';
    final body = <String, dynamic>{'ref': ref};
    if (inputs != null) body['inputs'] = inputs;

    final response = await _client.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/vnd.github+json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode != 204) {
      throw Exception(
          'Failed to trigger workflow dispatch: ${response.statusCode}');
    }
  }
}
