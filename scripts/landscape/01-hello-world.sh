#!/bin/bash
# ---------------------------------------------------------------------------
# Lab 07 - Your first remote script
# Paste this into Landscape: Scripts > Add script. Run it as user: ubuntu
#
# The first line ("#!/bin/bash") is called a "shebang". It tells the machine
# which program should run this script. Landscape reads it too, so keep it.
# ---------------------------------------------------------------------------

# "echo" prints text. ">" writes that text into a file (replacing its contents).
# "$HOME" is the home folder of the user the script runs as (/home/ubuntu).
echo "Hello from Landscape! Written on $(date)" > "$HOME/hello-from-landscape.txt"

# Anything a script prints is captured by Landscape and shown in the
# activity's output, so we print a confirmation too.
# "$(hostname)" is replaced by the machine's name when the script runs.
echo "Created $HOME/hello-from-landscape.txt on $(hostname)"
