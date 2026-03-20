import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:state_notifier/state_notifier.dart';

import '../models/comment.dart';
import '../models/dependency.dart';
import '../models/issue.dart';
import '../models/label.dart';
import '../services/github_api_service.dart';

enum IssuesStatus { initial, loading, loaded, error }

@immutable
class IssuesState {
  final IssuesStatus status;
  final List<Issue> issues;
  final List<Comment> comments;
  final List<Label> labels;
  final List<Dependency> dependencies;
  final String? error;

  const IssuesState({
    this.status = IssuesStatus.initial,
    this.issues = const [],
    this.comments = const [],
    this.labels = const [],
    this.dependencies = const [],
    this.error,
  });

  List<Issue> byStatus(String statusFilter) =>
      issues.where((i) => i.status == statusFilter).toList();

  IssuesState copyWith({
    IssuesStatus? status,
    List<Issue>? issues,
    List<Comment>? comments,
    List<Label>? labels,
    List<Dependency>? dependencies,
    String? error,
  }) {
    return IssuesState(
      status: status ?? this.status,
      issues: issues ?? this.issues,
      comments: comments ?? this.comments,
      labels: labels ?? this.labels,
      dependencies: dependencies ?? this.dependencies,
      error: error ?? this.error,
    );
  }
}

class IssuesRepository extends StateNotifier<IssuesState> {
  final GitHubApiService _apiService;
  final String _token;
  final int _maxRetries;

  IssuesRepository({
    required GitHubApiService apiService,
    required String token,
    int maxRetries = 3,
  })  : _apiService = apiService,
        _token = token,
        _maxRetries = maxRetries,
        super(const IssuesState());

  /// Load all data for a project. Retry on transient failures.
  Future<void> loadProject({
    required String owner,
    required String repo,
    required String project,
  }) async {
    state = state.copyWith(status: IssuesStatus.loading);
    try {
      final data = await _fetchWithRetry(
        () => _apiService.fetchAllProjectData(
          token: _token,
          owner: owner,
          repo: repo,
          project: project,
        ),
      );
      state = state.copyWith(
        status: IssuesStatus.loaded,
        issues: data.issues,
        comments: data.comments,
        labels: data.labels,
        dependencies: data.dependencies,
      );
    } catch (e) {
      state = state.copyWith(status: IssuesStatus.error, error: e.toString());
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
