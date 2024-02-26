#!/bin/bash

input_path="$HOME/Downloads/big_buck_bunny_1080p_h264.mov"
output_path="../output/ex1a.mp4"

if docker images alpine-ffmpeg -q < /dev/null | grep -q .; then
    cd ../docker && ./dffmpeg.sh -i $input_path -ss 00:00:00 -t 00:01:00 -c:v copy -c:a copy $output_path
else
    cd ../docker && ./build.sh && ./dffmpeg.sh -i $input_path -ss 00:00:00 -t 00:01:00 -c:v copy -c:a copy $output_path
fi
