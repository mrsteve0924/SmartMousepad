#!/bin/bash
# Run GUI apps as root with temporary X access

set -e

# Always revoke X access when the script exits
trap 'xhost -si:localuser:root >/dev/null 2>&1' EXIT

# Temporarily allow root access to X
xhost +si:localuser:root >/dev/null

# Run as root in a separate D-Bus session
sudo dbus-run-session -- "$@"
