#!/bin/bash
if [ $# -ne 1 ]; then
	printf "usage: tinygif file.mp4"
	exit 1;
fi

input_file="$1";
output_file="$input_file.gif"

fps="12";
scale="144:81"
colors="28"

color_palette="$XDG_CACHE_HOME/tinygif/$colors_$1.png";

if [ ! -f "$color_palette" ]; then
	echo "Cache miss, calculating color palette: $color_palette";
 	ffmpeg \
		-hide_banner \
		-loglevel error \
		-y \
		-i "$input_file" \
		-vf "palettegen=max_colors=$colors:reserve_transparent=0" \
		"$color_palette";
else
	echo "Cache hit, using color palette: $color_palette";
fi

ffmpeg \
	-hide_banner \
	-loglevel error \
	-y \
	-i "$input_file" \
	-i "$color_palette" \
	-filter_complex "[0]fps=$fps,select='mod(n,2)',scale='$scale'[a];[a][1] paletteuse=new=1" \
	"$output_file";

echo "The resulting GIF is $(du -hs $output_file | xargs) in size";

