# Big Top

A Flutter web dashboard for [beads](https://github.com/nicospencer/beads) issue tracking, synced via GitHub.

## Features

- GitHub OAuth Device Flow authentication
- Kanban board view (open, in progress, blocked, closed)
- Issue detail view
- Material 3 dark theme
- Reads beads JSONL exports from GitHub repositories

## Getting Started

```bash
flutter run -d chrome
```

## Architecture

- **State management**: Provider + StateNotifier
- **Routing**: go_router with auth guards
- **Data**: JSONL-based issue format from beads
- **Auth**: GitHub OAuth Device Flow
