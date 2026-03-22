# Big Top — Architecture: Data Flow

## Architecture (predictable-flutter)

Three layers organized by longevity. Dependencies point down (view → domain → data).

```mermaid
graph TB
    subgraph View["View Layer (shortest lived)"]
        LoginScreen --> LoginVM[LoginViewModel]
        BoardScreen --> BoardVM[BoardViewModel]
        DetailScreen --> DetailVM[DetailViewModel]
    end

    subgraph Domain["Domain Layer (mid longevity)"]
        ProjectInt[ProjectInteractor]
        BoardSel[BoardSelector]
        DetailSel[IssueDetailSelector]
    end

    subgraph Data["Data Layer (longest lived)"]
        AuthRepo[AuthRepository]
        DataRepo[ProjectDataRepository]
        AuthSvc[GitHubAuthService]
        ApiSvc[GitHubApiService]
    end

    LoginVM --> AuthRepo
    BoardVM --> ProjectInt
    BoardVM --> BoardSel
    DetailVM --> DetailSel

    ProjectInt --> DataRepo
    BoardSel --> DataRepo
    DetailSel --> DataRepo

    AuthRepo --> AuthSvc
    DataRepo --> ApiSvc
```

## Provider Tree

```mermaid
graph TD
    subgraph AppDeps["AppDependencies (always)"]
        AuthSvc[GitHubAuthService]
        ApiSvc[GitHubApiService]
        AuthRepo["AuthRepository\n↳ AsyncValue&lt;AuthSession&gt;"]
    end

    subgraph AuthDeps["AuthorizedDependencies (when authed)"]
        DataRepo["ProjectDataRepository\n↳ AsyncValue&lt;ProjectData&gt;"]
        ProjectInt["ProjectInteractor\n↳ ProjectInteractorState"]
        BoardSel["BoardSelector\n↳ BoardSelectorState"]
    end

    subgraph ViewScoped["View-scoped (per screen)"]
        BoardVM["BoardViewModel\n↳ BoardState"]
        DetailVM["DetailViewModel\n↳ IssueDetailState"]
        LoginVM["LoginViewModel\n↳ LoginState"]
    end

    AuthSvc --> AuthRepo
    ApiSvc --> DataRepo
    DataRepo --> ProjectInt
    DataRepo --> BoardSel
    ProjectInt --> BoardVM
    BoardSel --> BoardVM
    DataRepo --> DetailVM
    AuthRepo --> LoginVM
```

## Data Flow: Board

```mermaid
sequenceDiagram
    participant BS as BoardScreen
    participant BVM as BoardViewModel
    participant PI as ProjectInteractor
    participant BSel as BoardSelector
    participant PDR as ProjectDataRepository
    participant API as GitHubApiService

    BS->>BVM: selectProject(owner, repo)
    BVM->>PI: selectProject(owner, repo)
    PI->>PI: Update selection state
    PI->>PDR: loadProject(owner, repo, project)
    PDR->>API: fetchAllProjectData()
    API-->>PDR: ProjectData
    PDR-->>PDR: state = AsyncValue.done(data)
    PDR-->>PI: _onDataChanged → state.data updated
    PDR-->>BSel: _recompute → group issues by status
    BSel-->>BVM: _onBoardChanged → BoardState.loaded(columns)
    BVM-->>BS: rebuilds with column data
```

## Dependency Rules

| Component | Can depend on | Cannot depend on |
|-----------|--------------|-----------------|
| Service | External packages, platform APIs | Anything internal |
| Repository | Services it wraps | Other repos, domain, view |
| Interactor/Selector | Repo state (read), repo methods (mutate), services | Other domain observables |
| ViewModel | Interactors, selectors, repositories | Services directly |
| View | Its ViewModel | Everything else |

## File Structure

```
lib/
├── app/                    ← DI wiring, router, theme
├── core/                   ← AsyncValue, shared primitives
├── auth/
│   ├── models/             ← AuthSession
│   ├── repositories/       ← AuthRepository
│   ├── services/           ← GitHubAuthService
│   ├── viewmodels/         ← LoginViewModel
│   └── screens/            ← LoginScreen
├── board/
│   ├── interactors/        ← BoardSelector
│   ├── viewmodels/         ← BoardViewModel
│   ├── screens/            ← BoardScreen
│   └── widgets/            ← IssueCard, StatusColumn
├── project/
│   ├── models/             ← ProjectData, Issue, Comment, Label, Dependency, Event
│   ├── repositories/       ← ProjectDataRepository
│   ├── services/           ← GitHubApiService
│   └── interactors/        ← ProjectInteractor
└── detail/
    ├── interactors/        ← IssueDetailSelector
    ├── viewmodels/         ← DetailViewModel
    └── screens/            ← DetailScreen
```
