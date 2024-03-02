#!/bin/bash

input_path="$HOME/Downloads/big_buck_bunny_1080p_h264.mov" #Change this to wherever your input file is
output_path="../output/ex2a_trimmed.mp4"
output_path2="../output/ex2a.mp4"

if docker images alpine-ffmpeg -q < /dev/null | grep -q .; then
    echo "Image detected!" && cd ../docker && \
    ./dffmpeg.sh -i $input_path -ss 00:00:00 -t 00:01:00 -c:v copy -c:a copy $output_path && \
    ./dffmpeg.sh -i $output_path -c:v libx264 -profile:v baseline -level:v 3.0 -c:a aac -strict -2 -movflags frag_keyframe+empty_moov $output_path2
else
    echo "Image not detected, building alpine-ffmpeg" && cd ../docker && ./build.sh && \
    ./dffmpeg.sh -i $input_path -ss 00:00:00 -t 00:01:00 -c:v copy -c:a copy $output_path && \
    ./dffmpeg.sh -i $output_path -c:v libx264 -profile:v baseline -level:v 3.0 -c:a aac -strict -2 -movflags frag_keyframe+empty_moov $output_path2
fi

rm ../output/ex2a_trimmed.mp4