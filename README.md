# Linux Server Management

A collection of Bash scripts and documentation for managing users, services, and network diagnostics on a Linux server, built as a team DevOps project demonstrating a professional Git workflow.

## Project Purpose
This project simulates the work of a Junior DevOps team maintaining a Linux server environment. It provides reusable, well-documented scripts for common administration tasks, alongside documentation covering installation, configuration, and troubleshooting.
This project simulates the work of a Junior DevOps team focused on automation.

## Project Structure
```
linux-server-management/
├── README.md
├── .gitignore
├── scripts/
│   ├── user_management.sh     # Create/delete/lock users, check sudo access
│   ├── service_monitor.sh     # Start/stop/watch systemd services
│   └── network_check.sh       # Interfaces, ping, port checks, DNS
└── docs/
    ├── installation.md
    ├── configuration.md
    └── troubleshooting.md
```

## Development Workflow
1. Work happens on feature branches, never directly on `main`.
2. Each change is committed in small, meaningful commits with descriptive messages.
3. Finished feature branches are pushed and opened as Pull Requests against `main`.
4. At least one reviewer must approve a PR before it is merged.
5. `main` always reflects a stable, working state of the project.

## Branching Strategy
- `main` — stable, always-working code only.
- `feature/<name>` — one branch per feature or fix (e.g. `feature/user-mgmt`, `feature/service-monitor`, `feature/network-tools`).
- Branches are deleted after being merged into `main`.

## Contribution Process
1. Create a branch: `git switch -c feature/your-feature`
2. Make changes and commit: `git add . && git commit -m "Add X"`
3. Push: `git push -u origin feature/your-feature`
4. Open a Pull Request describing **what**, **why**, and **how it was tested**.
5. Address review comments, then merge once approved.

## Testing Process
Scripts are tested manually on a Linux VM/server before being merged:
```bash
chmod +x scripts/*.sh
./scripts/network_check.sh full-report
sudo ./scripts/service_monitor.sh status ssh
sudo ./scripts/user_management.sh list
```
Each PR description documents what was run to verify the change works as expected.

## Troubleshooting
See [`docs/troubleshooting.md`](docs/troubleshooting.md) for common errors (permissions, missing services, Git issues) and how to resolve them.

## License
See `LICENSE`.
