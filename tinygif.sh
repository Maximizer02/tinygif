#!/bin/bash
if [ $# -ne 1 ]; then
	printf "usage: tinygif file.mp4"
	exit 1;
fi
ffmpeg -i "$1" -vf "[0:v]fps=12,select='mod(n,2)',scale='144:81',split [a][b];[a] palettegen=max_colors=28:reserve_transparent=0 [p];[b][p] paletteuse=new=1" "tiny.gif" && du "tiny.gif"

