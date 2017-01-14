#!/bin/bash

## Start up rails server to get rtmp address

## get rtmp address

## start streaming
ffmpeg \
	-re \
	-ar 44100 -ac 2 -acodec pcm_s16le -f s16le -ac 2 -i /dev/zero -f h264 -i - -vcodec copy -acodec aac -ab 128k -g 120 -strict experimental -f flv $1
