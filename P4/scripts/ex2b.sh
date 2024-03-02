#!/bin/bash

input_path="$HOME/Downloads/big_buck_bunny_1080p_h264.mov" #Change this to wherever your input file is
past_dir=$(cd .. && pwd)
output_path_local="${past_dir}/output/ex2b_trimmed.mp4"
output_path_bento="/opt/bento4/output/ex2b_trimmed.mp4"
output_path2_local="${past_dir}/output/ex2b_fragmented.mp4"
output_path2_bento="/opt/bento4/output/ex2b_fragmented.mp4"
output_path3_local="${past_dir}/output/ex2b.mkv"


if docker images alfg/bento4 -q < /dev/null | grep -q .; then
    echo "Image alfg/bento4 detected! Proceeding with the execution."
else
    echo "Image not detected, building alfg/bento4" && docker pull alfg/bento4:latest
fi

if docker images alpine-ffmpeg -q < /dev/null | grep -q .; then
    echo "Image detected!" && cd ../docker && \
    ./dffmpeg.sh -i $input_path -ss 00:00:00 -t 00:01:00 -c:v copy -c:a copy $output_path_local && \
    docker run --rm -v $past_dir/output:/opt/bento4/output alfg/bento4 sh -c "mkdir -p /opt/bento4/output && \
    mp4fragment $output_path_bento $output_path2_bento && \
    mp4dash $output_path2_bento"
    ./dffmpeg.sh -i $output_path2_local -c copy $output_path3_local
else
    echo "Image not detected, building alpine-ffmpeg" && cd ../docker && ./build.sh && \
    ./dffmpeg.sh -i $input_path -ss 00:00:00 -t 00:01:00 -c:v copy -c:a copy $output_path_local && \
    docker run --rm -v $past_dir/output:/opt/bento4/output alfg/bento4 sh -c "mkdir -p /opt/bento4/output && \
    mp4fragment $output_path_bento $output_path2_bento && \
    mp4dash $output_path2_bento"
    ./dffmpeg.sh -i $output_path2_local -c copy $output_path3_local
fi

rm $output_path_local
rm $output_path2_local