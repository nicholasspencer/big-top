import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/issue.dart';

class GitHubApiService {
  final http.Client _client;

  GitHubApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Fetch issues JSONL from a repository's beads export.
  /// Expects a file at `.beads/export/issues.jsonl` in the repo default branch.
  Future<List<Issue>> fetchIssues({
    required String token,
    String owner = '',
    String repo = '',
  }) async {
    if (owner.isEmpty || repo.isEmpty) return [];

    final url =
        'https://api.github.com/repos/$owner/$repo/contents/.beads/export/issues.jsonl';
    final response = await _client.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/vnd.github.raw+json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch issues: ${response.statusCode}');
    }

    final lines = const LineSplitter().convert(response.body);
    return lines
        .where((line) => line.trim().isNotEmpty)
        .map((line) => Issue.fromJson(jsonDecode(line) as Map<String, dynamic>))
        .toList();
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
