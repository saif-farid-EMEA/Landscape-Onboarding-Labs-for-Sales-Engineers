#!/bin/bash
# ---------------------------------------------------------------------------
# Lab 11 - "Prove the airgap" report (READ-ONLY, safe for live demos)
# Paste into Landscape: Scripts > Add script. Run as user: ubuntu
#
# BEFORE SAVING: replace <SERVER_IP> below with your Landscape server's IP.
#
# What it shows, from inside the isolated machine:
#   1. The public Internet is NOT reachable.
#   2. Your approved, signed mirror IS reachable.
#   3. Which software sources the machine is configured to use.
# The script changes nothing on the machine.
# ---------------------------------------------------------------------------

MIRROR_URL="http://<SERVER_IP>:8000/"

# A small helper ("function") we can call several times.
# curl tries to fetch the URL. "--max-time 8" gives up after 8 seconds.
# "-o /dev/null" throws the page away, and "-w '%{http_code}'" prints only the
# HTTP status code. If the connection fails, curl prints "000".
check() {
  local name="$1" url="$2"
  local code
  code=$(curl -s --max-time 8 -o /dev/null -w '%{http_code}' "$url")
  if [ "$code" = "000" ]; then
    echo "BLOCKED    $name   ($url)"
  else
    echo "REACHABLE  $name   ($url)  HTTP $code"
  fi
}

echo "=== Airgap report for $(hostname) ($(date -u '+%F %H:%M UTC')) ==="
echo
echo "--- Can this machine reach the outside world? (should be BLOCKED) ---"
check "Ubuntu archive" "http://archive.ubuntu.com/ubuntu/"
check "Ubuntu security archive" "http://security.ubuntu.com/ubuntu/"
check "Public website (ubuntu.com)" "https://ubuntu.com"
echo
echo "--- Can it reach the approved mirror? (should be REACHABLE) ---"
check "Approved mirror" "$MIRROR_URL"
echo
echo "--- Software sources configured on this machine ---"
# Classic one-line sources start with "deb"; newer files use "URIs:".
# "grep -rh" searches all files in the folders without printing file names.
grep -rh -E '^(deb |URIs:)' /etc/apt/sources.list /etc/apt/sources.list.d/ 2>/dev/null
echo
echo "--- Where would 'hello' be installed from? ---"
# apt-cache policy lists the candidate version and the source it comes from.
apt-cache policy hello 2>/dev/null | head -8
