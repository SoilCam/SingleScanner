#!/bin/bash
#Process the previous days images into a video
day=$(date -d "today" +"%Y%m%d")
period="so_$day"
logs=~/logs/DailyProcess.txt
logname="video_$day.txt"
loc=~/public_html/images/
files=$(ls -1 $loc/$period*.jpg | wc -l)
width=$((1920 / 5))
x=1;
es=0;

cd $loc

mkdir $period

echo -e "$(date) \t Created temporary directory $period in $loc to process images for video conversion for the date: $day"

for file in $period*.jpg; do
	if [ "$x" -eq 1 ]
	then
		bdate="${file:3:8}-${file:12:6}"
	fi

	if [ "$x" -eq "$files" ]
	then
		edate="${file:3:8}-${file:12:6}"
	fi

ndate="${file:3:4}\/${file:7:2}\/${file:9:2}"
ntime="${file:12:2}:${file:14:2}:${file:16:2}"

counter=$(printf %04d $x);

echo -e "$(date) \t converting $file, this is file $x of $files"

convert $file -rotate 270 -resize 1920 -crop 1920x1080+0+0 - | convert -background '#0008'    \
     -gravity center        \
     -fill white            \
     -size ${width}x50     \
      caption:"${ndate} ${ntime}"      \
     -             \
     +swap                  \
     -gravity south         \
     -composite             \
     $period/"temp_$counter".jpg

	x=$(($x+1));
done

echo -e "$(date) \t Finished converting files"
echo -e "$(date) \t Creating video"
cd $loc

avconv -r 30 -i $period/temp_%04d.jpg -r 30  -vcodec libx264 -crf 20 -g 15 ~/public_html/videos/${bdate}-${edate}.mp4
avconv -y -i ~/public_html/videos/${bdate}-${edate}.mp4 -f mpegts -c copy -bsf:v h264_mp4toannexb ~/public_html/videos/${bdate}-${edate}.mpeg.ts

echo -e "$(date) \t Finished video creation"
echo -e "$(date) \t Cleanup temp images"

rm $period/temp_*.jpg
rmdir $period/

echo -e "$(date) \t Job Done. Have a nice day!"

