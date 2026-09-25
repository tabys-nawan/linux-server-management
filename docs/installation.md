# Installation Guide

## Requirements

* Linux server (tested on Ubuntu 22.04 LTS / Debian 12)
* Bash 5+
* `systemd` (for service scripts)
* `iproute2`, `iputils-ping` (for network scripts)
* Git

## 1\. Clone the repository

```bash
git clone https://github.com/<your-username>/linux-server-management.git
cd linux-server-management
```

## 2\. Make scripts executable

```bash
chmod +x scripts/\*.sh
```

## 3\. (Optional) Add scripts to your PATH

```bash
sudo cp scripts/\*.sh /usr/local/bin/
```

This lets you run them directly, e.g. `service\_monitor.sh status nginx`, from anywhere.

## 4\. Verify installation

```bash
./scripts/network\_check.sh interfaces
./scripts/service\_monitor.sh report
```

If both commands run without errors, the scripts are correctly installed.

## 5\. Log files

All scripts write activity logs to `/var/log/`:

* `/var/log/user\_management.log`
* `/var/log/service\_monitor.log`
* `/var/log/network\_check.log`

Make sure the executing user has write permission to `/var/log/`, or run scripts with `sudo` where required.



are you sure about that?

