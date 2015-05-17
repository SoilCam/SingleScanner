#!/bin/bash
# specify the location of the video files, along with the start and end dates
# of the range you wish to work with
loc=~/public_html/videos
StartDate=20150516
EndDate=20150516

# subtract current date from EndDate and StartDate, return as # of days
# This allows us to specify how many days back we will process
ToEnd="$(( ($(date +%s) - $(date --date="$EndDate" +%s) )/(60*60*24) ))"
ToStart="$(( ($(date +%s) - $(date --date="$StartDate" +%s) )/(60*60*24) ))"

cd $loc

# Set date to the StartDate, grab matching filename, increment startdate, 
# Store file name in dates array
i=$ToStart
dates=()
while [ $i -ge $ToEnd ]; do
	TheDate=$(date -d "$i days ago" +"%Y%m%d")
	filename="$(ls $TheDate*.mpeg.ts)"
	i=$((i-1))
	dates+=($filename)
done

# Format array as string in files variable, changing space delimiter to pipe
# Read files string out as part of avconv cmd to compile range of videos

files=$(echo ${dates[@]} | tr ' ' '|')
echo $files >> $loc/files.txt
avconv -y -isync -i "concat:$files|" -c copy $loc/combined/$StartDate-$EndDate.mp4
