# Troubleshooting Guide

## "Permission denied" when running a script
**Cause:** the script isn't executable, or the action requires root.
**Fix:**
```bash
chmod +x scripts/*.sh
sudo ./scripts/service_monitor.sh restart nginx
```

## "this script must be run as root" error
**Cause:** `user_management.sh` or state-changing `service_monitor.sh` commands call `require_root()`.
**Fix:** re-run the command with `sudo`.

## `useradd: user already exists`
**Cause:** you tried to create a user that already exists on the system.
**Fix:** use `list` to check existing users first:
```bash
sudo ./scripts/user_management.sh list
```

## `systemctl status` shows "Unit not found"
**Cause:** the service name is wrong, or the package providing it isn't installed.
**Fix:**
```bash
systemctl list-units --type=service --all | grep -i <partial-name>
```

## `network_check.sh port` always reports CLOSED
**Cause:** either the port really is closed, a firewall is blocking it, or `/dev/tcp` isn't supported by your shell (non-bash `sh`).
**Fix:**
- Confirm you're running with `bash`, not `sh`.
- Check firewall rules: `sudo ufw status` or `sudo iptables -L`.

## Logs aren't being written
**Cause:** the script doesn't have write permission to `/var/log/`.
**Fix:** run with `sudo`, or change `LOG_FILE` in the script to a path you own, e.g. `~/logs/service_monitor.log`.

## Git: "fatal: invalid reference: main" / "not something we can merge"
**Cause:** no commits exist yet in the repository, so no branch pointer exists.
**Fix:**
```bash
git add .
git commit -m "Initial commit"
git branch -M main
```
See the project README's "Development Workflow" section for the full branching process.

## Merge conflict markers left in a file after resolving
**Cause:** `<<<<<<<`, `=======`, `>>>>>>>` markers weren't fully removed before staging.
**Fix:** re-open the file, remove all markers, keep only the intended content, then:
```bash
git add <file>
git commit
```
