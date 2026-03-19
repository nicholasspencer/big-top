import 'package:flutter/foundation.dart';
import 'package:state_notifier/state_notifier.dart';

import '../models/issue.dart';
import '../services/github_api_service.dart';

enum IssuesStatus { initial, loading, loaded, error }

@immutable
class IssuesState {
  final IssuesStatus status;
  final List<Issue> issues;
  final String? error;

  const IssuesState({
    this.status = IssuesStatus.initial,
    this.issues = const [],
    this.error,
  });

  List<Issue> byStatus(String statusFilter) =>
      issues.where((i) => i.status == statusFilter).toList();

  IssuesState copyWith({
    IssuesStatus? status,
    List<Issue>? issues,
    String? error,
  }) {
    return IssuesState(
      status: status ?? this.status,
      issues: issues ?? this.issues,
      error: error ?? this.error,
    );
  }
}

class IssuesProvider extends StateNotifier<IssuesState> {
  final GitHubApiService _apiService;

  IssuesProvider({required GitHubApiService apiService})
      : _apiService = apiService,
        super(const IssuesState());

  Future<void> loadIssues({
    required String token,
    required String owner,
    required String repo,
    required String project,
  }) async {
    state = state.copyWith(status: IssuesStatus.loading);
    try {
      final issues = await _apiService.fetchIssues(
        token: token,
        owner: owner,
        repo: repo,
        project: project,
      );
      state = state.copyWith(status: IssuesStatus.loaded, issues: issues);
    } catch (e) {
      state = state.copyWith(status: IssuesStatus.error, error: e.toString());
    }
  }
}
