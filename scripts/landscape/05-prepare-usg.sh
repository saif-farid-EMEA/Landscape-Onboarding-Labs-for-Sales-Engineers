#!/bin/bash
# ---------------------------------------------------------------------------
# Lab 09 - Prepare a machine for USG compliance audits
# Paste into Landscape: Scripts > Add script. Run as user: root
# Time limit: set it to 600 seconds (10 minutes). Installing takes a while.
#
# Requirements: the machine must be attached to Ubuntu Pro (done in Lab 05),
# because USG is an Ubuntu Pro service. The "UsgManager" client plugin must
# also be enabled; we already did that in Lab 04 (include_manager_plugins).
# ---------------------------------------------------------------------------

set -e

# Step 1: turn on the USG service in the Ubuntu Pro subscription.
# This adds Canonical's USG package source to the machine.
pro enable usg

# Step 2: install the Ubuntu Security Guide tool itself.
# DEBIAN_FRONTEND=noninteractive stops apt from asking questions.
DEBIAN_FRONTEND=noninteractive apt-get install -y usg

# Step 3: print the result so it is visible in the Landscape activity output.
echo "USG installed on $(hostname): $(dpkg-query -W -f='${Version}' usg)"
