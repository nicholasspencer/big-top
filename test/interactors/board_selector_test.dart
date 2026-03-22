import 'dart:convert';

import 'package:big_top/board/interactors/board_selector.dart';

import 'package:big_top/project/repositories/project_data_repository.dart';
import 'package:big_top/project/services/github_api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

const _token = 'test-token';
const _owner = 'test-owner';
const _repo = 'test-repo';
const _project = 'my-project';

final _now = '2025-01-01T00:00:00.000Z';

List<Map<String, dynamic>> _makeIssues() => [
      {
        'id': 'i-1',
        'title': 'Open low',
        'status': 'open',
        'priority': 3,
        'created_at': _now,
        'updated_at': _now,
      },
      {
        'id': 'i-2',
        'title': 'Open high',
        'status': 'open',
        'priority': 1,
        'created_at': _now,
        'updated_at': _now,
      },
      {
        'id': 'i-3',
        'title': 'In progress',
        'status': 'in_progress',
        'priority': 2,
        'created_at': _now,
        'updated_at': _now,
      },
      {
        'id': 'i-4',
        'title': 'Blocked',
        'status': 'blocked',
        'priority': 0,
        'created_at': _now,
        'updated_at': _now,
      },
      {
        'id': 'i-5',
        'title': 'Closed',
        'status': 'closed',
        'priority': 4,
        'created_at': _now,
        'updated_at': _now,
      },
    ];

MockClient _multiIssueClient() {
  final issuesBody = _makeIssues().map(jsonEncode).join('\n');
  return MockClient((request) async {
    final path = request.url.path;
    if (path.contains('issues.jsonl')) {
      return http.Response('$issuesBody\n', 200);
    }
    // Return empty for other entity types.
    if (path.contains('.jsonl')) {
      return http.Response('', 200);
    }
    return http.Response('Not found', 404);
  });
}

void main() {
  group('BoardSelector', () {
    test('empty state when repo has no data', () {
      final service = GitHubApiService(client: _multiIssueClient());
      final repo = ProjectDataRepository(
        apiService: service,
        token: _token,
      );
      final selector = BoardSelector(dataRepo: repo);

      expect(selector.state, isA<BoardSelectorEmpty>());

      selector.dispose();
      repo.dispose();
    });

    test('produces 4 columns after repo loads data', () async {
      final service = GitHubApiService(client: _multiIssueClient());
      final repo = ProjectDataRepository(
        apiService: service,
        token: _token,
        maxRetries: 0,
      );
      final selector = BoardSelector(dataRepo: repo);

      await repo.loadProject(
        owner: _owner,
        repo: _repo,
        project: _project,
      );

      expect(selector.state, isA<BoardSelectorLoaded>());
      final loaded = selector.state as BoardSelectorLoaded;
      expect(loaded.columns, hasLength(4));
      expect(loaded.columns.map((c) => c.status).toList(),
          ['open', 'in_progress', 'blocked', 'closed']);
      expect(loaded.columns.map((c) => c.label).toList(),
          ['Open', 'In Progress', 'Blocked', 'Closed']);
      // Check issue counts per column.
      expect(loaded.columns[0].issues, hasLength(2)); // open
      expect(loaded.columns[1].issues, hasLength(1)); // in_progress
      expect(loaded.columns[2].issues, hasLength(1)); // blocked
      expect(loaded.columns[3].issues, hasLength(1)); // closed

      selector.dispose();
      repo.dispose();
    });

    test('issues sorted by priority within columns', () async {
      final service = GitHubApiService(client: _multiIssueClient());
      final repo = ProjectDataRepository(
        apiService: service,
        token: _token,
        maxRetries: 0,
      );
      final selector = BoardSelector(dataRepo: repo);

      await repo.loadProject(
        owner: _owner,
        repo: _repo,
        project: _project,
      );

      final loaded = selector.state as BoardSelectorLoaded;
      final openIssues = loaded.columns[0].issues;
      // priority 1 before priority 3
      expect(openIssues[0].id, 'i-2');
      expect(openIssues[1].id, 'i-1');

      selector.dispose();
      repo.dispose();
    });

    test('error state when repo has error without data', () async {
      final client = MockClient((_) async => http.Response('Bad', 400));
      final service = GitHubApiService(client: client);
      final repo = ProjectDataRepository(
        apiService: service,
        token: _token,
        maxRetries: 0,
      );
      final selector = BoardSelector(dataRepo: repo);

      await repo.loadProject(
        owner: _owner,
        repo: _repo,
        project: _project,
      );

      expect(selector.state, isA<BoardSelectorError>());

      selector.dispose();
      repo.dispose();
    });
  });
}
