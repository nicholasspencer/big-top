# Big Top — Architecture: Data Flow

## Current Dependency Graph

Who creates whom, who depends on whom.

```mermaid
graph TD
    subgraph Services["Services (stateless)"]
        GAS[GitHubAuthService]
        GAPI[GitHubApiService]
    end

    subgraph Repositories["Repositories (StateNotifier)"]
        AR["AuthRepository\n← AsyncValue&lt;AuthSession&gt;"]
        IR["IssuesRepository\n← AsyncValue&lt;ProjectData&gt;"]
        PR["ProjectRepository\n← ProjectState"]
    end

    subgraph ViewModels["ViewModels (StateNotifier)"]
        BVM["BoardViewModel\n← BoardState {isLoading, error}"]
        DVM["DetailViewModel\n← DetailState {issue, comments, labels, deps}"]
        LVM["LoginViewModel\n← LoginState {isPolling, deviceCode, error}"]
    end

    subgraph Screens["Screens (Widgets)"]
        LS[LoginScreen]
        BS[BoardScreen]
        DS[DetailScreen]
    end

    GAS --> AR
    GAPI --> IR
    AR --> LVM
    IR --> BVM
    PR --> BVM
    IR --> DVM

    LVM --> LS
    BS -.->|"watches AsyncValue&lt;AuthSession&gt;\ndirectly from Provider"| AR
    BS -.->|"does NOT use BoardViewModel"| BVM
    LS --> LVM
```

## State Ownership

Which `StateNotifier` owns which state, and how the widget tree accesses it.

```mermaid
graph LR
    subgraph "AppDependencies (always)"
        GAS[GitHubAuthService]
        GAPI[GitHubApiService]
        AR["AuthRepository\n↳ AsyncValue&lt;AuthSession&gt;"]
    end

    subgraph "AuthorizedDependencies (when authed)"
        IR["IssuesRepository\n↳ AsyncValue&lt;ProjectData&gt;"]
        PR["ProjectRepository\n↳ ProjectState"]
    end

    subgraph "Widget-local"
        BVM["BoardViewModel\n↳ BoardState"]
        DVM["DetailViewModel\n↳ DetailState"]
        LVM["LoginViewModel\n↳ LoginState"]
    end

    AR -->|"StateNotifierProvider\n(exposed as AsyncValue&lt;AuthSession&gt;)"| IR
    AR -->|"context.watch"| BS[BoardScreen]
    AR -->|"context.watch"| LS[LoginScreen]
    IR -->|"StateNotifierProvider\n(exposed as AsyncValue&lt;ProjectData&gt;)"| DVM
    IR -->|"NOT wired to BoardScreen"| BS
```

## The Problems

### 1. `BoardState` ≈ `AsyncValue<void>`

```mermaid
classDiagram
    class BoardState {
        +bool isLoading
        +String? error
    }
    class AsyncValue~void~ {
        +none / waiting / active / done
        +Object? error
        +StackTrace? stackTrace
    }
    BoardState ..> AsyncValue~void~ : "semantically equivalent"
```

`BoardState` tracks `{isLoading, error}` — that's exactly what `AsyncValue<void>` represents. It carries no actual board data. The `BoardViewModel` calls `_issuesRepo.loadProject()` but never exposes `_issuesRepo.state` (the `AsyncValue<ProjectData>`) to the UI.

### 2. `BoardScreen` bypasses its ViewModel

```mermaid
sequenceDiagram
    participant BS as BoardScreen
    participant Provider as Provider tree
    participant AR as AuthRepository
    participant BVM as BoardViewModel
    participant IR as IssuesRepository

    BS->>Provider: context.watch<AsyncValue<AuthSession>>()
    Provider->>AR: state
    AR-->>BS: AuthSession (for avatar/username)

    Note over BS,BVM: BoardViewModel is never instantiated or watched by BoardScreen
    Note over BS,IR: IssuesRepository state (ProjectData) is never consumed by BoardScreen
    BS->>BS: Renders StatusColumn(issues: const [])
```

The board screen watches `AuthRepository` directly for the user avatar, but passes `const []` for issues. `BoardViewModel` exists but is orphaned — nothing instantiates it in the widget tree.

### 3. Repository ≠ Provider (incomplete rename)

```mermaid
graph TD
    subgraph "How they're wired (Provider pattern)"
        AR_P["AuthRepository"] -->|"StateNotifierProvider exposes"| AV["AsyncValue&lt;AuthSession&gt;"]
        IR_P["IssuesRepository"] -->|"StateNotifierProvider exposes"| PD["AsyncValue&lt;ProjectData&gt;"]
        PR_P["ProjectRepository"] -->|"StateNotifierProvider exposes"| PS["ProjectState"]
    end

    subgraph "How they're used (mixed)"
        BS2[BoardScreen] -->|"context.watch"| AV
        BS2 -.->|"context.read (for logout)"| AR_P
        LS2[LoginScreen] -->|"context.watch"| AV
        LS2 -.->|"context.read (for startDeviceFlow)"| AR_P
        DVM2[DetailViewModel] -->|"addListener"| IR_P
    end

    style BS2 fill:#fdd
    style DVM2 fill:#fdd
```

Screens sometimes `watch` the _exposed state type_ and sometimes `read` the _repository instance_ to call methods. `DetailViewModel` bypasses Provider entirely and uses `addListener` directly on the `IssuesRepository` instance. There's no consistent pattern.

## Layer Map (current)

```mermaid
graph TB
    subgraph UI["UI Layer"]
        LoginScreen
        BoardScreen
        DetailScreen
        IssueCard[IssueCard widget]
        StatusColumn[StatusColumn widget]
    end

    subgraph VM["ViewModel Layer"]
        LoginVM[LoginViewModel]
        BoardVM[BoardViewModel]
        DetailVM[DetailViewModel]
    end

    subgraph Repo["Repository Layer"]
        AuthRepo[AuthRepository]
        IssuesRepo[IssuesRepository]
        ProjectRepo[ProjectRepository]
    end

    subgraph Svc["Service Layer"]
        AuthSvc[GitHubAuthService]
        ApiSvc[GitHubApiService]
    end

    LoginScreen --> LoginVM
    BoardScreen -.->|"SKIPPED"| BoardVM
    BoardScreen -->|"direct"| AuthRepo
    DetailScreen -.->|"placeholder only"| DetailVM

    LoginVM --> AuthRepo
    BoardVM --> IssuesRepo
    BoardVM --> ProjectRepo
    DetailVM --> IssuesRepo

    AuthRepo --> AuthSvc
    IssuesRepo --> ApiSvc

    style BoardVM fill:#faa,stroke:#a00
    style BoardScreen fill:#ffd,stroke:#aa0
    style DetailScreen fill:#ffd,stroke:#aa0
```

**Legend:**
- 🔴 Red = orphaned / unused
- 🟡 Yellow = partially wired / placeholder UI
