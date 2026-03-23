import 'dart:convert';

import 'package:big_top/board/interactors/board_selector.dart';
import 'package:big_top/board/interactors/filter_interactor.dart';
import 'package:big_top/core/async_value.dart';

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
        'assignee': 'alice',
        'created_at': _now,
        'updated_at': _now,
      },
      {
        'id': 'i-2',
        'title': 'Open high',
        'status': 'open',
        'priority': 1,
        'assignee': 'bob',
        'created_at': _now,
        'updated_at': _now,
      },
      {
        'id': 'i-3',
        'title': 'In progress',
        'status': 'in_progress',
        'priority': 2,
        'assignee': 'alice',
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

List<Map<String, dynamic>> _makeLabels() => [
      {'issue_id': 'i-1', 'label': 'bug'},
      {'issue_id': 'i-1', 'label': 'frontend'},
      {'issue_id': 'i-2', 'label': 'feature'},
      {'issue_id': 'i-3', 'label': 'bug'},
    ];

MockClient _multiIssueClient({bool withLabels = false}) {
  final issuesBody = _makeIssues().map(jsonEncode).join('\n');
  final labelsBody = withLabels ? _makeLabels().map(jsonEncode).join('\n') : '';
  return MockClient((request) async {
    final path = request.url.path;
    if (path.contains('issues.jsonl')) {
      return http.Response('$issuesBody\n', 200);
    }
    if (path.contains('labels.jsonl')) {
      return http.Response(withLabels ? '$labelsBody\n' : '', 200);
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
    test('none state when repo has no data', () {
      final service = GitHubApiService(client: _multiIssueClient());
      final repo = ProjectDataRepository(
        apiService: service,
        token: _token,
      );
      final selector = BoardSelector(dataRepo: repo);

      expect(selector.state, isA<AsyncValueNone>());
      expect(selector.state.hasData, isFalse);

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

      expect(selector.state.hasData, isTrue);
      final columns = selector.state.data!;
      expect(columns, hasLength(4));
      expect(columns.map((c) => c.status).toList(),
          ['open', 'in_progress', 'blocked', 'closed']);
      expect(columns.map((c) => c.label).toList(),
          ['Open', 'In Progress', 'Blocked', 'Closed']);
      // Check issue counts per column.
      expect(columns[0].issues, hasLength(2)); // open
      expect(columns[1].issues, hasLength(1)); // in_progress
      expect(columns[2].issues, hasLength(1)); // blocked
      expect(columns[3].issues, hasLength(1)); // closed

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

      final columns = selector.state.data!;
      final openIssues = columns[0].issues;
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

      expect(selector.state.hasError, isTrue);

      selector.dispose();
      repo.dispose();
    });

    test('denormalizes labels from ProjectData onto issues', () async {
      final service =
          GitHubApiService(client: _multiIssueClient(withLabels: true));
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

      final columns = selector.state.data!;
      // i-1 has labels [bug, frontend], i-2 has [feature]
      final openIssues = columns[0].issues;
      // sorted by priority: i-2 (p1) first, i-1 (p3) second
      expect(openIssues[0].id, 'i-2');
      expect(openIssues[0].labels, ['feature']);
      expect(openIssues[1].id, 'i-1');
      expect(openIssues[1].labels, containsAll(['bug', 'frontend']));

      // i-3 has label [bug]
      final inProgressIssues = columns[1].issues;
      expect(inProgressIssues[0].labels, ['bug']);

      // i-4 has no labels
      final blockedIssues = columns[2].issues;
      expect(blockedIssues[0].labels, isEmpty);

      selector.dispose();
      repo.dispose();
    });
  });

  group('BoardSelector with filters', () {
    test('filters by label', () async {
      final service =
          GitHubApiService(client: _multiIssueClient(withLabels: true));
      final repo = ProjectDataRepository(
        apiService: service,
        token: _token,
        maxRetries: 0,
      );
      final filter = FilterInteractor();
      final selector = BoardSelector(dataRepo: repo, filterInteractor: filter);

      await repo.loadProject(
        owner: _owner,
        repo: _repo,
        project: _project,
      );

      // Before filter: open has 2 issues, in_progress has 1
      expect(selector.state.data![0].issues, hasLength(2));

      // Filter to only 'bug' — i-1 (open, bug+frontend) and i-3 (in_progress, bug)
      filter.toggleLabel('bug');

      final columns = selector.state.data!;
      expect(columns[0].issues, hasLength(1)); // only i-1
      expect(columns[0].issues[0].id, 'i-1');
      expect(columns[1].issues, hasLength(1)); // i-3
      expect(columns[1].issues[0].id, 'i-3');
      expect(columns[2].issues, hasLength(0)); // i-4 has no labels
      expect(columns[3].issues, hasLength(0)); // i-5 has no labels

      selector.dispose();
      filter.dispose();
      repo.dispose();
    });

    test('filters by priority', () async {
      final service =
          GitHubApiService(client: _multiIssueClient(withLabels: true));
      final repo = ProjectDataRepository(
        apiService: service,
        token: _token,
        maxRetries: 0,
      );
      final filter = FilterInteractor();
      final selector = BoardSelector(dataRepo: repo, filterInteractor: filter);

      await repo.loadProject(
        owner: _owner,
        repo: _repo,
        project: _project,
      );

      filter.togglePriority(0); // Only critical — i-4 (blocked)

      final columns = selector.state.data!;
      expect(columns[0].issues, hasLength(0));
      expect(columns[1].issues, hasLength(0));
      expect(columns[2].issues, hasLength(1));
      expect(columns[2].issues[0].id, 'i-4');
      expect(columns[3].issues, hasLength(0));

      selector.dispose();
      filter.dispose();
      repo.dispose();
    });

    test('filters by assignee', () async {
      final service =
          GitHubApiService(client: _multiIssueClient(withLabels: true));
      final repo = ProjectDataRepository(
        apiService: service,
        token: _token,
        maxRetries: 0,
      );
      final filter = FilterInteractor();
      final selector = BoardSelector(dataRepo: repo, filterInteractor: filter);

      await repo.loadProject(
        owner: _owner,
        repo: _repo,
        project: _project,
      );

      filter.toggleAssignee('alice'); // i-1 (open) and i-3 (in_progress)

      final columns = selector.state.data!;
      expect(columns[0].issues, hasLength(1));
      expect(columns[0].issues[0].id, 'i-1');
      expect(columns[1].issues, hasLength(1));
      expect(columns[1].issues[0].id, 'i-3');
      expect(columns[2].issues, hasLength(0));
      expect(columns[3].issues, hasLength(0));

      selector.dispose();
      filter.dispose();
      repo.dispose();
    });

    test('composes multiple filters with AND logic', () async {
      final service =
          GitHubApiService(client: _multiIssueClient(withLabels: true));
      final repo = ProjectDataRepository(
        apiService: service,
        token: _token,
        maxRetries: 0,
      );
      final filter = FilterInteractor();
      final selector = BoardSelector(dataRepo: repo, filterInteractor: filter);

      await repo.loadProject(
        owner: _owner,
        repo: _repo,
        project: _project,
      );

      // Filter: label=bug AND assignee=alice — only i-1 and i-3 have bug,
      // and both are assigned to alice, so both match
      filter.toggleLabel('bug');
      filter.toggleAssignee('alice');

      final columns = selector.state.data!;
      expect(columns[0].issues, hasLength(1)); // i-1
      expect(columns[0].issues[0].id, 'i-1');
      expect(columns[1].issues, hasLength(1)); // i-3
      expect(columns[1].issues[0].id, 'i-3');
      expect(columns[2].issues, hasLength(0));
      expect(columns[3].issues, hasLength(0));

      selector.dispose();
      filter.dispose();
      repo.dispose();
    });

    test('clearing filters restores full board', () async {
      final service =
          GitHubApiService(client: _multiIssueClient(withLabels: true));
      final repo = ProjectDataRepository(
        apiService: service,
        token: _token,
        maxRetries: 0,
      );
      final filter = FilterInteractor();
      final selector = BoardSelector(dataRepo: repo, filterInteractor: filter);

      await repo.loadProject(
        owner: _owner,
        repo: _repo,
        project: _project,
      );

      filter.toggleLabel('bug');
      expect(selector.state.data![0].issues, hasLength(1));

      filter.clearAll();
      expect(selector.state.data![0].issues, hasLength(2)); // restored

      selector.dispose();
      filter.dispose();
      repo.dispose();
    });
  });
}
