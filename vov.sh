#!/usr/bin/env bash
OAKEY='YOUR_OMLET_ARCADE_KEY_HERE'
ffmpeg \
	-re \
	-i https://str.vov.gov.vn/vovlive/vov1vov5Vietnamese.sdp_aac/playlist.m3u8 \
	-stream_loop -1 \
  -i output.mp4 \
	-map 0:a \
	-map 1:v \
	-flvflags \
	no_duration_filesize \
	-c copy \
	-f flv rtmp://push.c1.omlet.gg/live/$OAKEY
