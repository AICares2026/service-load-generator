## Stack
Python (version undetected); pip for package management; Docker for containerisation. No framework detected — likely a standalone script-based load generator.

## Constraints
Never modify:
- `requirements.txt` lock files or any `*requirements*.txt` pinned to exact versions
- `Dockerfile` base image digest pins (`@sha256:...`)
- Any `*.env`, `.env*`, or credential/secret files
- Generated output files or logs
- CI/CD pipeline definitions (`.github/`, `.gitlab-ci.yml`, `Makefile` if present)

## Conventions
- Repository is small (13 tracked files, ~8% Python); changes are likely confined to a handful of `.py` source files
- No test directory detected; do not create one without explicit instruction
- Load generator pattern: scripts likely define request targets, concurrency, and duration as configurable parameters — preserve that interface when editing
- Docker image is the primary deployment artefact; keep `Dockerfile` and Python source in sync

## Dependency manifests
- `requirements.txt` — primary pip dependency file; update versions here only when performing dependency_freshness or cve_scan tasks
- `Dockerfile` — may pin base image and install dependencies; treat `FROM` line and any `RUN pip install` lines as authoritative alongside `requirements.txt`
