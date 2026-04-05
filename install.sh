#!/bin/bash
# Create cache directory if it does not exist
[ ! -z "$XDG_CACHE_HOME" ] && CACHE_DIR="$XDG_CACHE_HOME/tinygif" || CACHE_DIR="$HOME/.cache/tinygif";
[ ! -d  "$CACHE_DIR" ] && mkdir "$CACHE_DIR";

# Fall back to another location if the preferred one does not exist
BIN="$HOME/.local/bin";
[ ! -d "$BIN" ] && BIN="/usr/local/bin";

# Move script to chosen directory
cp ./tinygif.sh "$BIN/tinygif";
printf "tinygif was installed to \x1B[33m$BIN\x1B[0m\n";
