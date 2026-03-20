import 'dart:convert';

import 'package:big_top/models/comment.dart';
import 'package:big_top/models/dependency.dart';
import 'package:big_top/models/event.dart';
import 'package:big_top/models/issue.dart';
import 'package:big_top/models/label.dart';
import 'package:big_top/models/project_data.dart';
import 'package:big_top/services/github_api_service.dart';
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

final _manifestJson = {
  'projects': ['my-project', 'other-project'],
  'version': 1,
};

/// Create a mock client that returns [body] for the given [expectedPath].
MockClient _mockClient(String expectedPath, String body,
    {int statusCode = 200, Map<String, String>? headers}) {
  return MockClient((request) async {
    expect(request.url.path, contains(expectedPath));
    expect(request.headers['Authorization'], 'Bearer $_token');
    return http.Response(body, statusCode, headers: headers ?? {});
  });
}

/// Create a mock client that routes based on URL path.
MockClient _routingMockClient(Map<String, String> pathToBody) {
  return MockClient((request) async {
    for (final entry in pathToBody.entries) {
      if (request.url.path.contains(entry.key)) {
        return http.Response(entry.value, 200);
      }
    }
    return http.Response('Not found', 404);
  });
}

void main() {
  group('GitHubApiService', () {
    group('fetchIssues', () {
      test('parses JSONL response into Issue list', () async {
        final body = '${jsonEncode(_issueJson)}\n';
        final client = _mockClient('data/$_project/issues.jsonl', body);
        final service = GitHubApiService(client: client);

        final issues = await service.fetchIssues(
          token: _token,
          owner: _owner,
          repo: _repo,
          project: _project,
        );

        expect(issues, hasLength(1));
        expect(issues.first, isA<Issue>());
        expect(issues.first.id, 'issue-001');
        expect(issues.first.title, 'Fix bug');
        expect(issues.first.priority, 1);
      });

      test('handles multi-line JSONL with blank lines', () async {
        final body = '${jsonEncode(_issueJson)}\n\n${jsonEncode({
          ..._issueJson,
          'id': 'issue-002',
          'title': 'Another bug',
        })}\n';
        final client = _mockClient('data/$_project/issues.jsonl', body);
        final service = GitHubApiService(client: client);

        final issues = await service.fetchIssues(
          token: _token,
          owner: _owner,
          repo: _repo,
          project: _project,
        );

        expect(issues, hasLength(2));
        expect(issues[1].id, 'issue-002');
      });
    });

    group('fetchComments', () {
      test('parses JSONL response into Comment list', () async {
        final body = '${jsonEncode(_commentJson)}\n';
        final client = _mockClient('data/$_project/comments.jsonl', body);
        final service = GitHubApiService(client: client);

        final comments = await service.fetchComments(
          token: _token,
          owner: _owner,
          repo: _repo,
          project: _project,
        );

        expect(comments, hasLength(1));
        expect(comments.first, isA<Comment>());
        expect(comments.first.id, 'comment-001');
        expect(comments.first.author, 'bob');
      });
    });

    group('fetchLabels', () {
      test('parses JSONL response into Label list', () async {
        final body = '${jsonEncode(_labelJson)}\n';
        final client = _mockClient('data/$_project/labels.jsonl', body);
        final service = GitHubApiService(client: client);

        final labels = await service.fetchLabels(
          token: _token,
          owner: _owner,
          repo: _repo,
          project: _project,
        );

        expect(labels, hasLength(1));
        expect(labels.first, isA<Label>());
        expect(labels.first.label, 'bug');
      });
    });

    group('fetchDependencies', () {
      test('parses JSONL response into Dependency list', () async {
        final body = '${jsonEncode(_dependencyJson)}\n';
        final client =
            _mockClient('data/$_project/dependencies.jsonl', body);
        final service = GitHubApiService(client: client);

        final deps = await service.fetchDependencies(
          token: _token,
          owner: _owner,
          repo: _repo,
          project: _project,
        );

        expect(deps, hasLength(1));
        expect(deps.first, isA<Dependency>());
        expect(deps.first.issueId, 'issue-002');
        expect(deps.first.dependsOnId, 'issue-001');
      });
    });

    group('fetchEvents', () {
      test('parses JSONL response into Event list', () async {
        final body = '${jsonEncode(_eventJson)}\n';
        final client = _mockClient('data/$_project/events.jsonl', body);
        final service = GitHubApiService(client: client);

        final events = await service.fetchEvents(
          token: _token,
          owner: _owner,
          repo: _repo,
          project: _project,
        );

        expect(events, hasLength(1));
        expect(events.first, isA<Event>());
        expect(events.first.eventType, 'status_change');
        expect(events.first.data['from'], 'open');
      });
    });

    group('fetchManifest', () {
      test('parses manifest.json', () async {
        final body = jsonEncode(_manifestJson);
        final client = _mockClient('data/manifest.json', body);
        final service = GitHubApiService(client: client);

        final manifest = await service.fetchManifest(
          token: _token,
          owner: _owner,
          repo: _repo,
        );

        expect(manifest['projects'], hasLength(2));
        expect(manifest['version'], 1);
      });
    });

    group('fetchAllProjectData', () {
      test('loads all entity types in parallel', () async {
        final client = _routingMockClient({
          'issues.jsonl': '${jsonEncode(_issueJson)}\n',
          'comments.jsonl': '${jsonEncode(_commentJson)}\n',
          'labels.jsonl': '${jsonEncode(_labelJson)}\n',
          'dependencies.jsonl': '${jsonEncode(_dependencyJson)}\n',
          'events.jsonl': '${jsonEncode(_eventJson)}\n',
        });
        final service = GitHubApiService(client: client);

        final data = await service.fetchAllProjectData(
          token: _token,
          owner: _owner,
          repo: _repo,
          project: _project,
        );

        expect(data, isA<ProjectData>());
        expect(data.issues, hasLength(1));
        expect(data.comments, hasLength(1));
        expect(data.labels, hasLength(1));
        expect(data.dependencies, hasLength(1));
        expect(data.events, hasLength(1));
      });
    });

    group('error handling', () {
      test('throws HttpException on 404', () async {
        final client = _mockClient(
            'data/$_project/issues.jsonl', 'Not found',
            statusCode: 404);
        final service = GitHubApiService(client: client);

        expect(
          () => service.fetchIssues(
            token: _token,
            owner: _owner,
            repo: _repo,
            project: _project,
          ),
          throwsA(isA<HttpException>()),
        );
      });

      test('throws HttpException on server error', () async {
        final client = _mockClient(
            'data/$_project/issues.jsonl', 'Server error',
            statusCode: 500);
        final service = GitHubApiService(client: client);

        expect(
          () => service.fetchIssues(
            token: _token,
            owner: _owner,
            repo: _repo,
            project: _project,
          ),
          throwsA(isA<HttpException>()),
        );
      });

      test('throws HttpException on other error status codes', () async {
        final client = _mockClient(
            'data/$_project/issues.jsonl', 'Bad request',
            statusCode: 400);
        final service = GitHubApiService(client: client);

        expect(
          () => service.fetchIssues(
            token: _token,
            owner: _owner,
            repo: _repo,
            project: _project,
          ),
          throwsA(isA<HttpException>()),
        );
      });
    });

    group('triggerWorkflowDispatch', () {
      test('sends POST and succeeds on 204', () async {
        final client = MockClient((request) async {
          expect(request.method, 'POST');
          expect(request.url.path, contains('dispatches'));
          final body = jsonDecode(request.body) as Map<String, dynamic>;
          expect(body['ref'], 'main');
          return http.Response('', 204);
        });
        final service = GitHubApiService(client: client);

        await service.triggerWorkflowDispatch(
          token: _token,
          owner: _owner,
          repo: _repo,
          workflowId: 'sync.yml',
        );
      });

      test('throws on non-204 response', () async {
        final client = MockClient((request) async {
          return http.Response('Not found', 404);
        });
        final service = GitHubApiService(client: client);

        expect(
          () => service.triggerWorkflowDispatch(
            token: _token,
            owner: _owner,
            repo: _repo,
            workflowId: 'sync.yml',
          ),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}
