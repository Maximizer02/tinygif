#!/bin/bash

usage() {
	echo "usage: tinygif [options] video [result-filename]";
	echo "-c	Set the ammout of colors in the colorpalette";
	echo "-d	Enable dithering";
	echo "-f	Set the target fps";
	echo "-s	Set the scale in pixel, formatted as 'w:h'";
	echo "-h	Display this help text";
	exit $1;
}

get-frame-count(){
	ffprobe -v error \
		-select_streams v:0 \
		-count_packets \
		-show_entries stream=nb_read_packets \
		-of csv=p=0 \
		"$1";
}

get-fps(){
	echo $(( $(ffprobe \
		-v error \
		-select_streams v \
		-of default=noprint_wrappers=1:nokey=1 \
		-show_entries stream=r_frame_rate \
		"$input_file") + 1 ));
}

# set initial value for args
fps="20";
scale="160:90";
colors="64";
dither="";

# parse cli args
while getopts "dhf:s:c:" o; do
	case "${o}" in
		c) colors="${OPTARG}";;
		d) dither=":dither=bayer";;
		f) fps="${OPTARG}";; 
		h) usage 0;;
		s) scale="${OPTARG}";; 
		*) usage 1;;
	esac
done
shift $((OPTIND-1));

# check that either 1 or 2 args were passed after the flags
[ $# -lt 1 ] || [ $# -gt 2 ] && usage 1;

# validate that the input file exists
input_file="$1";
[ ! -f "$input_file" ] && echo "$input_file is not a valid file" && exit 1;

# if a second filename is provided, use that as the output filename
[ ! -z "$2" ] && output_file="$2" || output_file="$input_file.gif";

color_palette="$XDG_CACHE_HOME/tinygif/${colors}_${input_file}.png";

# approximate number of frames in resulting GIF
output_frame_count="$(( $(get-frame-count $input_file) / ($(get-fps $input_file)) / 2))";
echo "Result will have approximately $output_frame_count frames";

# generate a colorpalette for the input file and the specified number of colors
if [ ! -f "$color_palette" ]; then
	echo "Cache miss, calculating color palette: $color_palette";
 	ffmpeg \
		-loglevel error \
		-stats \
		-y \
		-i "$input_file" \
		-vf "[0]fps=$fps,select='mod(n,2)'[a];[a]palettegen=max_colors=$colors:reserve_transparent=0" \
		"$color_palette";
else
	echo "Cache hit, using color palette: $color_palette";
fi

# actually create the GIF and log infos before and after
echo "Generating $output_file with parameters: fps=$fps colors=$colors scale=$scale dither=$([ -z $dither ] && echo false || echo true)";
ffmpeg \
	-loglevel error \
	-stats \
	-y \
	-i "$input_file" \
	-i "$color_palette" \
	-filter_complex "[0]fps=$fps,select='mod(n,2)',scale='$scale'[a];[a][1] paletteuse=new=1$dither" \
	"$output_file" && \

echo "The resulting GIF is $(du -h $output_file | xargs) in size";

