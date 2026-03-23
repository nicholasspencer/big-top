import 'package:big_top/src/auth/repositories/auth_repository.dart';
import 'package:big_top/src/board/interactors/board_selector.dart';
import 'package:big_top/src/board/viewmodels/board_viewmodel.dart';
import 'package:big_top/src/project/interactors/project_interactor.dart';
import 'package:big_top/src/project/repositories/project_data_repository.dart';
import 'package:big_top/src/project/services/github_api_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../repositories/auth_repository_test.dart';
import '../repositories/project_data_repository_test.dart' show successClient;

void main() {
  group('BoardViewModel', () {
    late FakeGitHubAuthService authService;
    late AuthRepository authRepo;
    late GitHubApiService apiService;
    late ProjectDataRepository dataRepo;
    late ProjectInteractor interactor;
    late BoardSelector boardSelector;

    setUp(() {
      authService = FakeGitHubAuthService();
      authRepo = AuthRepository(authService: authService);

      apiService = GitHubApiService(client: successClient());
      dataRepo = ProjectDataRepository(
        apiService: apiService,
        token: 'test-token',
      );
      interactor = ProjectInteractor(dataRepo: dataRepo);
      boardSelector = BoardSelector(dataRepo: dataRepo);
    });

    tearDown(() {
      boardSelector.dispose();
      interactor.dispose();
      dataRepo.dispose();
      authRepo.dispose();
    });

    test('derives username and avatarUrl from AuthRepository state', () async {
      // Authenticate first.
      authService.savedToken = 'valid-token';
      authService.userResponse = {
        'login': 'octocat',
        'avatar_url': 'https://example.com/octocat.png',
      };
      await authRepo.tryRestoreSession();

      final vm = BoardViewModel(
        interactor: interactor,
        boardSelector: boardSelector,
        authRepo: authRepo,
      );

      // The VM is in initial state (none), which has no data yet.
      // Load some board data so we can inspect username/avatarUrl.
      await interactor.selectProject(
        owner: 'test-owner',
        repo: 'test-repo',
        project: 'my-project',
      );

      expect(vm.state.hasData, isTrue);
      expect(vm.state.data!.username, 'octocat');
      expect(vm.state.data!.avatarUrl, 'https://example.com/octocat.png');

      vm.dispose();
    });

    test('updates username/avatarUrl when auth state changes', () async {
      // Start unauthenticated.
      final vm = BoardViewModel(
        interactor: interactor,
        boardSelector: boardSelector,
        authRepo: authRepo,
      );

      // Load board data.
      await interactor.selectProject(
        owner: 'test-owner',
        repo: 'test-repo',
        project: 'my-project',
      );

      expect(vm.state.hasData, isTrue);
      expect(vm.state.data!.username, isNull);

      // Now authenticate — VM should reactively pick up the change.
      authService.savedToken = 'valid-token';
      authService.userResponse = {
        'login': 'newuser',
        'avatar_url': 'https://example.com/newuser.png',
      };
      await authRepo.tryRestoreSession();

      expect(vm.state.data!.username, 'newuser');
      expect(vm.state.data!.avatarUrl, 'https://example.com/newuser.png');

      vm.dispose();
    });

    test('logout() delegates to AuthRepository.logout()', () async {
      // Authenticate first.
      authService.savedToken = 'valid-token';
      authService.userResponse = {
        'login': 'octocat',
        'avatar_url': 'https://example.com/octocat.png',
      };
      await authRepo.tryRestoreSession();
      expect(authRepo.isAuthenticated, isTrue);

      final vm = BoardViewModel(
        interactor: interactor,
        boardSelector: boardSelector,
        authRepo: authRepo,
      );

      await vm.logout();

      expect(authRepo.isAuthenticated, isFalse);
      expect(authService.clearTokenCalled, isTrue);

      vm.dispose();
    });
  });
}
