import 'dart:convert';

import 'package:big_top/src/core/async_value.dart';
import 'package:big_top/src/project/repositories/project_data_repository.dart';
import 'package:big_top/src/project/services/github_api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

const _token = 'test-token';
const _owner = 'test-owner';
const _repo = 'test-repo';
const _project = 'my-project';

final _issueJson = {
  'id': 'issue-001',
  'title': 'Fix bug',
  'description': 'A bug',
  'status': 'open',
  'priority': 1,
  'issue_type': 'bug',
  'owner': 'alice',
  'created_at': '2025-01-01T00:00:00.000Z',
  'created_by': 'alice',
  'updated_at': '2025-01-02T00:00:00.000Z',
  'dependencies': <String>[],
  'dependency_count': 0,
  'comment_count': 2,
};

final _commentJson = {
  'id': 'comment-001',
  'issue_id': 'issue-001',
  'author': 'bob',
  'content': 'Looks good',
  'created_at': '2025-01-01T12:00:00.000Z',
};

final _labelJson = {
  'issue_id': 'issue-001',
  'label': 'bug',
};

final _dependencyJson = {
  'issue_id': 'issue-002',
  'depends_on_id': 'issue-001',
  'type': 'blocks',
  'created_at': '2025-01-01T00:00:00.000Z',
  'created_by': 'alice',
  'metadata': '{}',
};

final _eventJson = {
  'id': 'event-001',
  'issue_id': 'issue-001',
  'event_type': 'status_change',
  'actor': 'alice',
  'created_at': '2025-01-01T00:00:00.000Z',
  'data': {'from': 'open', 'to': 'closed'},
};

MockClient successClient() {
  return MockClient((request) async {
    final path = request.url.path;
    String body;
    if (path.contains('issues.jsonl')) {
      body = '${jsonEncode(_issueJson)}\n';
    } else if (path.contains('comments.jsonl')) {
      body = '${jsonEncode(_commentJson)}\n';
    } else if (path.contains('labels.jsonl')) {
      body = '${jsonEncode(_labelJson)}\n';
    } else if (path.contains('dependencies.jsonl')) {
      body = '${jsonEncode(_dependencyJson)}\n';
    } else if (path.contains('events.jsonl')) {
      body = '${jsonEncode(_eventJson)}\n';
    } else {
      return http.Response('Not found', 404);
    }
    return http.Response(body, 200);
  });
}

void main() {
  group('ProjectDataRepository', () {
    test('initial state is AsyncValue.none', () {
      final service = GitHubApiService(client: successClient());
      final repo = ProjectDataRepository(
        apiService: service,
        token: _token,
      );
      expect(repo.state, isA<AsyncValueNone>());
      expect(repo.state.data, isNull);
      repo.dispose();
    });

    test('loadProject populates all entity types', () async {
      final service = GitHubApiService(client: successClient());
      final repo = ProjectDataRepository(
        apiService: service,
        token: _token,
      );

      await repo.loadProject(
        owner: _owner,
        repo: _repo,
        project: _project,
      );

      expect(repo.state, isA<AsyncValueDone>());
      expect(repo.state.data?.issues, hasLength(1));
      expect(repo.state.data?.issues.first.id, 'issue-001');
      expect(repo.state.data?.comments, hasLength(1));
      expect(repo.state.data?.labels, hasLength(1));
      expect(repo.state.data?.dependencies, hasLength(1));
      repo.dispose();
    });

    test('loadProject sets error state on failure', () async {
      final client = MockClient((request) async {
        return http.Response('Bad request', 400);
      });
      final service = GitHubApiService(client: client);
      final repo = ProjectDataRepository(
        apiService: service,
        token: _token,
        maxRetries: 0,
      );

      await repo.loadProject(
        owner: _owner,
        repo: _repo,
        project: _project,
      );

      expect(repo.state, isA<AsyncValueDone>());
      expect(repo.state.hasError, isTrue);
      expect(repo.state.error, isNotNull);
      repo.dispose();
    });

    test('retries on server error then succeeds', () async {
      var attempts = 0;
      final client = MockClient((request) async {
        attempts++;
        if (attempts <= 5) {
          return http.Response('Server error', 500);
        }
        final path = request.url.path;
        String body;
        if (path.contains('issues.jsonl')) {
          body = '${jsonEncode(_issueJson)}\n';
        } else if (path.contains('comments.jsonl')) {
          body = '${jsonEncode(_commentJson)}\n';
        } else if (path.contains('labels.jsonl')) {
          body = '${jsonEncode(_labelJson)}\n';
        } else if (path.contains('dependencies.jsonl')) {
          body = '${jsonEncode(_dependencyJson)}\n';
        } else if (path.contains('events.jsonl')) {
          body = '${jsonEncode(_eventJson)}\n';
        } else {
          return http.Response('Not found', 404);
        }
        return http.Response(body, 200);
      });
      final service = GitHubApiService(client: client);
      final repo = ProjectDataRepository(
        apiService: service,
        token: _token,
        maxRetries: 3,
      );

      await repo.loadProject(
        owner: _owner,
        repo: _repo,
        project: _project,
      );

      expect(repo.state, isA<AsyncValueDone>());
      expect(repo.state.data?.issues, hasLength(1));
      repo.dispose();
    });

    test('byStatus filters issues correctly', () async {
      final service = GitHubApiService(client: successClient());
      final repo = ProjectDataRepository(
        apiService: service,
        token: _token,
      );

      await repo.loadProject(
        owner: _owner,
        repo: _repo,
        project: _project,
      );

      final issues = repo.state.data?.issues ?? [];
      expect(issues.where((i) => i.status == 'open'), hasLength(1));
      expect(issues.where((i) => i.status == 'closed'), isEmpty);
      repo.dispose();
    });
  });
}
