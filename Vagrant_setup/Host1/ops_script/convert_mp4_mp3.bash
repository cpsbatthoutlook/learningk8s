#!/bin/bash
#
## Install ffmpeg (didn't work on Dell) Vagrant works
img=jrottenberg/ffmpeg
inp="BEAS SATSANG PUNJABI 2020 06 16-WDaiBI2DWDY.mp4"
out="BEAS SATSANG PUNJABI 2020 06 16-WDaiBI2DWDY.mp3"
#
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
dir=${1:=/home/youtube/youtube/temp/rrsb}
cd $dir
FILES=*
echo "Converting following files.. "
ls -l $FILES
echo Please confirm :
for inp in $FILES;do 
 echo "Converting ${inp} to  ${inp/.mp4/}.mp3";sleep 2;
 docker run --rm -v ${dir}:${dir} -w ${dir} $img -stats -i  "$inp" -b:a 192K -vn  "${inp/.mp4/}.mp3"
 #docker run --rm -v ${dir}:${dir} -w ${dir} $img -stats -i  \"$inp\" -b:a 192K -vn  \"${inp/.mp4/}.mp3\"
 #docker run --rm -v ${dir}:${dir} -w ${dir} $img  -i  "$inp" -b:a 192K -vn  "${inp/.mp4/}.mp3"
done
