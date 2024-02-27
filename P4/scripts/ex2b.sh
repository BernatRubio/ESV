#!/bin/bash

input_path="$HOME/Downloads/big_buck_bunny_1080p_h264.mov"
output_path="../output/ex2b_trimmed.mkv"
output_path2="../output/ex2b.mkv"

if docker images alpine-ffmpeg -q < /dev/null | grep -q .; then
    echo "Image detected!" && cd ../docker && ./dffmpeg.sh -i $input_path -ss 00:00:00 -t 00:01:00 -c:v copy -c:a copy $output_path && ./dffmpeg.sh -i $output_path -c:v libvpx-vp9 -c:a aac -strict -2 $output_path2

else
    echo "Image not detected, building alpine-ffmpeg" && cd ../docker && ./build.sh && ./dffmpeg.sh -i $input_path -ss 00:00:00 -t 00:01:00 -c:v copy -c:a copy $output_path && ./dffmpeg.sh -i $output_path -c:v libvpx-vp9 -c:a aac -strict -2 $output_path2
fi
