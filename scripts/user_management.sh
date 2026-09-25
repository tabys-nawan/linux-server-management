#!/bin/bash
#
# user_management.sh
# Purpose: Create, inspect, and manage local Linux users and groups.
# Usage:   sudo ./user_management.sh <command> [args]
#
# Commands:
#   create <username> <groups...>   Create a new user and add to given groups
#   delete <username>               Remove a user and their home directory
#   list                            List all human (non-system) users
#   check-sudo <username>           Check whether a user has sudo access
#   lock <username>                 Lock a user account
#   unlock <username>               Unlock a user account
#
# Requires: root privileges (run with sudo)

set -euo pipefail

LOG_FILE="/var/log/user_management.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

require_root() {
    if [[ $EUID -ne 0 ]]; then
        echo "Error: this script must be run as root (use sudo)." >&2
        exit 1
    fi
}

usage() {
    grep '^#' "$0" | sed 's/^#//'
    exit 1
}

create_user() {
    local username="$1"
    shift
    local groups=("$@")

    if id "$username" &>/dev/null; then
        echo "User '$username' already exists." >&2
        exit 1
    fi

    useradd -m -s /bin/bash "$username"
    passwd -d "$username" >/dev/null   # no password set by default; force reset on first login
    chage -d 0 "$username"

    for grp in "${groups[@]}"; do
        if getent group "$grp" >/dev/null; then
            usermod -aG "$grp" "$username"
        else
            echo "Warning: group '$grp' does not exist, skipping." >&2
        fi
    done

    log "Created user '$username' with groups: ${groups[*]:-none}"
    echo "User '$username' created. They must set a password on first login."
}

delete_user() {
    local username="$1"
    if ! id "$username" &>/dev/null; then
        echo "User '$username' does not exist." >&2
        exit 1
    fi
    userdel -r "$username"
    log "Deleted user '$username' and their home directory."
}

list_users() {
    echo "UID_MIN-defined human users:"
    awk -F: -v min="$(awk '/^UID_MIN/{print $2}' /etc/login.defs)" \
        '$3 >= min && $3 < 65534 {print $1" (uid="$3")"}' /etc/passwd
}

check_sudo() {
    local username="$1"
    if id -nG "$username" 2>/dev/null | grep -qw sudo; then
        echo "'$username' HAS sudo privileges."
    else
        echo "'$username' does NOT have sudo privileges."
    fi
}

lock_user() {
    usermod -L "$1"
    log "Locked account '$1'"
}

unlock_user() {
    usermod -U "$1"
    log "Unlocked account '$1'"
}

main() {
    [[ $# -lt 1 ]] && usage
    require_root

    case "$1" in
        create)     shift; create_user "$@" ;;
        delete)     shift; delete_user "$1" ;;
        list)       list_users ;;
        check-sudo) shift; check_sudo "$1" ;;
        lock)       shift; lock_user "$1" ;;
        unlock)     shift; unlock_user "$1" ;;
        *)          usage ;;
    esac
}

main "$@"
