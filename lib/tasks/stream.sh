#!/bin/bash

## Start up rails server to get rtmp address

## get rtmp address

## start streaming
ffmpeg \
  -y \
  -thread_queue_size 1024 \
  -re \
  -f alsa \
  -thread_queue_size 1025 \
  -i hw:2,0 \
  -f v4l2 \
  -thread_queue_size 1026 \
  -i /dev/video0 \
  -vcodec h264 \
  -acodec aac \
  -strict experimental \
  -f flv \
  -b:v 300k \
  -bufsize 300k $1
