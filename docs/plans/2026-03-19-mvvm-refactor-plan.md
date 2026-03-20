# MVVM Architecture Refactor — Implementation Plan

> **REQUIRED:** Follow the executing-plans skill to implement this plan task-by-task.

**Goal:** Refactor from flat providers/ layer into proper Services → Repositories → ViewModels → Views architecture per the design doc.

**Architecture:** `AppDependencies` and `AuthorizedDependencies` as `SingleChildStatelessWidget` peers in `MultiProvider`. Repositories and ViewModels are `StateNotifier` subclasses. Services are stateless. Retry/resilience moves from services to repositories.

**Tech Stack:** Flutter, provider, state_notifier, flutter_state_notifier, go_router

**Design Doc:** `docs/plans/2026-03-19-mvvm-architecture-design.md`

---

### Task 1: Strip retry logic from GitHubApiService

The service should be a dumb HTTP wrapper. Retry/resilience belongs in repositories.

**Files:**
- Modify: `lib/services/github_api_service.dart`
- Modify: `test/services/github_api_service_test.dart`

**Step 1: Simplify GitHubApiService**

Remove `_getWithRetry()`, `_maxRetries`, `GitHubRateLimitException`, `GitHubNotFoundException`, and `ProjectData` from the service. The service does raw HTTP calls — it returns responses or throws `http.ClientException`. Repositories will handle retry, rate limiting, and typed exceptions.

Replace `_getWithRetry` with a plain `_get`:

```dart
Future<http.Response> _get(Uri uri, Map<String, String> headers) async {
  return _client.get(uri, headers: headers);
}
```

Replace `_checkResponse` to just throw on non-200 without typed exceptions (repos handle classification):

```dart
void _checkResponse(http.Response response, String path) {
  if (response.statusCode == 200) return;
  throw HttpException(response.statusCode, path, response.body);
}
```

Add a simple `HttpException`:

```dart
class HttpException implements Exception {
  final int statusCode;
  final String path;
  final String body;
  const HttpException(this.statusCode, this.path, this.body);

  @override
  String toString() => 'HTTP $statusCode for $path';
}
```

Keep `ProjectData` class but move it to `lib/models/project_data.dart` since it's a domain model.

**Step 2: Update tests**

Remove retry-related tests (retries on 500, retries on ClientException, max retries). Update remaining tests to work without retry wrapper. Tests should verify the service returns data on 200 and throws `HttpException` on errors.

**Step 3: Run verification**

Run: `flutter analyze && flutter test`
Expected: All pass

**Step 4: Commit**

```bash
git add -A
git commit -m "refactor(services): strip retry logic from GitHubApiService"
```

---

### Task 2: Create AuthRepository

Extract auth logic from `AuthProvider` into a proper repository.

**Files:**
- Create: `lib/repositories/auth_repository.dart`
- Test: `test/repositories/auth_repository_test.dart`

**Step 1: Write AuthRepository test**

Test session restore (saved token → authenticated state), device flow start, token polling success/failure, and logout. Use a mock `GitHubAuthService`.

**Step 2: Run test — verify it fails**

Run: `flutter test test/repositories/auth_repository_test.dart`
Expected: FAIL (file doesn't exist yet for the import)

**Step 3: Implement AuthRepository**

```dart
@immutable
class AuthState {
  final bool isLoading;
  final String? token;
  final String? username;
  final String? avatarUrl;
  final String? error;

  const AuthState({...});
  bool get isAuthenticated => token != null;
  AuthState copyWith({...});
}

class AuthRepository extends StateNotifier<AuthState> {
  final GitHubAuthService _authService;

  AuthRepository({required GitHubAuthService authService})
      : _authService = authService,
        super(const AuthState());

  Future<void> tryRestoreSession() async { ... }
  Future<DeviceCodeResponse> startDeviceFlow() async { ... }
  Future<bool> pollForToken(DeviceCodeResponse deviceCode) async { ... }
  Future<void> logout() async { ... }
}
```

This is essentially the same logic as `AuthProvider` — same state class, same methods. The rename signals the architectural role.

**Step 4: Run test — verify it passes**

Run: `flutter test test/repositories/auth_repository_test.dart`
Expected: PASS

**Step 5: Commit**

```bash
git add -A
git commit -m "feat(repositories): create AuthRepository from AuthProvider"
```

---

### Task 3: Create IssuesRepository with retry/resilience

Extract issues data management into a repository that owns retry, caching, and error handling.

**Files:**
- Create: `lib/repositories/issues_repository.dart`
- Create: `lib/models/project_data.dart` (moved from service)
- Test: `test/repositories/issues_repository_test.dart`

**Step 1: Create ProjectData model file**

Move `ProjectData` class from `github_api_service.dart` to its own model file.

**Step 2: Write IssuesRepository test**

Test: loading issues, caching (second call returns cached data without API hit), retry on transient failure, rate limit detection, error state emission.

**Step 3: Implement IssuesRepository**

```dart
enum IssuesStatus { initial, loading, loaded, error }

@immutable
class IssuesState {
  final IssuesStatus status;
  final List<Issue> issues;
  final List<Comment> comments;
  final List<Label> labels;
  final List<Dependency> dependencies;
  final String? error;

  const IssuesState({...});
  IssuesState copyWith({...});

  List<Issue> byStatus(String statusFilter) =>
      issues.where((i) => i.status == statusFilter).toList();
}

class IssuesRepository extends StateNotifier<IssuesState> {
  final GitHubApiService _apiService;
  final String _token;
  final int _maxRetries;

  IssuesRepository({
    required GitHubApiService apiService,
    required String token,
    int maxRetries = 3,
  }) : _apiService = apiService,
       _token = token,
       _maxRetries = maxRetries,
       super(const IssuesState());

  /// Load all data for a project. Retry on transient failures.
  Future<void> loadProject({
    required String owner,
    required String repo,
    required String project,
  }) async {
    state = state.copyWith(status: IssuesStatus.loading);
    try {
      final data = await _fetchWithRetry(() =>
        _apiService.fetchAllProjectData(
          token: _token, owner: owner, repo: repo, project: project,
        ),
      );
      state = state.copyWith(
        status: IssuesStatus.loaded,
        issues: data.issues,
        comments: data.comments,
        labels: data.labels,
        dependencies: data.dependencies,
      );
    } catch (e) {
      state = state.copyWith(status: IssuesStatus.error, error: e.toString());
    }
  }

  /// Retry with exponential backoff for transient errors.
  Future<T> _fetchWithRetry<T>(Future<T> Function() fn) async {
    for (var attempt = 0; attempt <= _maxRetries; attempt++) {
      try {
        return await fn();
      } on HttpException catch (e) {
        if (e.statusCode >= 500 && attempt < _maxRetries) {
          await Future<void>.delayed(Duration(milliseconds: 500 * (1 << attempt)));
          continue;
        }
        rethrow;
      } on http.ClientException {
        if (attempt >= _maxRetries) rethrow;
        await Future<void>.delayed(Duration(milliseconds: 500 * (1 << attempt)));
      }
    }
    throw StateError('Retry loop exited unexpectedly');
  }
}
```

**Step 4: Run tests — verify passing**

Run: `flutter analyze && flutter test`
Expected: PASS

**Step 5: Commit**

```bash
git add -A
git commit -m "feat(repositories): create IssuesRepository with retry and caching"
```

---

### Task 4: Create ProjectRepository

**Files:**
- Create: `lib/repositories/project_repository.dart`
- Test: `test/repositories/project_repository_test.dart`

**Step 1: Write test**

Test: select project emits new state, clear resets to initial.

**Step 2: Implement ProjectRepository**

```dart
@immutable
class ProjectState {
  final String? owner;
  final String? repo;
  final String? project;

  const ProjectState({this.owner, this.repo, this.project});
  bool get isSelected => owner != null && repo != null;
  String get fullName => '$owner/$repo';
  ProjectState copyWith({...});
}

class ProjectRepository extends StateNotifier<ProjectState> {
  ProjectRepository() : super(const ProjectState());

  void selectProject({required String owner, required String repo, String? project}) {
    state = ProjectState(owner: owner, repo: repo, project: project);
  }

  void clear() {
    state = const ProjectState();
  }
}
```

**Step 3: Run tests — verify passing**

**Step 4: Commit**

```bash
git add -A
git commit -m "feat(repositories): create ProjectRepository"
```

---

### Task 5: Create AppDependencies and AuthorizedDependencies

**Files:**
- Create: `lib/app/app_dependencies.dart`
- Create: `lib/app/authorized_dependencies.dart`

**Step 1: Implement AppDependencies**

```dart
class AppDependencies extends SingleChildStatelessWidget {
  const AppDependencies({super.key, super.child});

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return MultiProvider(
      providers: [
        Provider<GitHubAuthService>(create: (_) => GitHubAuthService()),
        Provider<GitHubApiService>(create: (_) => GitHubApiService()),
        StateNotifierProvider<AuthRepository, AuthState>(
          create: (ctx) => AuthRepository(
            authService: ctx.read<GitHubAuthService>(),
          )..tryRestoreSession(),
        ),
      ],
      child: child!,
    );
  }
}
```

**Step 2: Implement AuthorizedDependencies**

```dart
class AuthorizedDependencies extends SingleChildStatelessWidget {
  const AuthorizedDependencies({super.key, super.child});

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    final authState = context.watch<AuthState>();

    if (!authState.isAuthenticated) return child!;

    return MultiProvider(
      providers: [
        StateNotifierProvider<IssuesRepository, IssuesState>(
          create: (ctx) => IssuesRepository(
            apiService: ctx.read<GitHubApiService>(),
            token: authState.token!,
          ),
        ),
        StateNotifierProvider<ProjectRepository, ProjectState>(
          create: (_) => ProjectRepository(),
        ),
      ],
      child: child!,
    );
  }
}
```

**Step 3: Run `flutter analyze`**

Expected: PASS (screens still reference old providers — that's fine, we'll fix in Task 7)

**Step 4: Commit**

```bash
git add -A
git commit -m "feat(app): create AppDependencies and AuthorizedDependencies"
```

---

### Task 6: Create ViewModels

**Files:**
- Create: `lib/viewmodels/login_viewmodel.dart`
- Create: `lib/viewmodels/board_viewmodel.dart`
- Create: `lib/viewmodels/detail_viewmodel.dart`

**Step 1: Implement LoginViewModel**

Consumes `AuthRepository`. Manages device flow UI state (user code, polling, errors). Commands: `startLogin()`, `cancelLogin()`.

```dart
@immutable
class LoginState {
  final bool isPolling;
  final DeviceCodeResponse? deviceCode;
  final String? error;

  const LoginState({this.isPolling = false, this.deviceCode, this.error});
  LoginState copyWith({...});
}

class LoginViewModel extends StateNotifier<LoginState> {
  final AuthRepository _authRepo;

  LoginViewModel({required AuthRepository authRepo})
      : _authRepo = authRepo,
        super(const LoginState());

  Future<void> startLogin() async { ... }
  void cancelLogin() { ... }
}
```

**Step 2: Implement BoardViewModel**

Consumes `IssuesRepository` and `ProjectRepository`. Provides filtered/grouped issues for kanban columns. Commands: `refresh()`, `selectProject()`.

**Step 3: Implement DetailViewModel**

Consumes `IssuesRepository`. Provides single issue with its comments, labels, dependencies. Commands: `addComment()` (triggers workflow dispatch via service).

**Step 4: Run `flutter analyze`**

Expected: PASS

**Step 5: Commit**

```bash
git add -A
git commit -m "feat(viewmodels): create Login, Board, and Detail ViewModels"
```

---

### Task 7: Rewire screens and main.dart

**Files:**
- Modify: `lib/main.dart`
- Modify: `lib/app/router.dart`
- Modify: `lib/screens/login_screen.dart`
- Modify: `lib/screens/board_screen.dart`
- Modify: `lib/screens/detail_screen.dart`

**Step 1: Rewrite main.dart**

```dart
void main() {
  runApp(const BigTopApp());
}

class BigTopApp extends StatelessWidget {
  const BigTopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        AppDependencies(),
        AuthorizedDependencies(),
      ],
      child: const _BigTopRouter(),
    );
  }
}

class _BigTopRouter extends StatelessWidget {
  const _BigTopRouter();

  @override
  Widget build(BuildContext context) {
    // Watch auth state so router refreshes on auth changes
    context.watch<AuthState>();

    return MaterialApp.router(
      title: 'Big Top',
      theme: BigTopTheme.light,
      darkTheme: BigTopTheme.dark,
      themeMode: ThemeMode.dark,
      routerConfig: createRouter(context),
      debugShowCheckedModeBanner: false,
    );
  }
}
```

**Step 2: Update router to use AuthRepository**

Update `createRouter` to accept `BuildContext` and read `AuthRepository` state for redirect logic. Wire `refreshListenable` if possible (may need a `ValueNotifier` adapter since `StateNotifier` isn't `Listenable`).

**Step 3: Rewire LoginScreen**

- Remove local `_deviceCode`, `_polling`, `_error` state — LoginViewModel manages this
- Inject LoginViewModel at the route level (or as a wrapping StatefulWidget)
- Use `.watch<LoginState>()` and `.select` for surgical rebuilds
- Read `AuthRepository` for auth actions via callbacks

**Step 4: Rewire BoardScreen**

- Remove `context.watch<AuthState>()` for user info — use `.select` for just username/avatar
- Inject BoardViewModel
- Use `.watch<IssuesState>()` or `.select` for issues by status

**Step 5: Rewire DetailScreen**

- Inject DetailViewModel with issueId
- Use `.watch<DetailState>()` for issue data

**Step 6: Run full verification**

Run: `flutter analyze && flutter test && flutter build web`
Expected: All pass

**Step 7: Commit**

```bash
git add -A
git commit -m "refactor: rewire screens and main.dart to MVVM architecture"
```

---

### Task 8: Delete old providers/ directory

**Files:**
- Delete: `lib/providers/auth_provider.dart`
- Delete: `lib/providers/issues_provider.dart`
- Delete: `lib/providers/project_provider.dart`
- Delete: `lib/providers/` directory

**Step 1: Verify no remaining imports**

Run: `grep -r "providers/" lib/ test/`
Expected: No matches

**Step 2: Delete**

```bash
rm -rf lib/providers/
```

**Step 3: Run full verification**

Run: `flutter analyze && flutter test && flutter build web`
Expected: All pass

**Step 4: Commit**

```bash
git add -A
git commit -m "chore: remove old providers/ directory"
```

---

### Task 9: Update widget test

**Files:**
- Modify: `test/widget_test.dart`

**Step 1: Update test to work with new DI**

The widget test needs to provide mock services/repos since `AppDependencies` creates real ones. Either mock at the service level or test the app with stubbed providers.

**Step 2: Run full verification**

Run: `flutter analyze && flutter test && flutter build web`
Expected: All pass — this is the final gate.

**Step 3: Final commit**

```bash
git add -A
git commit -m "test: update widget test for MVVM architecture"
```

---

## Execution Notes

- **Branch:** `refactor/mvvm-architecture`
- **PR policy:** Push branch, create PR, wait for Nico's review. Do NOT merge.
- **Tasks 1-4** are independent (service cleanup + 3 repos) and could be parallelized
- **Task 5** depends on Tasks 2-4 (needs repo classes to exist)
- **Tasks 6-7** depend on Task 5 (needs DI wiring)
- **Tasks 8-9** are cleanup after everything else works
