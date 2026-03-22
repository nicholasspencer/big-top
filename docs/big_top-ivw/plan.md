# Refactor to predictable-flutter Architecture — Implementation Plan

> **REQUIRED:** Follow the executing-plans skill to implement this plan task-by-task.

**Bead:** `big_top-ivw`
**Goal:** Refactor big-top to three-layer architecture (Data → Domain → View) following the predictable-flutter skill.

**Architecture:** Rename `IssuesRepository` → `ProjectDataRepository`, delete `ProjectRepository`, create domain layer (`ProjectInteractor`, `BoardSelector`, `IssueDetailSelector`), rewrite ViewModels and Screens to consume domain layer only.

**Tech Stack:** Flutter, StateNotifier, provider, freezed, go_router

**Skill:** Link `predictable-flutter` skill. Load its reference docs per layer (data-layer.md for Tasks 1-2, domain-layer.md for Tasks 3-5, view-layer.md for Tasks 6-8).

---

### Task 1: Rename `IssuesRepository` → `ProjectDataRepository`

**Files:**
- Rename: `lib/project/repositories/issues_repository.dart` → `lib/project/repositories/project_data_repository.dart`
- Modify: `lib/app/authorized_dependencies.dart`
- Rename: `test/repositories/issues_repository_test.dart` → `test/repositories/project_data_repository_test.dart`
- Modify: All files that import `issues_repository.dart`

**Step 1: Rename the file and class**

```bash
cd ~/development/com.nicospencer/big-top
git mv lib/project/repositories/issues_repository.dart lib/project/repositories/project_data_repository.dart
```

In `lib/project/repositories/project_data_repository.dart`, rename the class:

```dart
class ProjectDataRepository extends StateNotifier<AsyncValue<ProjectData>> {
  final GitHubApiService _apiService;
  final String _token;
  final int _maxRetries;

  ProjectDataRepository({
    required GitHubApiService apiService,
    required String token,
    int maxRetries = 3,
  })  : _apiService = apiService,
        _token = token,
        _maxRetries = maxRetries,
        super(const AsyncValue.none());

  // ... rest unchanged
}
```

**Step 2: Update all imports**

Files that reference `IssuesRepository` or `issues_repository.dart`:
- `lib/app/authorized_dependencies.dart` — update import and `StateNotifierProvider` type
- `lib/board/viewmodels/board_viewmodel.dart` — update import and field type
- `lib/detail/viewmodels/detail_viewmodel.dart` — update import and field type

In `lib/app/authorized_dependencies.dart`:
```dart
import '../project/repositories/project_data_repository.dart';

// In providers list:
StateNotifierProvider<ProjectDataRepository, AsyncValue<ProjectData>>(
  create: (ctx) => ProjectDataRepository(
    apiService: ctx.read<GitHubApiService>(),
    token: authValue.requireData().token,
  ),
),
```

**Step 3: Rename and update test file**

```bash
git mv test/repositories/issues_repository_test.dart test/repositories/project_data_repository_test.dart
```

Update the import and group name in the test file:
```dart
import 'package:big_top/project/repositories/project_data_repository.dart';

void main() {
  group('ProjectDataRepository', () {
    // Update all `IssuesRepository(` → `ProjectDataRepository(`
    // ... tests otherwise unchanged
  });
}
```

**Step 4: Run tests**

```bash
flutter test
```

Expected: 62 tests pass, zero analyzer issues.

**Step 5: Commit**

```bash
git add -A
git commit -m "refactor: rename IssuesRepository → ProjectDataRepository"
```

---

### Task 2: Create `ProjectInteractor` and delete `ProjectRepository`

**Files:**
- Create: `lib/project/interactors/project_interactor.dart`
- Create: `test/interactors/project_interactor_test.dart`
- Delete: `lib/project/repositories/project_repository.dart` (and `.freezed.dart`)
- Delete: `test/repositories/project_repository_test.dart`
- Modify: `lib/app/authorized_dependencies.dart`
- Modify: `lib/board/viewmodels/board_viewmodel.dart`

**Step 1: Create `ProjectInteractor` state**

Create `lib/project/interactors/project_interactor.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:state_notifier/state_notifier.dart';

import '../../core/async_value.dart';
import '../models/project_data.dart';
import '../repositories/project_data_repository.dart';

part 'project_interactor.freezed.dart';

@freezed
sealed class ProjectSelection with _$ProjectSelection {
  const ProjectSelection._();

  const factory ProjectSelection.none() = ProjectSelectionNone;
  const factory ProjectSelection.selected({
    required String owner,
    required String repo,
    String? project,
  }) = ProjectSelectionSelected;

  bool get isSelected => this is ProjectSelectionSelected;
  String? get owner => switch (this) {
    ProjectSelectionSelected(:final owner) => owner,
    _ => null,
  };
  String? get repo => switch (this) {
    ProjectSelectionSelected(:final repo) => repo,
    _ => null,
  };
  String? get project => switch (this) {
    ProjectSelectionSelected(:final project) => project,
    _ => null,
  };
}

@freezed
sealed class ProjectInteractorState with _$ProjectInteractorState {
  const factory ProjectInteractorState({
    @Default(ProjectSelection.none()) ProjectSelection selection,
    @Default(AsyncValue<ProjectData>.none()) AsyncValue<ProjectData> data,
  }) = _ProjectInteractorState;
}

class ProjectInteractor extends StateNotifier<ProjectInteractorState> {
  final ProjectDataRepository _dataRepo;
  late final Function() _removeListener;

  ProjectInteractor({
    required ProjectDataRepository dataRepo,
  })  : _dataRepo = dataRepo,
        super(const ProjectInteractorState()) {
    _removeListener = _dataRepo.addListener(_onDataChanged);
  }

  void _onDataChanged(AsyncValue<ProjectData> data) {
    state = state.copyWith(data: data);
  }

  Future<void> selectProject({
    required String owner,
    required String repo,
    String? project,
  }) async {
    state = state.copyWith(
      selection: ProjectSelection.selected(
        owner: owner,
        repo: repo,
        project: project,
      ),
    );
    await refresh();
  }

  Future<void> refresh() async {
    final selection = state.selection;
    if (selection is! ProjectSelectionSelected) return;
    await _dataRepo.loadProject(
      owner: selection.owner,
      repo: selection.repo,
      project: selection.project ?? selection.repo,
    );
  }

  void clear() {
    state = const ProjectInteractorState();
  }

  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }
}
```

**Step 2: Run build_runner**

```bash
dart run build_runner build --delete-conflicting-outputs
```

**Step 3: Write tests**

Create `test/interactors/project_interactor_test.dart`:

```dart
import 'package:big_top/core/async_value.dart';
import 'package:big_top/project/interactors/project_interactor.dart';
import 'package:big_top/project/models/project_data.dart';
import 'package:big_top/project/repositories/project_data_repository.dart';
import 'package:big_top/project/services/github_api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../repositories/project_data_repository_test.dart' show successClient;

void main() {
  group('ProjectInteractor', () {
    late ProjectDataRepository dataRepo;
    late ProjectInteractor interactor;

    setUp(() {
      final service = GitHubApiService(client: successClient());
      dataRepo = ProjectDataRepository(apiService: service, token: 'test');
      interactor = ProjectInteractor(dataRepo: dataRepo);
    });

    tearDown(() {
      interactor.dispose();
      dataRepo.dispose();
    });

    test('initial state has no selection and no data', () {
      expect(interactor.state.selection.isSelected, isFalse);
      expect(interactor.state.data, isA<AsyncValueNone>());
    });

    test('selectProject updates selection and triggers fetch', () async {
      await interactor.selectProject(
        owner: 'octocat',
        repo: 'hello-world',
        project: 'p1',
      );

      expect(interactor.state.selection.isSelected, isTrue);
      expect(interactor.state.selection.owner, 'octocat');
      expect(interactor.state.selection.repo, 'hello-world');
      expect(interactor.state.data.hasData, isTrue);
      expect(interactor.state.data.data?.issues, isNotEmpty);
    });

    test('clear resets to initial state', () async {
      await interactor.selectProject(
        owner: 'octocat',
        repo: 'hello-world',
      );
      interactor.clear();

      expect(interactor.state.selection.isSelected, isFalse);
    });

    test('refresh reloads data for current selection', () async {
      await interactor.selectProject(
        owner: 'octocat',
        repo: 'hello-world',
      );
      final firstData = interactor.state.data;

      await interactor.refresh();

      expect(interactor.state.data.hasData, isTrue);
    });

    test('refresh does nothing when no project selected', () async {
      await interactor.refresh();
      expect(interactor.state.data, isA<AsyncValueNone>());
    });
  });
}
```

Note: the test file imports a `successClient` helper — you'll need to extract the `_successClient()` function from `test/repositories/project_data_repository_test.dart` and make it public (rename to `successClient` and remove the underscore).

**Step 4: Run tests**

```bash
flutter test
```

Expected: all new tests pass. Existing tests still pass.

**Step 5: Delete `ProjectRepository`**

```bash
rm lib/project/repositories/project_repository.dart
rm lib/project/repositories/project_repository.freezed.dart
rm test/repositories/project_repository_test.dart
```

**Step 6: Update `authorized_dependencies.dart`**

Replace the `ProjectRepository` provider with `ProjectInteractor`:

```dart
import '../project/interactors/project_interactor.dart';

// Remove the ProjectRepository import and provider.
// Add:
StateNotifierProvider<ProjectInteractor, ProjectInteractorState>(
  create: (ctx) => ProjectInteractor(
    dataRepo: ctx.read<ProjectDataRepository>(),
  ),
),
```

**Step 7: Temporarily fix `BoardViewModel`**

`BoardViewModel` currently depends on both `IssuesRepository` and `ProjectRepository`. Update it to depend on `ProjectInteractor` and `ProjectDataRepository` temporarily (it will be fully rewritten in Task 6):

```dart
import 'package:big_top/project/interactors/project_interactor.dart';
import 'package:big_top/project/repositories/project_data_repository.dart';

class BoardViewModel extends StateNotifier<BoardState> {
  final ProjectInteractor _projectInteractor;

  BoardViewModel({
    required ProjectInteractor projectInteractor,
  })  : _projectInteractor = projectInteractor,
        super(const BoardState());

  Future<void> selectProject({
    required String owner,
    required String repo,
    String? project,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _projectInteractor.selectProject(
        owner: owner,
        repo: repo,
        project: project,
      );
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _projectInteractor.refresh();
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
```

**Step 8: Run tests and analyzer**

```bash
dart analyze lib test
flutter test
```

Expected: all pass. `ProjectRepository` is fully removed.

**Step 9: Commit**

```bash
git add -A
git commit -m "refactor: add ProjectInteractor, remove ProjectRepository

ProjectInteractor coordinates project selection and data fetching.
ProjectRepository (selection-only state) deleted — domain concern
now lives in the interactor layer."
```

---

### Task 3: Create `BoardSelector`

**Files:**
- Create: `lib/board/interactors/board_selector.dart`
- Create: `test/interactors/board_selector_test.dart`

**Step 1: Create `BoardSelector`**

Create `lib/board/interactors/board_selector.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:state_notifier/state_notifier.dart';

import '../../core/async_value.dart';
import '../../project/models/issue.dart';
import '../../project/models/project_data.dart';
import '../../project/repositories/project_data_repository.dart';

part 'board_selector.freezed.dart';

@freezed
sealed class BoardColumn with _$BoardColumn {
  const factory BoardColumn({
    required String status,
    required String label,
    @Default([]) List<Issue> issues,
  }) = _BoardColumn;
}

@freezed
sealed class BoardSelectorState with _$BoardSelectorState {
  const factory BoardSelectorState.empty() = BoardSelectorEmpty;
  const factory BoardSelectorState.loading() = BoardSelectorLoading;
  const factory BoardSelectorState.loaded({
    required List<BoardColumn> columns,
  }) = BoardSelectorLoaded;
  const factory BoardSelectorState.error({
    required String message,
  }) = BoardSelectorError;
}

class BoardSelector extends StateNotifier<BoardSelectorState> {
  final ProjectDataRepository _dataRepo;
  late final Function() _removeListener;

  static const _columnOrder = ['open', 'in_progress', 'blocked', 'closed'];
  static const _columnLabels = {
    'open': 'Open',
    'in_progress': 'In Progress',
    'blocked': 'Blocked',
    'closed': 'Closed',
  };

  BoardSelector({
    required ProjectDataRepository dataRepo,
  })  : _dataRepo = dataRepo,
        super(const BoardSelectorState.empty()) {
    _removeListener = _dataRepo.addListener(_recompute);
    _recompute(_dataRepo.state);
  }

  void _recompute(AsyncValue<ProjectData> value) {
    if (value is AsyncValueNone && !value.hasData) {
      state = const BoardSelectorState.empty();
      return;
    }
    if ((value is AsyncValueWaiting || value is AsyncValueActive) && !value.hasData) {
      state = const BoardSelectorState.loading();
      return;
    }
    if (value.hasError && !value.hasData) {
      state = BoardSelectorState.error(message: value.error.toString());
      return;
    }
    if (value.hasData) {
      final data = value.data!;
      final columns = _columnOrder.map((status) {
        final issues = data.issues
            .where((i) => i.status == status)
            .toList()
          ..sort((a, b) => a.priority.compareTo(b.priority));
        return BoardColumn(
          status: status,
          label: _columnLabels[status] ?? status,
          issues: issues,
        );
      }).toList();
      state = BoardSelectorState.loaded(columns: columns);
      return;
    }
  }

  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }
}
```

**Step 2: Run build_runner**

```bash
dart run build_runner build --delete-conflicting-outputs
```

**Step 3: Write tests**

Create `test/interactors/board_selector_test.dart`:

```dart
import 'package:big_top/board/interactors/board_selector.dart';
import 'package:big_top/core/async_value.dart';
import 'package:big_top/project/models/issue.dart';
import 'package:big_top/project/models/project_data.dart';
import 'package:big_top/project/repositories/project_data_repository.dart';
import 'package:big_top/project/services/github_api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;

void main() {
  group('BoardSelector', () {
    test('initial state is empty when repo has no data', () {
      final service = GitHubApiService(client: MockClient((_) async => http.Response('', 404)));
      final repo = ProjectDataRepository(apiService: service, token: 'test');
      final selector = BoardSelector(dataRepo: repo);

      expect(selector.state, isA<BoardSelectorEmpty>());

      selector.dispose();
      repo.dispose();
    });

    test('produces 4 columns sorted by priority when data is loaded', () async {
      final now = DateTime.now();
      final issues = [
        Issue(id: '1', title: 'A', status: 'open', priority: 2, createdAt: now, updatedAt: now),
        Issue(id: '2', title: 'B', status: 'open', priority: 1, createdAt: now, updatedAt: now),
        Issue(id: '3', title: 'C', status: 'closed', priority: 1, createdAt: now, updatedAt: now),
      ];
      final data = ProjectData(issues: issues);

      // Use a mock client that won't be called — we'll set state directly
      final service = GitHubApiService(client: MockClient((_) async => http.Response('', 404)));
      final repo = ProjectDataRepository(apiService: service, token: 'test');
      final selector = BoardSelector(dataRepo: repo);

      // Simulate repo emitting loaded data by calling loadProject won't work here,
      // so we test with a real flow. For unit testing, we need the repo to emit state.
      // This is an integration-level test — acceptable for selectors.

      selector.dispose();
      repo.dispose();
    });
  });
}
```

Note: For proper unit testing of `BoardSelector`, you'll need to either:
1. Create a minimal mock `ProjectDataRepository` subclass that lets you set state, or
2. Test it as integration with a real repo and mock HTTP client.

Option 2 is simpler and more realistic. Use the `successClient()` helper from the repo tests to drive a full flow:

```dart
import '../repositories/project_data_repository_test.dart' show successClient;

test('produces columns after repo loads data', () async {
  final service = GitHubApiService(client: successClient());
  final repo = ProjectDataRepository(apiService: service, token: 'test');
  final selector = BoardSelector(dataRepo: repo);

  await repo.loadProject(owner: 'o', repo: 'r', project: 'p');

  expect(selector.state, isA<BoardSelectorLoaded>());
  final loaded = selector.state as BoardSelectorLoaded;
  expect(loaded.columns, hasLength(4));
  expect(loaded.columns.first.status, 'open');
  expect(loaded.columns.first.issues, hasLength(1)); // one issue from fixture

  selector.dispose();
  repo.dispose();
});
```

**Step 4: Run tests**

```bash
flutter test
```

**Step 5: Commit**

```bash
git add -A
git commit -m "feat: add BoardSelector domain layer

Derives board columns from ProjectDataRepository state.
Groups issues by status, sorts by priority."
```

---

### Task 4: Create `IssueDetailSelector`

**Files:**
- Create: `lib/detail/interactors/issue_detail_selector.dart`
- Create: `test/interactors/issue_detail_selector_test.dart`

**Step 1: Create `IssueDetailSelector`**

Create `lib/detail/interactors/issue_detail_selector.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:state_notifier/state_notifier.dart';

import '../../core/async_value.dart';
import '../../project/models/comment.dart';
import '../../project/models/dependency.dart';
import '../../project/models/issue.dart';
import '../../project/models/label.dart';
import '../../project/models/project_data.dart';
import '../../project/repositories/project_data_repository.dart';

part 'issue_detail_selector.freezed.dart';

@freezed
sealed class IssueDetailState with _$IssueDetailState {
  const factory IssueDetailState.empty() = IssueDetailEmpty;
  const factory IssueDetailState.loading() = IssueDetailLoading;
  const factory IssueDetailState.loaded({
    required Issue issue,
    @Default([]) List<Comment> comments,
    @Default([]) List<Label> labels,
    @Default([]) List<Dependency> dependencies,
  }) = IssueDetailLoaded;
  const factory IssueDetailState.notFound() = IssueDetailNotFound;
  const factory IssueDetailState.error({
    required String message,
  }) = IssueDetailError;
}

class IssueDetailSelector extends StateNotifier<IssueDetailState> {
  final ProjectDataRepository _dataRepo;
  final String issueId;
  late final Function() _removeListener;

  IssueDetailSelector({
    required ProjectDataRepository dataRepo,
    required this.issueId,
  })  : _dataRepo = dataRepo,
        super(const IssueDetailState.empty()) {
    _removeListener = _dataRepo.addListener(_recompute);
    _recompute(_dataRepo.state);
  }

  void _recompute(AsyncValue<ProjectData> value) {
    if (value is AsyncValueNone && !value.hasData) {
      state = const IssueDetailState.empty();
      return;
    }
    if ((value is AsyncValueWaiting || value is AsyncValueActive) && !value.hasData) {
      state = const IssueDetailState.loading();
      return;
    }
    if (value.hasError && !value.hasData) {
      state = IssueDetailState.error(message: value.error.toString());
      return;
    }
    if (value.hasData) {
      final data = value.data!;
      final issue = data.issues.where((i) => i.id == issueId).firstOrNull;
      if (issue == null) {
        state = const IssueDetailState.notFound();
        return;
      }
      state = IssueDetailState.loaded(
        issue: issue,
        comments: data.comments.where((c) => c.issueId == issueId).toList(),
        labels: data.labels.where((l) => l.issueId == issueId).toList(),
        dependencies: data.dependencies
            .where((d) => d.issueId == issueId || d.dependsOnId == issueId)
            .toList(),
      );
    }
  }

  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }
}
```

**Step 2: Run build_runner**

```bash
dart run build_runner build --delete-conflicting-outputs
```

**Step 3: Write tests**

Create `test/interactors/issue_detail_selector_test.dart`:

```dart
import 'package:big_top/core/async_value.dart';
import 'package:big_top/detail/interactors/issue_detail_selector.dart';
import 'package:big_top/project/repositories/project_data_repository.dart';
import 'package:big_top/project/services/github_api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';

import '../repositories/project_data_repository_test.dart' show successClient;

void main() {
  group('IssueDetailSelector', () {
    test('initial state is empty when repo has no data', () {
      final service = GitHubApiService(client: successClient());
      final repo = ProjectDataRepository(apiService: service, token: 'test');
      final selector = IssueDetailSelector(dataRepo: repo, issueId: 'issue-001');

      expect(selector.state, isA<IssueDetailEmpty>());

      selector.dispose();
      repo.dispose();
    });

    test('produces loaded state with matching issue data', () async {
      final service = GitHubApiService(client: successClient());
      final repo = ProjectDataRepository(apiService: service, token: 'test');
      final selector = IssueDetailSelector(dataRepo: repo, issueId: 'issue-001');

      await repo.loadProject(owner: 'o', repo: 'r', project: 'p');

      expect(selector.state, isA<IssueDetailLoaded>());
      final loaded = selector.state as IssueDetailLoaded;
      expect(loaded.issue.id, 'issue-001');
      expect(loaded.comments, hasLength(1));
      expect(loaded.labels, hasLength(1));
      expect(loaded.dependencies, hasLength(1));

      selector.dispose();
      repo.dispose();
    });

    test('produces notFound when issue ID does not match', () async {
      final service = GitHubApiService(client: successClient());
      final repo = ProjectDataRepository(apiService: service, token: 'test');
      final selector = IssueDetailSelector(dataRepo: repo, issueId: 'nonexistent');

      await repo.loadProject(owner: 'o', repo: 'r', project: 'p');

      expect(selector.state, isA<IssueDetailNotFound>());

      selector.dispose();
      repo.dispose();
    });
  });
}
```

**Step 4: Run tests**

```bash
flutter test
```

**Step 5: Commit**

```bash
git add -A
git commit -m "feat: add IssueDetailSelector domain layer

Derives issue detail data (issue, comments, labels, dependencies)
from ProjectDataRepository state for a given issue ID."
```

---

### Task 5: Wire domain layer into `AuthorizedDependencies`

**Files:**
- Modify: `lib/app/authorized_dependencies.dart`

**Step 1: Add domain layer providers**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../board/interactors/board_selector.dart';
import '../core/async_value.dart';
import '../auth/models/auth_session.dart';
import '../project/interactors/project_interactor.dart';
import '../project/models/project_data.dart';
import '../project/repositories/project_data_repository.dart';
import '../project/services/github_api_service.dart';

class AuthorizedDependencies extends SingleChildStatelessWidget {
  const AuthorizedDependencies({super.key, super.child});

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    final authValue = context.watch<AsyncValue<AuthSession>>();

    if (!authValue.hasData) return child!;

    return MultiProvider(
      providers: [
        // Data layer
        StateNotifierProvider<ProjectDataRepository, AsyncValue<ProjectData>>(
          create: (ctx) => ProjectDataRepository(
            apiService: ctx.read<GitHubApiService>(),
            token: authValue.requireData().token,
          ),
        ),
        // Domain layer
        StateNotifierProvider<ProjectInteractor, ProjectInteractorState>(
          create: (ctx) => ProjectInteractor(
            dataRepo: ctx.read<ProjectDataRepository>(),
          ),
        ),
        StateNotifierProvider<BoardSelector, BoardSelectorState>(
          create: (ctx) => BoardSelector(
            dataRepo: ctx.read<ProjectDataRepository>(),
          ),
        ),
      ],
      child: child!,
    );
  }
}
```

Note: `IssueDetailSelector` is NOT provided here — it's scoped to the detail screen (created per issue ID, short-lived).

**Step 2: Run analyzer**

```bash
dart analyze lib
```

**Step 3: Run tests**

```bash
flutter test
```

**Step 4: Commit**

```bash
git add -A
git commit -m "refactor: wire domain layer into AuthorizedDependencies"
```

---

### Task 6: Rewrite `BoardViewModel` + `BoardScreen`

**Files:**
- Rewrite: `lib/board/viewmodels/board_viewmodel.dart`
- Rewrite: `lib/board/screens/board_screen.dart`

**Step 1: Rewrite `BoardViewModel`**

Replace `lib/board/viewmodels/board_viewmodel.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:state_notifier/state_notifier.dart';

import '../interactors/board_selector.dart';
import '../../project/interactors/project_interactor.dart';
import '../../project/models/issue.dart';

part 'board_viewmodel.freezed.dart';

@freezed
sealed class BoardState with _$BoardState {
  const factory BoardState.loading() = BoardStateLoading;
  const factory BoardState.loaded({
    required List<BoardColumn> columns,
    String? username,
    String? avatarUrl,
  }) = BoardStateLoaded;
  const factory BoardState.empty() = BoardStateEmpty;
  const factory BoardState.error({required String message}) = BoardStateError;
}

class BoardViewModel extends StateNotifier<BoardState> {
  final ProjectInteractor _projectInteractor;
  final BoardSelector _boardSelector;
  late final Function() _removeBoardListener;
  
  final String? username;
  final String? avatarUrl;

  BoardViewModel({
    required ProjectInteractor projectInteractor,
    required BoardSelector boardSelector,
    this.username,
    this.avatarUrl,
  })  : _projectInteractor = projectInteractor,
        _boardSelector = boardSelector,
        super(const BoardState.empty()) {
    _removeBoardListener = _boardSelector.addListener(_onBoardChanged);
    _onBoardChanged(_boardSelector.state);
  }

  void _onBoardChanged(BoardSelectorState selectorState) {
    state = switch (selectorState) {
      BoardSelectorEmpty() => const BoardState.empty(),
      BoardSelectorLoading() => const BoardState.loading(),
      BoardSelectorLoaded(:final columns) => BoardState.loaded(
        columns: columns,
        username: username,
        avatarUrl: avatarUrl,
      ),
      BoardSelectorError(:final message) => BoardState.error(message: message),
    };
  }

  Future<void> selectProject({
    required String owner,
    required String repo,
    String? project,
  }) async {
    await _projectInteractor.selectProject(
      owner: owner,
      repo: repo,
      project: project,
    );
  }

  Future<void> refresh() async {
    await _projectInteractor.refresh();
  }

  @override
  void dispose() {
    _removeBoardListener();
    super.dispose();
  }
}
```

**Step 2: Run build_runner**

```bash
dart run build_runner build --delete-conflicting-outputs
```

**Step 3: Rewrite `BoardScreen`**

Replace `lib/board/screens/board_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:provider/provider.dart';

import '../../auth/models/auth_session.dart';
import '../../auth/repositories/auth_repository.dart';
import '../../core/async_value.dart';
import '../interactors/board_selector.dart';
import '../../project/interactors/project_interactor.dart';
import '../viewmodels/board_viewmodel.dart';
import '../widgets/status_column.dart';

class BoardScreen extends StatelessWidget {
  const BoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authValue = context.read<AsyncValue<AuthSession>>();
    final session = authValue.data;

    return StateNotifierProvider<BoardViewModel, BoardState>(
      create: (ctx) => BoardViewModel(
        projectInteractor: ctx.read<ProjectInteractor>(),
        boardSelector: ctx.read<BoardSelector>(),
        username: session?.username,
        avatarUrl: session?.avatarUrl,
      ),
      child: const _BoardScreenContent(),
    );
  }
}

class _BoardScreenContent extends StatelessWidget {
  const _BoardScreenContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = context.watch<BoardState>();
    final vm = context.read<BoardViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.festival, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            const Text('Big Top'),
          ],
        ),
        actions: [
          if (state case BoardStateLoaded(:final username?, :final avatarUrl)) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Chip(
                avatar: avatarUrl != null
                    ? CircleAvatar(backgroundImage: NetworkImage(avatarUrl))
                    : null,
                label: Text(username),
              ),
            ),
          ],
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
            onPressed: () => context.read<AuthRepository>().logout(),
          ),
        ],
      ),
      body: switch (state) {
        BoardStateEmpty() => const Center(child: Text('Select a project to get started')),
        BoardStateLoading() => const Center(child: CircularProgressIndicator()),
        BoardStateError(:final message) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Error: $message'),
              const SizedBox(height: 16),
              FilledButton(onPressed: vm.refresh, child: const Text('Retry')),
            ],
          ),
        ),
        BoardStateLoaded(:final columns) => Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final column in columns)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: StatusColumn(
                      title: column.label,
                      status: column.status,
                      issues: column.issues,
                    ),
                  ),
                ),
            ],
          ),
        ),
      },
    );
  }
}
```

**Step 4: Run analyzer and tests**

```bash
dart analyze lib
flutter test
```

**Step 5: Commit**

```bash
git add -A
git commit -m "refactor: rewrite BoardViewModel + BoardScreen

BoardViewModel consumes ProjectInteractor and BoardSelector.
BoardScreen watches only its ViewModel via sealed state.
No more direct repo access from the screen."
```

---

### Task 7: Rewrite `DetailViewModel` + `DetailScreen`

**Files:**
- Rewrite: `lib/detail/viewmodels/detail_viewmodel.dart`
- Rewrite: `lib/detail/screens/detail_screen.dart`
- Modify: `lib/app/router.dart`

**Step 1: Rewrite `DetailViewModel`**

Replace `lib/detail/viewmodels/detail_viewmodel.dart`:

```dart
import 'package:state_notifier/state_notifier.dart';

import '../interactors/issue_detail_selector.dart';

class DetailViewModel extends StateNotifier<IssueDetailState> {
  final IssueDetailSelector _selector;
  late final Function() _removeListener;

  DetailViewModel({
    required IssueDetailSelector selector,
  })  : _selector = selector,
        super(selector.state) {
    _removeListener = _selector.addListener(_onChanged);
  }

  void _onChanged(IssueDetailState selectorState) {
    state = selectorState;
  }

  @override
  void dispose() {
    _removeListener();
    _selector.dispose();
    super.dispose();
  }
}
```

Delete the old freezed file since `DetailViewModel` no longer has its own state class:

```bash
rm lib/detail/viewmodels/detail_viewmodel.freezed.dart
```

**Step 2: Rewrite `DetailScreen`**

Replace `lib/detail/screens/detail_screen.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:provider/provider.dart';

import '../../project/repositories/project_data_repository.dart';
import '../interactors/issue_detail_selector.dart';
import '../viewmodels/detail_viewmodel.dart';

class DetailScreen extends StatelessWidget {
  final String issueId;

  const DetailScreen({super.key, required this.issueId});

  @override
  Widget build(BuildContext context) {
    return StateNotifierProvider<DetailViewModel, IssueDetailState>(
      create: (ctx) => DetailViewModel(
        selector: IssueDetailSelector(
          dataRepo: ctx.read<ProjectDataRepository>(),
          issueId: issueId,
        ),
      ),
      child: const _DetailScreenContent(),
    );
  }
}

class _DetailScreenContent extends StatelessWidget {
  const _DetailScreenContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = context.watch<IssueDetailState>();

    return Scaffold(
      appBar: AppBar(
        title: switch (state) {
          IssueDetailLoaded(:final issue) => Text(issue.title),
          _ => const Text('Issue Detail'),
        },
      ),
      body: switch (state) {
        IssueDetailEmpty() || IssueDetailLoading() => const Center(
          child: CircularProgressIndicator(),
        ),
        IssueDetailNotFound() => Center(
          child: Text(
            'Issue not found',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        IssueDetailError(:final message) => Center(
          child: Text('Error: $message'),
        ),
        IssueDetailLoaded(:final issue, :final comments, :final labels, :final dependencies) => Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Card(
              margin: const EdgeInsets.all(24),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(issue.title, style: theme.textTheme.headlineMedium),
                    const SizedBox(height: 8),
                    Chip(label: Text(issue.status)),
                    if (issue.description.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Text(issue.description, style: theme.textTheme.bodyLarge),
                    ],
                    if (labels.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 4,
                        children: labels.map((l) => Chip(label: Text(l.label))).toList(),
                      ),
                    ],
                    const SizedBox(height: 24),
                    Text('Comments (${comments.length})', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    if (comments.isEmpty)
                      Text('No comments yet.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      )
                    else
                      ...comments.map((c) => ListTile(
                        title: Text(c.content),
                        subtitle: Text('${c.author} · ${c.createdAt}'),
                      )),
                  ],
                ),
              ),
            ),
          ),
        ),
      },
    );
  }
}
```

**Step 3: Run analyzer and tests**

```bash
dart analyze lib
flutter test
```

**Step 4: Commit**

```bash
git add -A
git commit -m "refactor: rewrite DetailViewModel + DetailScreen

DetailViewModel consumes IssueDetailSelector.
DetailScreen watches only its ViewModel via sealed state.
Replaces raw addListener pattern with proper domain layer."
```

---

### Task 8: Cleanup and docs

**Files:**
- Modify: `docs/arch/data-flow.md`
- Remove: any dead imports or unused code
- Update: `lib/board/viewmodels/board_viewmodel.dart` (delete old freezed if regenerated)

**Step 1: Remove stale test for old widget_test referencing removed types**

Check `test/widget_test.dart` for references to removed types (`ProjectRepository`, `IssuesRepository`, old `BoardState`, old `DetailState`). Update or remove as needed.

**Step 2: Run full analysis and tests**

```bash
dart analyze lib test
flutter test
```

Expected: zero issues, all tests pass.

**Step 3: Update architecture doc**

Update `docs/arch/data-flow.md` with a new "After" diagram showing the correct three-layer architecture.

**Step 4: Final commit**

```bash
git add -A
git commit -m "chore: cleanup dead code, update architecture docs"
```

**Step 5: Push branch and open PR**

```bash
git checkout -b refactor/predictable-flutter-arch
git push -u origin refactor/predictable-flutter-arch
gh pr create --title "refactor: predictable-flutter architecture (Data → Domain → View)" \
  --body "Applies three-layer architecture following predictable-flutter skill.

## Changes
- Rename IssuesRepository → ProjectDataRepository
- Delete ProjectRepository (selection state → domain layer)
- Add domain layer: ProjectInteractor, BoardSelector, IssueDetailSelector
- Rewrite BoardViewModel + BoardScreen (consume domain layer)
- Rewrite DetailViewModel + DetailScreen (consume domain layer)

Bead: big_top-ivw"
```
