import 'package:big_top/detail/interactors/issue_detail_selector.dart';
import 'package:big_top/project/repositories/project_data_repository.dart';
import 'package:big_top/project/services/github_api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../repositories/project_data_repository_test.dart' show successClient;

const _token = 'test-token';
const _owner = 'test-owner';
const _repo = 'test-repo';
const _project = 'my-project';

void main() {
  group('IssueDetailSelector', () {
    test('empty state when repo has no data', () {
      final service = GitHubApiService(client: successClient());
      final repo = ProjectDataRepository(
        apiService: service,
        token: _token,
      );
      final selector = IssueDetailSelector(
        dataRepo: repo,
        issueId: 'issue-001',
      );

      expect(selector.state, isA<IssueDetailEmpty>());

      selector.dispose();
      repo.dispose();
    });

    test('loaded state with matching issue, comments, labels, deps', () async {
      final service = GitHubApiService(client: successClient());
      final repo = ProjectDataRepository(
        apiService: service,
        token: _token,
        maxRetries: 0,
      );
      final selector = IssueDetailSelector(
        dataRepo: repo,
        issueId: 'issue-001',
      );

      await repo.loadProject(
        owner: _owner,
        repo: _repo,
        project: _project,
      );

      expect(selector.state, isA<IssueDetailLoaded>());
      final loaded = selector.state as IssueDetailLoaded;
      expect(loaded.issue.id, 'issue-001');
      expect(loaded.comments, hasLength(1));
      expect(loaded.comments.first.issueId, 'issue-001');
      expect(loaded.labels, hasLength(1));
      expect(loaded.labels.first.label, 'bug');
      expect(loaded.dependencies, hasLength(1));
      expect(loaded.dependencies.first.dependsOnId, 'issue-001');

      selector.dispose();
      repo.dispose();
    });

    test('notFound state when issue ID does not match', () async {
      final service = GitHubApiService(client: successClient());
      final repo = ProjectDataRepository(
        apiService: service,
        token: _token,
        maxRetries: 0,
      );
      final selector = IssueDetailSelector(
        dataRepo: repo,
        issueId: 'nonexistent',
      );

      await repo.loadProject(
        owner: _owner,
        repo: _repo,
        project: _project,
      );

      expect(selector.state, isA<IssueDetailNotFound>());

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
      final selector = IssueDetailSelector(
        dataRepo: repo,
        issueId: 'issue-001',
      );

      await repo.loadProject(
        owner: _owner,
        repo: _repo,
        project: _project,
      );

      expect(selector.state, isA<IssueDetailError>());

      selector.dispose();
      repo.dispose();
    });
  });
}
