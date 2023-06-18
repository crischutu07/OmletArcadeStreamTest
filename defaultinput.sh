#!/usr/bin/env bash
# This file using server source as a video
# > CAUTION: You'll get black screen if the server
# > Only uses audio input
SOURCE='YOUR_INPUT_SERVER_HERE' # can be an video file
RTMP='YOUR_SERVER_STREAMING_HERE'
KEY='YOUR_KEY_HERE'
ffmpeg \
	-re \
	-i $SOURCE \
	-stream_loop -1 \
	-map 0:a \
	-map 0:v \
 	-b:v 10k \
  	-b:a 15k \
	-flvflags no_duration_filesize \
	-c copy \
	-f flv $RTMP/$KEY
