#!/bin/bash
#
# service_monitor.sh
# Purpose: Monitor, start, stop, and report on systemd services.
# Usage:   sudo ./service_monitor.sh <command> <service_name>
#
# Commands:
#   status <service>     Show status of a service
#   start <service>      Start a service
#   stop <service>       Stop a service
#   restart <service>    Restart a service
#   enable <service>     Enable service on boot
#   disable <service>    Disable service on boot
#   watch <service>      Continuously monitor service health (Ctrl+C to stop)
#   report                Show a summary of failed services on the system
#
# Requires: systemd, root privileges for start/stop/enable/disable

set -euo pipefail

LOG_FILE="/var/log/service_monitor.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

require_root() {
    if [[ $EUID -ne 0 ]]; then
        echo "Error: this action requires root (use sudo)." >&2
        exit 1
    fi
}

usage() {
    grep '^#' "$0" | sed 's/^#//'
    exit 1
}

service_status() {
    systemctl status "$1" --no-pager || true
}

service_start() {
    require_root
    systemctl start "$1"
    log "Started service '$1'"
}

service_stop() {
    require_root
    systemctl stop "$1"
    log "Stopped service '$1'"
}

service_restart() {
    require_root
    systemctl restart "$1"
    log "Restarted service '$1'"
}

service_enable() {
    require_root
    systemctl enable "$1"
    log "Enabled service '$1' on boot"
}

service_disable() {
    require_root
    systemctl disable "$1"
    log "Disabled service '$1' from boot"
}

service_watch() {
    local svc="$1"
    echo "Watching '$svc' (Ctrl+C to stop)..."
    while true; do
        state=$(systemctl is-active "$svc" 2>/dev/null || echo "unknown")
        echo "$(date '+%H:%M:%S') - $svc: $state"
        if [[ "$state" != "active" ]]; then
            log "ALERT: service '$svc' is '$state'"
        fi
        sleep 5
    done
}

failed_report() {
    echo "== Failed systemd units =="
    systemctl --failed --no-pager || true
}

main() {
    [[ $# -lt 1 ]] && usage
    case "$1" in
        status)   service_status "$2" ;;
        start)    service_start "$2" ;;
        stop)     service_stop "$2" ;;
        restart)  service_restart "$2" ;;
        enable)   service_enable "$2" ;;
        disable)  service_disable "$2" ;;
        watch)    service_watch "$2" ;;
        report)   failed_report ;;
        *)        usage ;;
    esac
}

main "$@"
