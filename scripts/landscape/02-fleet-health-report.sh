#!/bin/bash
# ---------------------------------------------------------------------------
# Lab 07 - A read-only "health report" for every machine
# Paste into Landscape: Scripts > Add script. Run as user: ubuntu (no root needed)
#
# This script CHANGES NOTHING. It only reads information and prints it, so it
# is safe to run anywhere, including in a live customer demo.
# ---------------------------------------------------------------------------

echo "=== Health report for $(hostname) ==="

# /etc/os-release is a text file describing the OS. "grep" finds the line
# starting with PRETTY_NAME, and "cut" keeps only the part after the "=".
echo "OS:        $(grep '^PRETTY_NAME=' /etc/os-release | cut -d= -f2 | tr -d '"')"

# "uname -r" prints the running kernel version.
echo "Kernel:    $(uname -r)"

# "uptime -p" prints how long the machine has been running, in plain words.
echo "Uptime:    $(uptime -p)"

# "df -h /" shows disk usage of the root (/) filesystem in human units (G, M).
# "tail -1" keeps the last line, and "awk" picks the 5th column (the "Use%").
echo "Disk used: $(df -h / | tail -1 | awk '{print $5}') of the root filesystem"

# "free -h" shows memory. We keep the "Mem:" line and pick used/total columns.
echo "Memory:    $(free -h | awk '/^Mem:/ {print $3 " used of " $2}')"

# Ubuntu creates this file when a reboot is needed (e.g. after a kernel update).
# "[ -f FILE ]" checks whether the file exists.
if [ -f /var/run/reboot-required ]; then
  echo "Reboot:    REQUIRED"
else
  echo "Reboot:    not required"
fi
