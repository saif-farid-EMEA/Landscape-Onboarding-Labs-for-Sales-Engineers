#!/bin/bash
# ---------------------------------------------------------------------------
# Lab 07 - Fix ONE specific CVE (and nothing else) with Ubuntu Pro Client
# Paste into Landscape: Scripts > Add script. Run as user: root
#
# BEFORE SAVING: replace CVE-YYYY-NNNN below with the real CVE ID you want to
# fix (for example one listed on the USN page you opened in Lab 06).
#
# "pro fix" is part of the Ubuntu Pro Client (package: ubuntu-pro-client).
# It works out which packages need upgrading to fix that CVE, upgrades only
# those, and tells you whether the CVE is now resolved on this machine.
# This is the method described in the Landscape docs:
#   "How to apply security patches and upgrades > Apply an individual CVE or USN fix"
# ---------------------------------------------------------------------------

set -e

# The CVE (or USN, e.g. USN-1234-1) to fix:
pro fix CVE-YYYY-NNNN
