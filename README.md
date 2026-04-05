# Tinygif
FFMPEG wrapper to streamline the process of beating a video into a tiny GIF.

## Motivaion
Discord allows non-paying customers to send files of up to 10 MB. This also applies to GIFs. If you want to send a longer video as a GIF, you have to drastically reduce its quality. This script aims to help with that.

## How to install
```bash
$ ./install.sh
```

## How to run
```
$ tinygif [options] video [result-filename]
```

## Requirements
- Linux
- Bash
- FFMPEG

## Example
The entire music video of Rick Astley's [Never Gonna Give You Up](https://www.youtube.com/watch?v=dQw4w9WgXcQ) compressed down to a Discord-friendly 10 MB. The GIF has 65 colors, 17 fps, a resolution of 126 by 102, and makes use of dithering.

![rickroll gif](./rickroll.gif)
