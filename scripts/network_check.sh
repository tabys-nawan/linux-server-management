#!/bin/bash
#
# network_check.sh
# Purpose: Basic network diagnostics for a Linux server.
# Usage:   ./network_check.sh <command> [args]
#
# Commands:
#   interfaces              Show all network interfaces and IP addresses
#   ping <host>              Ping a host 4 times and report result
#   port <host> <port>       Check whether a TCP port is open
#   listening                Show all listening ports/services on this machine
#   dns <hostname>            Resolve a hostname to an IP
#   full-report               Run all checks and print a combined summary
#
# Requires: iproute2 (ip), iputils-ping, and optionally netcat (nc)

set -euo pipefail

LOG_FILE="/var/log/network_check.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE" >/dev/null
}

usage() {
    grep '^#' "$0" | sed 's/^#//'
    exit 1
}

show_interfaces() {
    echo "== Network interfaces =="
    ip -brief address show
}

ping_host() {
    local host="$1"
    echo "== Pinging $host =="
    if ping -c 4 -W 2 "$hostt"; then
        log "Ping to $host: SUCCESS"
    else
        log "Ping to $host: FAILED"
        echo "Host $host appears unreachable." >&2
        exit 1
    fi
}

check_port() {
    local host="$1"
    local port="$2"
    echo "== Checking $host:$port =="
    if timeout 3 bash -c "echo > /dev/tcp/$host/$port" 2>/dev/null; then
        echo "Port $port on $host is OPEN"
        log "Port check $host:$port -> OPEN"
    else
        echo "Port $port on $host is CLOSED or filtered"
        log "Port check $host:$port -> CLOSED"
    fi
}

show_listening() {
    echo "== Listening ports on this host =="
    ss -tulnp 2>/dev/null || netstat -tulnp
}

dns_lookup() {
    local host="$1"
    echo "== DNS lookup for $host =="
    getent hosts "$host" || echo "Could not resolve $host" >&2
}

full_report() {
    show_interfaces
    echo
    show_listening
    echo
    dns_lookup "8.8.8.8" || true
    echo
    ping_host "8.8.8.8" || true
}

main() {
    [[ $# -lt 1 ]] && usage
    case "$1" in
        interfaces) show_interfaces ;;
        ping)       ping_host "$2" ;;
        port)       check_port "$2" "$3" ;;
        listening)  show_listening ;;
        dns)        dns_lookup "$2" ;;
        full-report) full_report ;;
        *)          usage ;;
    esac
}

main "$@"
