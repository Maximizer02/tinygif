#!/bin/bash
# Create cache directory
if [ ! -d  $XDG_CACHE_DIR/tinygif ]; then
	mkdir $XDG_CACHE_DIR/tinygif;
fi

# Move script to location in PATH
BIN="$HOME/.local/bin";
if [ ! -d "$BIN" ] ; then
	BIN="/usr/local/bin";
fi
cp tinygif.sh $BIN/tinygif;
