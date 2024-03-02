#!/bin/bash

input_path_a="/opt/bento4/output/ex2a.mp4"

if [ ! -f "../output/ex2a.mp4" ]; then
    ./ex2a.sh
fi

if docker images alfg/bento4 -q < /dev/null | grep -q .; then
    echo "Image alfg/bento4 detected! Proceeding with the execution."
else
    echo "Image not detected, building alfg/bento4" && docker pull alfg/bento4:latest
fi

username="bernat.rubio01@estudiant.upf.edu"
password=$EZDRM_PASSWORD #I stored my EZDRM password as an environment variable
kid="7330F811-F47F-41BC-A4FF-E792D073F41F" #key created by the client in GUID format

drmOutput=$(curl -s "https://cpix.ezdrm.com/keygenerator/cpix.aspx?k=${kid}&u=${username}&p=${password}&c=drm-001") #Call to the EZDRM API
pskPlainValue=$(echo $drmOutput | grep -o '<pskc:PlainValue>[^<]*' | sed 's/<pskc:PlainValue>//';)
pssh=$(echo $drmOutput | grep -o '<cpix:PSSH>[^<]*' | sed 's/<cpix:PSSH>//';)
pskPlainValue_hexa=$(echo -n $pskPlainValue | base64 -d | xxd -p) #Convert from base64 to Hexadecimal

past_dir=$(cd .. && pwd)

docker run --rm -v $past_dir/output:/opt/bento4/output alfg/bento4 sh -c "mkdir -p /opt/bento4/output && \
mp4encrypt --method MPEG-CENC \
--key 1:${pskPlainValue_hexa}:random \
--key 2:${pskPlainValue_hexa}:random \
--key 3:${pskPlainValue_hexa}:random \
$input_path_a /opt/bento4/output/ex3_encrypted.mp4"

rm ../output/ex2a.mp4

echo "Encrypted file stored successfully at directory" "$past_dir/output/ex3_encrypted.mp4"