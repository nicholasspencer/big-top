# AsyncValue + Freezed Migration — Implementation Plan

> **REQUIRED:** Follow the executing-plans skill to implement this plan task-by-task.

**Bead:** `big_top-4pa`
**Goal:** Add AsyncValue sealed type, convert all models and state classes to freezed with json_serializable, update repositories to emit AsyncValue.

**Architecture:** AsyncValue replaces ad-hoc loading/error enums. Freezed generates ==, hashCode, copyWith, fromJson, toJson. Dart pattern matching replaces generated when/map.

**Tech Stack:** freezed, freezed_annotation, json_annotation, json_serializable, build_runner

**Design Doc:** `docs/big_top-4pa/design.md`

---

### Task 1: Add freezed/json_serializable dependencies and build config [`big_top-4pa.2`]

**Files:**
- Modify: `pubspec.yaml`
- Create: `build.yaml`
- Modify: `analysis_options.yaml`

**Step 1: Add dependencies**

```bash
flutter pub add freezed_annotation json_annotation
flutter pub add --dev build_runner freezed json_serializable
```

**Step 2: Create build.yaml**

```yaml
targets:
  $default:
    builders:
      freezed:
        options:
          map: none
          when: none
```

**Step 3: Update analysis_options.yaml**

Add under `analyzer`:
```yaml
analyzer:
  errors:
    invalid_annotation_target: ignore
  exclude:
    - "**/*.freezed.dart"
    - "**/*.g.dart"
```

**Step 4: Verify**

Run: `flutter pub get`
Expected: Resolves successfully

**Step 5: Commit**

```bash
git add -A
git commit -m "chore: add freezed, json_serializable, and build config"
```

---

### Task 2: Add AsyncValue sealed type [`big_top-4pa.3`]

**Files:**
- Create: `lib/core/async_value.dart`

**Step 1: Create lib/core/async_value.dart**

Use the exact implementation Nico provided (the file shared in Slack). It's a `@Freezed(map: FreezedMapOptions.none, when: FreezedWhenOptions.none)` sealed class with four states (none, waiting, active, done), functor `map`, `to*` transitions, `requireData`, `hasData`, `hasError`, and `Stream<AsyncValue<T>>.asyncValueMap` extension.

**Step 2: Run build_runner**

```bash
dart run build_runner build --delete-conflicting-outputs
```

Expected: Generates `lib/core/async_value.freezed.dart`

**Step 3: Verify**

Run: `flutter analyze`
Expected: No issues

**Step 4: Commit**

```bash
git add -A
git commit -m "feat(core): add AsyncValue sealed type"
```

---

### Task 3: Convert domain models to freezed + json_serializable [`big_top-4pa.4`]

Convert all 6 models. Each becomes a `@freezed` class with `@JsonSerializable(fieldRename: FieldRename.snake)`.

**Files:**
- Modify: `lib/models/issue.dart`
- Modify: `lib/models/comment.dart`
- Modify: `lib/models/label.dart`
- Modify: `lib/models/dependency.dart`
- Modify: `lib/models/event.dart`
- Modify: `lib/models/project_data.dart`

**Step 1: Convert Issue**

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'issue.freezed.dart';
part 'issue.g.dart';

@freezed
@JsonSerializable(fieldRename: FieldRename.snake)
class Issue with _$Issue {
  const factory Issue({
    required String id,
    required String title,
    @Default('') String description,
    @Default('open') String status,
    @Default(2) int priority,
    @Default('task') String issueType,
    @Default('') String owner,
    required DateTime createdAt,
    @Default('') String createdBy,
    required DateTime updatedAt,
    @Default([]) List<String> dependencies,
    @Default(0) int dependencyCount,
    @Default(0) int commentCount,
  }) = _Issue;

  factory Issue.fromJson(Map<String, dynamic> json) => _$IssueFromJson(json);
}
```

**Step 2: Convert Comment, Label, Dependency, Event similarly**

Each follows the same pattern. Use `@Default` for optional fields. `@JsonSerializable(fieldRename: FieldRename.snake)` handles snake_case conversion.

For Event's `data` field (`Map<String, dynamic>`): use `@Default({})`.

**Step 3: Convert ProjectData (freezed only, no JSON)**

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

import 'comment.dart';
import 'dependency.dart';
import 'event.dart';
import 'issue.dart';
import 'label.dart';

part 'project_data.freezed.dart';

@freezed
class ProjectData with _$ProjectData {
  const factory ProjectData({
    @Default([]) List<Issue> issues,
    @Default([]) List<Comment> comments,
    @Default([]) List<Label> labels,
    @Default([]) List<Dependency> dependencies,
    @Default([]) List<Event> events,
  }) = _ProjectData;
}
```

**Step 4: Run build_runner**

```bash
dart run build_runner build --delete-conflicting-outputs
```

Expected: Generates `.freezed.dart` and `.g.dart` files for all models

**Step 5: Verify**

Run: `flutter analyze`
Expected: No issues

**Step 6: Update tests**

Tests that construct models should still work (constructors unchanged). Tests that compare models should now pass correctly thanks to generated `==`. Update any test that relied on identity comparison to use value equality.

Run: `flutter test`
Expected: All pass

**Step 7: Commit**

```bash
git add -A
git commit -m "refactor(models): convert all domain models to freezed + json_serializable"
```

---

### Task 4: Create AuthSession model and update AuthRepository [`big_top-4pa.5`]

**Files:**
- Create: `lib/models/auth_session.dart`
- Modify: `lib/repositories/auth_repository.dart`

**Step 1: Create AuthSession**

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_session.freezed.dart';

@freezed
class AuthSession with _$AuthSession {
  const factory AuthSession({
    required String token,
    String? username,
    String? avatarUrl,
  }) = _AuthSession;
}
```

**Step 2: Update AuthRepository**

Change from `StateNotifier<AuthState>` to `StateNotifier<AsyncValue<AuthSession>>`.

```dart
class AuthRepository extends StateNotifier<AsyncValue<AuthSession>> {
  final GitHubAuthService _authService;

  AuthRepository({required GitHubAuthService authService})
      : _authService = authService,
        super(const AsyncValue.none());

  bool get isAuthenticated => state.hasData;

  Future<void> tryRestoreSession() async {
    state = state.toWaiting();
    try {
      final token = await _authService.getSavedToken();
      if (token != null) {
        final user = await _authService.fetchUser(token);
        if (user != null) {
          state = AsyncValue.done(
            data: AuthSession(
              token: token,
              username: user['login'] as String?,
              avatarUrl: user['avatar_url'] as String?,
            ),
          );
          return;
        }
        await _authService.clearToken();
      }
      state = const AsyncValue.none();
    } catch (e, st) {
      state = AsyncValue.done(error: e, stackTrace: st);
    }
  }

  Future<DeviceCodeResponse> startDeviceFlow() async {
    state = state.toWaiting();
    try {
      final deviceCode = await _authService.requestDeviceCode();
      state = state.toActive();
      return deviceCode;
    } catch (e, st) {
      state = AsyncValue.done(error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<bool> pollForToken(DeviceCodeResponse deviceCode) async {
    state = state.toActive();
    try {
      final token = await _authService.pollForToken(deviceCode);
      if (token != null) {
        final user = await _authService.fetchUser(token);
        state = AsyncValue.done(
          data: AuthSession(
            token: token,
            username: user?['login'] as String?,
            avatarUrl: user?['avatar_url'] as String?,
          ),
        );
        return true;
      }
      state = AsyncValue.done(
        error: Exception('Authorization expired or denied'),
      );
      return false;
    } catch (e, st) {
      state = AsyncValue.done(error: e, stackTrace: st);
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.clearToken();
    state = const AsyncValue.none();
  }
}
```

**Step 3: Run build_runner, then verify**

```bash
dart run build_runner build --delete-conflicting-outputs
flutter analyze
```

Expected: May have errors in consumers (AppDependencies, AuthorizedDependencies, screens) — those get fixed in Task 6.

**Step 4: Commit**

```bash
git add -A
git commit -m "refactor(auth): AuthRepository emits AsyncValue<AuthSession>"
```

---

### Task 5: Update IssuesRepository to use AsyncValue<ProjectData> [`big_top-4pa.6`]

**Files:**
- Modify: `lib/repositories/issues_repository.dart`
- Modify: `lib/repositories/project_repository.dart`

**Step 1: Update IssuesRepository**

Replace `StateNotifier<IssuesState>` with `StateNotifier<AsyncValue<ProjectData>>`. Delete `IssuesState` and `IssuesStatus`.

```dart
class IssuesRepository extends StateNotifier<AsyncValue<ProjectData>> {
  final GitHubApiService _apiService;
  final String _token;
  final int _maxRetries;

  IssuesRepository({...})
      : ..., super(const AsyncValue.none());

  Future<void> loadProject({...}) async {
    state = state.toActive(); // preserves previous data during refresh
    try {
      final data = await _fetchWithRetry(...);
      state = AsyncValue.done(data: data);
    } catch (e, st) {
      state = AsyncValue.done(error: e, stackTrace: st, data: state.data);
    }
  }
  // _fetchWithRetry stays the same
}
```

**Step 2: Convert ProjectState to freezed**

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'project_repository.freezed.dart';

@freezed
class ProjectState with _$ProjectState {
  const ProjectState._();

  const factory ProjectState({
    String? owner,
    String? repo,
    String? project,
  }) = _ProjectState;

  bool get isSelected => owner != null && repo != null;
  String get fullName => '$owner/$repo';
}
```

**Step 3: Run build_runner, verify**

```bash
dart run build_runner build --delete-conflicting-outputs
flutter analyze
```

**Step 4: Commit**

```bash
git add -A
git commit -m "refactor(repos): IssuesRepository emits AsyncValue<ProjectData>, ProjectState to freezed"
```

---

### Task 6: Update ViewModels, dependency widgets, screens, and router [`big_top-4pa.7`]

**Files:**
- Modify: `lib/viewmodels/login_viewmodel.dart`
- Modify: `lib/viewmodels/board_viewmodel.dart`
- Modify: `lib/viewmodels/detail_viewmodel.dart`
- Modify: `lib/app/app_dependencies.dart`
- Modify: `lib/app/authorized_dependencies.dart`
- Modify: `lib/app/router.dart`
- Modify: `lib/main.dart`
- Modify: `lib/screens/login_screen.dart`
- Modify: `lib/screens/board_screen.dart`
- Modify: `lib/screens/detail_screen.dart`

**Step 1: Convert LoginState to freezed**

```dart
@freezed
class LoginState with _$LoginState {
  const factory LoginState({
    @Default(false) bool isPolling,
    DeviceCodeResponse? deviceCode,
    String? error,
  }) = _LoginState;
}
```

**Step 2: Convert DetailState to freezed**

```dart
@freezed
class DetailState with _$DetailState {
  const factory DetailState({
    Issue? issue,
    @Default([]) List<Comment> comments,
    @Default([]) List<Label> labels,
    @Default([]) List<Dependency> dependencies,
  }) = _DetailState;
}
```

**Step 3: Update BoardViewModel**

Remove `BoardState` — derive everything from repo states. Or keep minimal freezed state for local UI concerns.

**Step 4: Update DetailViewModel**

Change `_update` to read from `AsyncValue<ProjectData>`:
```dart
void _update(AsyncValue<ProjectData> value) {
  final data = value.data;
  if (data == null) {
    state = const DetailState();
    return;
  }
  state = DetailState(
    issue: data.issues.where((i) => i.id == issueId).firstOrNull,
    comments: data.comments.where((c) => c.issueId == issueId).toList(),
    // ...
  );
}
```

**Step 5: Update AppDependencies**

Change `StateNotifierProvider<AuthRepository, AuthState>` to `StateNotifierProvider<AuthRepository, AsyncValue<AuthSession>>`.

**Step 6: Update AuthorizedDependencies**

```dart
final authValue = context.watch<AsyncValue<AuthSession>>();
if (!authValue.hasData) return child!;
// use authValue.requireData().token
```

Change `StateNotifierProvider<IssuesRepository, IssuesState>` to `StateNotifierProvider<IssuesRepository, AsyncValue<ProjectData>>`.

**Step 7: Update router redirect**

Read `AsyncValue<AuthSession>` instead of `AuthState`.

**Step 8: Update all screens**

Replace `context.watch<AuthState>()` with `context.watch<AsyncValue<AuthSession>>()`. Replace `context.watch<IssuesState>()` with `context.watch<AsyncValue<ProjectData>>()`. Use `.select` where appropriate.

**Step 9: Run build_runner**

```bash
dart run build_runner build --delete-conflicting-outputs
```

**Step 10: Verify**

Run: `flutter analyze && flutter test && flutter build web`
Expected: All pass

**Step 11: Commit**

```bash
git add -A
git commit -m "refactor: update ViewModels, DI, and screens for AsyncValue + freezed"
```

---

### Task 7: Update tests [`big_top-4pa.8`]

**Files:**
- Modify: `test/repositories/auth_repository_test.dart`
- Modify: `test/repositories/issues_repository_test.dart`
- Modify: `test/repositories/project_repository_test.dart`
- Modify: `test/services/github_api_service_test.dart`
- Modify: `test/widget_test.dart`

**Step 1: Update auth repo tests**

Test against `AsyncValue<AuthSession>` states instead of `AuthState`. Verify state transitions: `none → waiting → done(data: ...)` for success, `none → waiting → done(error: ...)` for failure, `done → none` for logout.

**Step 2: Update issues repo tests**

Test against `AsyncValue<ProjectData>`. Verify: `none → active → done(data: ...)` for load, `done → active → done(data: ...)` for refresh (preserves previous data during active).

**Step 3: Update project repo tests**

ProjectState is now freezed — equality should just work. Minimal changes.

**Step 4: Update widget test**

Stub providers with `AsyncValue<AuthSession>` and `AsyncValue<ProjectData>`.

**Step 5: Add AsyncValue unit tests**

Create `test/core/async_value_test.dart`:
- Test `map` preserves state variant
- Test `map` with nullable type parameter
- Test `to*` transitions carry forward data/error
- Test `requireData` throws on no data
- Test `hasData`/`hasError`
- Test stream extension `asyncValueMap`

**Step 6: Verify**

Run: `flutter analyze && flutter test && flutter build web`
Expected: All pass

**Step 7: Commit**

```bash
git add -A
git commit -m "test: update all tests for AsyncValue + freezed migration"
```

---

### Task 8: Cleanup [`big_top-4pa.9`]

**Files:**
- Delete any leftover hand-written `copyWith`, `==`, `hashCode` methods
- Ensure `.gitignore` includes `*.freezed.dart` and `*.g.dart` (or doesn't — depends on preference)

**Step 1: Verify no old patterns remain**

```bash
grep -rn "operator ==" lib/models/ lib/repositories/ lib/viewmodels/
grep -rn "hashCode" lib/models/ lib/repositories/ lib/viewmodels/
```

Expected: Only in generated files

**Step 2: Decide on generated files in git**

Generated `.freezed.dart` and `.g.dart` files — commit them or gitignore? Committing means CI doesn't need build_runner. Gitignoring keeps the repo clean but requires build step.

Recommend: **commit them** for a web app (no pub publish concerns).

**Step 3: Final verification**

Run: `flutter analyze && flutter test && flutter build web`
Expected: All green

**Step 4: Commit**

```bash
git add -A
git commit -m "chore: cleanup after AsyncValue + freezed migration"
```

---

## Execution Notes

- **Branch:** Stack on top of design doc branch using `git rebase --update-refs`
- **PR policy:** Push branch, create PR, wait for review. Do NOT merge.
- **Build runner:** Must run `dart run build_runner build --delete-conflicting-outputs` after each task that adds/modifies freezed classes
- **Task dependencies:** Tasks 1-2 independent. Task 3 needs 1. Tasks 4-5 need 2-3. Task 6 needs 4-5. Task 7 needs 6. Task 8 is cleanup.
