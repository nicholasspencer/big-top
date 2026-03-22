# Refactor to predictable-flutter Architecture

**Bead:** `big_top-ivw`

## Problem

The current architecture has no domain layer. Repositories do double duty as data access AND domain coordination. `IssuesRepository` is misnamed (owns all project data), `ProjectRepository` isn't a repository (just selection state), `BoardViewModel` is anemic, and screens bypass their ViewModels to watch repos directly.

## Architecture

Three layers by longevity (Data → Domain → View), following the predictable-flutter skill:

### Data Layer
- `GitHubApiService` / `GitHubAuthService` — stateless services (unchanged)
- `AuthRepository` — `StateNotifier<AsyncValue<AuthSession>>` (unchanged)
- `ProjectDataRepository` — renamed from `IssuesRepository`, `StateNotifier<AsyncValue<ProjectData>>`

### Domain Layer (new)
- `ProjectInteractor` — holds project selection, coordinates fetch on selection change
- `BoardSelector` — derives board columns from `ProjectDataRepository` state
- `IssueDetailSelector` — derives issue detail data from `ProjectDataRepository` state

### View Layer
- `BoardViewModel` — consumes `ProjectInteractor` + `BoardSelector`, exposes sealed state
- `DetailViewModel` — consumes `IssueDetailSelector`, exposes sealed state
- Screens watch only their ViewModel

## Decisions
- Keep `AsyncValue<T>` (already migrated, works well)
- Single PR with atomic commits per logical change
- `ProjectInteractor` owns both selection state and fetch coordination (option B)
- `IssuesRepository` → `ProjectDataRepository` (rename, not split)
