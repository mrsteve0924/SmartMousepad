#!/bin/bash
# Run GUI apps as root with temporary X access

set -e

# Allow root access to X
xhost +si:localuser:root >/dev/null

# Run as root while preserving the current user's environment/session variables.
# Useful for GUI apps that should keep the current user's display and configuration.
#sudo -E -- "$@"

# Run as root with a new private D-Bus session.
# Useful when the app should behave more like a separate root-user GUI session.
sudo dbus-run-session -- "$@"

# Revoke access
xhost -si:localuser:root >/dev/null
