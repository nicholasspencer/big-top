# AsyncValue + Freezed Migration — Design Document

**Date:** 2026-03-19
**Status:** Draft
**Author:** Chad + Nico

---

## Problem

All models and state classes use hand-written `==`/`hashCode`/`copyWith`/`fromJson`. This is error-prone, verbose, and doesn't give us correct equality for collections. Repositories use ad-hoc `IssuesStatus` enums and `isLoading`/`error` fields to express async state — there's no unified way to represent loading/error/data across the app.

## Changes

### 1. Add `AsyncValue<T>` sealed type

Nico's implementation — a freezed sealed class mirroring `ConnectionState` with four states:
- `AsyncValue.none()` — no interaction yet
- `AsyncValue.waiting()` — hasn't started / restoring
- `AsyncValue.active()` — ongoing (streams, refreshes)
- `AsyncValue.done()` — completed

Each state carries optional `data`, `error`, `stackTrace`. Key features:
- Functor `map<TT>()` — transforms inner value, preserves async state
- `to*()` transitions — carry forward existing data/error by default
- `requireData()` — throws if no data
- `Stream<AsyncValue<T>>.asyncValueMap()` extension

File: `lib/core/async_value.dart` (+ generated `.freezed.dart`)

### 2. Convert all models to freezed + json_serializable

Every model becomes a `@freezed` class with `@JsonSerializable(fieldRename: FieldRename.snake)`. Freezed generates `==`, `hashCode`, `copyWith`, `toString`. json_serializable generates `fromJson`/`toJson`.

Disable `when` and `map` on all freezed classes (use Dart pattern matching instead). Configure globally via `build.yaml`:

```yaml
targets:
  $default:
    builders:
      freezed:
        options:
          map: none
          when: none
```

**Models to convert:**
- `Issue` — 13 fields, snake_case JSON
- `Comment` — 5 fields
- `Label` — 2 fields
- `Dependency` — 6 fields
- `Event` — 6 fields (note: `data` field is `Map<String, dynamic>`)
- `ProjectData` — 5 list fields (no JSON serialization, just freezed)

### 3. Convert state classes to freezed

- `AuthState` → **removed**, replaced by `AsyncValue<AuthSession>` where `AuthSession` is a freezed class holding `token`, `username`, `avatarUrl`
- `IssuesState` → **removed**, replaced by `AsyncValue<ProjectData>` (already have `ProjectData` model)
- `ProjectState` → freezed class (keeps `owner`, `repo`, `project`)
- `LoginState` → freezed class (keeps `isPolling`, `deviceCode`, `error`)
- `BoardState` → **removed**, board derives state from `AsyncValue<ProjectData>` and `ProjectState`
- `DetailState` → freezed class (keeps `issue`, `comments`, `labels`, `dependencies`)

### 4. Update repositories to use `AsyncValue`

**AuthRepository:**
```dart
class AuthRepository extends StateNotifier<AsyncValue<AuthSession>> {
  AuthRepository(...) : super(const AsyncValue.none());

  Future<void> tryRestoreSession() async {
    state = state.toWaiting();
    try {
      final token = await _authService.getSavedToken();
      // ...validate...
      state = AsyncValue.done(data: AuthSession(token: token, ...));
    } catch (e, st) {
      state = AsyncValue.done(error: e, stackTrace: st);
    }
  }

  Future<void> logout() async {
    await _authService.clearToken();
    state = const AsyncValue.none();
  }
}
```

- `isAuthenticated` → `state.hasData`
- `state.token` → `state.data?.token`

**IssuesRepository:**
```dart
class IssuesRepository extends StateNotifier<AsyncValue<ProjectData>> {
  IssuesRepository(...) : super(const AsyncValue.none());

  Future<void> loadProject(...) async {
    state = state.toActive(); // preserves previous data during refresh
    try {
      final data = await _fetchWithRetry(...);
      state = AsyncValue.done(data: data);
    } catch (e, st) {
      state = AsyncValue.done(error: e, stackTrace: st);
    }
  }
}
```

- `IssuesStatus` enum → **deleted**
- `state.issues` → `state.data?.issues ?? []`
- `byStatus()` helper moves to a getter on `ProjectData` or the ViewModel

**ProjectRepository:** stays mostly the same, `ProjectState` becomes freezed.

### 5. Update ViewModels

**BoardViewModel:**
- Watches `AsyncValue<ProjectData>` from `IssuesRepository`
- No more `BoardState` — the VM can derive everything from the repo states
- Or keep a minimal freezed `BoardState` if it needs local UI state (e.g., selected filter)

**DetailViewModel:**
- `_update` reads from `AsyncValue<ProjectData>` instead of `IssuesState`
- `DetailState` becomes freezed

**LoginViewModel:**
- `LoginState` becomes freezed
- Reads `AsyncValue<AuthSession>` for auth transitions

### 6. Update AuthorizedDependencies

```dart
final authValue = context.watch<AsyncValue<AuthSession>>();
if (!authValue.hasData) return child!;
// auth-scoped repos created with authValue.requireData().token
```

### 7. Update router redirect

```dart
redirect: (context, state) {
  final authValue = context.read<AsyncValue<AuthSession>>();
  final authed = authValue.hasData;
  // ...
}
```

## Dependencies to Add

```yaml
dependencies:
  freezed_annotation: ^3.0.0
  json_annotation: ^4.9.0

dev_dependencies:
  build_runner: ^2.4.0
  freezed: ^3.0.0
  json_serializable: ^6.9.0
```

## Build Configuration

`build.yaml` at project root:
```yaml
targets:
  $default:
    builders:
      freezed:
        options:
          map: none
          when: none
```

## File Structure Changes

```
lib/
  core/
    async_value.dart          # NEW — AsyncValue sealed type
    async_value.freezed.dart  # generated
  models/
    auth_session.dart         # NEW — freezed, replaces AuthState
    comment.dart              # converted to freezed + json_serializable
    dependency.dart           # converted
    event.dart                # converted
    issue.dart                # converted
    label.dart                # converted
    project_data.dart         # converted to freezed (no JSON)
  repositories/
    auth_repository.dart      # AsyncValue<AuthSession>
    issues_repository.dart    # AsyncValue<ProjectData>
    project_repository.dart   # freezed ProjectState
  viewmodels/
    login_viewmodel.dart      # freezed LoginState
    board_viewmodel.dart      # simplified, derives from repo states
    detail_viewmodel.dart     # freezed DetailState
```

## What Gets Deleted

- `IssuesStatus` enum
- `AuthState` class (replaced by `AsyncValue<AuthSession>`)
- `IssuesState` class (replaced by `AsyncValue<ProjectData>`)
- `BoardState` class (derived from repo states)
- All hand-written `copyWith`, `fromJson`, `toJson`, `==`, `hashCode`
