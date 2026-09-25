# Configuration Guide

This document describes the configurable parameters for each script.

## user_management.sh
| Variable | Default | Description |
|---|---|---|
| `LOG_FILE` | `/var/log/user_management.log` | Path where user-management actions are logged |

New users are created with:
- Home directory: `/home/<username>` (`useradd -m`)
- Default shell: `/bin/bash`
- No password set (forces reset on first login)

To change the default shell, edit the `useradd` call in `create_user()`.

## service_monitor.sh
| Variable | Default | Description |
|---|---|---|
| `LOG_FILE` | `/var/log/service_monitor.log` | Path where service events/alerts are logged |

The `watch` command polls every **5 seconds** by default. To change the interval, edit the `sleep 5` line inside `service_watch()`.

## network_check.sh
| Variable | Default | Description |
|---|---|---|
| `LOG_FILE` | `/var/log/network_check.log` | Path where network check results are logged |

`full-report` pings `8.8.8.8` by default as a reachability baseline. Change the target IP inside `full_report()` if your environment blocks outbound ICMP to public IPs.

## General notes
- All scripts use `set -euo pipefail` to fail fast on errors and undefined variables.
- Scripts that modify system state (`user_management.sh`, and start/stop/enable/disable actions in `service_monitor.sh`) require root and check for it with `require_root()`.
- Environment-specific values (log paths, ports, hostnames) are intentionally kept as simple shell variables/arguments rather than a separate config file, to keep the scripts dependency-free. If the project grows, consider moving shared settings into a `config.env` file sourced by all three scripts.
