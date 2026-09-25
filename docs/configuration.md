# Configuration Guide

This document describes the configurable parameters for each script.

## user\_management.sh

|Variable|Default|Description|
|-|-|-|
|`LOG\\\_FILE`|`/var/log/user\\\_management.log`|Path where user-management actions are logged|

New users are created with:

* Home directory: `/home/<username>` (`useradd -m`)
* Default shell: `/bin/bash`
* No password set (forces reset on first login)

To change the default shell, edit the `useradd` call in `create\\\_user()`.

## service\_monitor.sh

|Variable|Default|Description|
|-|-|-|
|`LOG\\\_FILE`|`/var/log/service\\\_monitor.log`|Path where service events/alerts are logged|

The `watch` command polls every **5 seconds** by default. To change the interval, edit the `sleep 5` line inside `service\\\_watch()`.

## network\_check.sh

|Variable|Default|Description|
|-|-|-|
|`LOG\\\_FILE`|`/var/log/network\\\_check.log`|Path where network check results are logged|

`full-report` pings `8.8.8.8` by default as a reachability baseline. Change the target IP inside `full\\\_report()` if your environment blocks outbound ICMP to public IPs.

## General notes

* All scripts use `set -euo pipefail` to fail fast on errors and undefined variables.
* Scripts that modify system state (`user\\\_management.sh`, and start/stop/enable/disable actions in `service\\\_monitor.sh`) require root and check for it with `require\\\_root()`.
* Environment-specific values (log paths, ports, hostnames) are intentionally kept as simple shell variables/arguments rather than a separate config file, to keep the scripts dependency-free. If the project grows, consider moving shared settings into a `config.env` file sourced by all three scripts.



