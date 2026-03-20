# MVVM Architecture Refactor — Design Document

**Date:** 2026-03-19
**Status:** Draft
**Author:** Chad + Nico

---

## Problem

The current codebase has `AuthProvider`, `IssuesProvider`, and `ProjectProvider` — StateNotifiers that mix data fetching, business logic, caching, and UI state into a single layer. This violates separation of concerns and doesn't follow the [Flutter app architecture guide](https://docs.flutter.dev/app-architecture/guide).

## Architecture

```
Services → Repositories (StateNotifier) → ViewModels (StateNotifier) → Views
```

### Services (`lib/services/`)

Stateless API wrappers. One per data source. No retry logic, no caching, no error classification. They make HTTP calls and return raw data or throw.

- `GitHubAuthService` — Device Flow HTTP calls, token CRUD via SharedPreferences
- `GitHubApiService` — raw GitHub REST API calls (Contents API, workflow dispatch)

### Repositories (`lib/repositories/`)

`StateNotifier<T>` subclasses. Observable. Source of truth for domain data. Own all resilience logic: retry, caching, error handling, rate limiting.

- `AuthRepository extends StateNotifier<AuthState>` — token lifecycle, session restore, device flow orchestration, user info
- `IssuesRepository extends StateNotifier<IssuesState>` — fetch/cache JSONL data, retry with backoff, rate limit handling
- `ProjectRepository extends StateNotifier<ProjectState>` — selected project persistence

**Graceful degradation:** If a dependency isn't available, do the best thing possible. If the dependency is necessary and missing, that's a state error.

### ViewModels (`lib/viewmodels/`)

`StateNotifier<T>` subclasses. UI state only. 1:1 instance parity with their view. Consume repositories. Expose commands (methods) for user actions.

- `LoginViewModel` — device flow UI state, commands: `startLogin()`, `cancelLogin()`
- `BoardViewModel` — issue filtering/grouping for kanban, commands: `refresh()`, `selectProject()`
- `DetailViewModel` — single issue with comments/labels/deps, commands: `addComment()`

Implementation can be 1:N (one ViewModel class serving multiple view types), but each view instance gets its own ViewModel instance.

### Views (`lib/screens/`, `lib/widgets/`)

Widgets. No business logic.

## Dependency Injection

### Widget Tree as DI Container

Dependencies are provided via the widget tree using `SingleChildStatelessWidget` subclasses from the `provider` package. No singletons. Ever.

```dart
// main.dart
class BigTopApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        AppDependencies(),
        AuthorizedDependencies(),
      ],
      child: MaterialApp.router(...),
    );
  }
}
```

### AppDependencies (`lib/app/app_dependencies.dart`)

`SingleChildStatelessWidget`. Provides globally available dependencies:

- `Provider<GitHubAuthService>`
- `Provider<GitHubApiService>`
- `StateNotifierProvider<AuthRepository, AuthState>`

### AuthorizedDependencies (`lib/app/authorized_dependencies.dart`)

`SingleChildStatelessWidget`. Watches `AuthState`. When authenticated, builds a `MultiProvider` with auth-scoped repos. When not, passes child through.

```dart
class AuthorizedDependencies extends SingleChildStatelessWidget {
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

When auth state flips to unauthenticated, the inner `MultiProvider` is removed from the tree → repos are disposed automatically by the framework. No manual teardown.

### Dependency Scoping Rules

- **Services:** Always available (above router)
- **Repositories:** Scoped to auth state. Exist only when authenticated. Accessing them from an unauthenticated route is a state error (`ProviderNotFoundException`).
- **ViewModels:** Scoped to their view. Created at the route/screen level.

### Reference Types vs Value Types

- Reference types (repositories, services) are always provided with nullable generic types when the provider may not be available
- Value types (theme mode, locale) always have reasonable defaults
- If a reference type is `null` or not in the tree when accessed, and the consumer requires it — that's a state error (routing bug), not a runtime error to handle

## Navigation

`GoRouter` with `refreshListenable` wired to `AuthRepository`. The router re-evaluates `redirect` whenever auth state changes.

- Authenticated → routes to board/detail screens (where auth-scoped repos exist)
- Unauthenticated → redirects to login (where repos aren't needed)

The router is the auth boundary enforcement. `AuthorizedDependencies` handles repo lifecycle.

## Widget Composition Pattern

### All widgets start stateless.

```dart
class IssueCard extends StatelessWidget {
  final Issue issue;
  final VoidCallback? onTap;
  // Pure render. No logic.
}
```

### StatefulWidget only when local state/controllers are required.

Controllers, component-level view models, and animation controllers live in `State`. Reasonable defaults are fine. Parameters and callbacks get passed to the controller constructor or the stateless child.

```dart
class IssueEditor extends StatefulWidget { ... }
class _IssueEditorState extends State<IssueEditor> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialTitle);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => IssueEditorView(controller: _controller);
}
```

### Widgets that `.watch` or `.select` wrap the above when context data needs injection.

```dart
class BoardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final issues = context.select<IssuesState, List<Issue>>(
      (state) => state.issues,
    );
    return BoardView(issues: issues);
  }
}
```

### Observability is mandatory.

State **must** be observed — via `.watch`, `.select`, or `Consumer` in the widget tree. No `ChangeNotifier.addListener` where consumers have to diff what changed themselves.

`StateNotifier.addListener` **is** valid — the callback receives the new state value, so consumers know exactly what changed. Use it for non-widget observation: repos reacting to auth state, ViewModels triggering side effects on state transitions, etc.

`context.read` is fine outside the build phase (e.g., in callbacks).

## Service Resilience

Services are dumb wrappers. All resilience logic lives in repositories:

- **Retry with backoff** — repos retry transient failures (5xx, network errors)
- **Rate limiting** — repos check `X-RateLimit-Remaining` and back off
- **Caching** — repos hold last-known-good data and serve it during failures
- **Error states** — repos emit typed error states that views can render
- **Graceful degradation** — if a dependency isn't available, do the best thing possible. If it's necessary, it's a state error.

## File Structure After Refactor

```
lib/
  app/
    app_dependencies.dart        # Global DI
    authorized_dependencies.dart # Auth-scoped DI
    router.dart
    theme.dart
  models/
    issue.dart
    comment.dart
    label.dart
    dependency.dart
    event.dart
  repositories/
    auth_repository.dart
    issues_repository.dart
    project_repository.dart
  services/
    github_api_service.dart
    github_auth_service.dart
  viewmodels/
    login_viewmodel.dart
    board_viewmodel.dart
    detail_viewmodel.dart
  screens/
    board_screen.dart
    detail_screen.dart
    login_screen.dart
  widgets/
    issue_card.dart
    status_column.dart
  main.dart
```

## What Gets Deleted

- `lib/providers/auth_provider.dart` → replaced by `repositories/auth_repository.dart` + `viewmodels/login_viewmodel.dart`
- `lib/providers/issues_provider.dart` → replaced by `repositories/issues_repository.dart` + `viewmodels/board_viewmodel.dart`
- `lib/providers/project_provider.dart` → replaced by `repositories/project_repository.dart`
- `lib/providers/` directory removed entirely
