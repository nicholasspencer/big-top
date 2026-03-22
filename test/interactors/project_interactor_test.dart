import 'package:big_top/core/async_value.dart';
import 'package:big_top/project/interactors/project_interactor.dart';
import 'package:big_top/project/repositories/project_data_repository.dart';
import 'package:big_top/project/services/github_api_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../repositories/project_data_repository_test.dart';

const _token = 'test-token';

void main() {
  group('ProjectInteractor', () {
    late ProjectDataRepository dataRepo;
    late ProjectInteractor interactor;

    setUp(() {
      final service = GitHubApiService(client: successClient());
      dataRepo = ProjectDataRepository(
        apiService: service,
        token: _token,
      );
      interactor = ProjectInteractor(dataRepo: dataRepo);
    });

    tearDown(() {
      interactor.dispose();
      dataRepo.dispose();
    });

    test('initial state has no selection and no data', () {
      expect(interactor.state.selection, isA<ProjectSelectionNone>());
      expect(interactor.state.data, isA<AsyncValueNone>());
    });

    test('selectProject updates selection and triggers fetch', () async {
      await interactor.selectProject(
        owner: 'octocat',
        repo: 'hello-world',
        project: 'p1',
      );

      expect(interactor.state.selection, isA<ProjectSelectionSelected>());
      final sel = interactor.state.selection as ProjectSelectionSelected;
      expect(sel.owner, 'octocat');
      expect(sel.repo, 'hello-world');
      expect(sel.project, 'p1');

      expect(interactor.state.data, isA<AsyncValueDone>());
      expect(interactor.state.data.data?.issues, hasLength(1));
    });

    test('clear resets to initial state', () async {
      await interactor.selectProject(
        owner: 'octocat',
        repo: 'hello-world',
        project: 'p1',
      );
      interactor.clear();

      expect(interactor.state.selection, isA<ProjectSelectionNone>());
      expect(interactor.state.data, isA<AsyncValueNone>());
    });

    test('refresh reloads data for current selection', () async {
      await interactor.selectProject(
        owner: 'octocat',
        repo: 'hello-world',
        project: 'p1',
      );

      // Refresh should reload successfully
      await interactor.refresh();

      expect(interactor.state.data, isA<AsyncValueDone>());
      expect(interactor.state.data.data?.issues, hasLength(1));
    });

    test('refresh does nothing when no project selected', () async {
      await interactor.refresh();

      // State should remain unchanged
      expect(interactor.state.selection, isA<ProjectSelectionNone>());
      expect(interactor.state.data, isA<AsyncValueNone>());
    });
  });
}
