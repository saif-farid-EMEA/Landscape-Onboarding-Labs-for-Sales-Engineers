#!/bin/bash
# ---------------------------------------------------------------------------
# Lab 07 - Make each machine report facts about itself ("annotations")
# Paste into Landscape: Scripts > Add script. Run as user: root
# (root is needed because the annotations folder belongs to the system)
#
# How annotations work: every file inside the folder below becomes one
# annotation. The FILE NAME is the key and the FILE CONTENTS are the value.
# Landscape Client sends them to the server automatically, and you can then
# search for them in the web portal, e.g.  annotation:owner-team:payments
# ---------------------------------------------------------------------------

# "set -e" makes the script stop at the first error instead of carrying on.
set -e

ANNOTATIONS_DIR=/var/lib/landscape/client/annotations.d

# Create the folder if it does not exist yet ("-p" = no error if it exists).
mkdir -p "$ANNOTATIONS_DIR"

# --- Annotation 1: which team owns this machine? ---------------------------
# A "case" statement picks a value based on the machine's hostname.
# In real life this might come from a CMDB; here we keep it simple.
case "$(hostname)" in
  web-*)    TEAM="web-platform" ;;
  db-*)     TEAM="data" ;;
  legacy-*) TEAM="finance-apps" ;;
  *)        TEAM="unassigned" ;;
esac
echo "$TEAM" > "$ANNOTATIONS_DIR/owner-team"

# --- Annotation 2: when was this machine last audited by this script? ------
# "date -u +%F" prints today's date in UTC, e.g. 2026-11-25.
date -u +%F > "$ANNOTATIONS_DIR/last-health-check"

# Print what we did, so it shows up in the activity output in Landscape.
echo "Annotations on $(hostname):"
for f in "$ANNOTATIONS_DIR"/*; do
  echo "  $(basename "$f") = $(cat "$f")"
done
