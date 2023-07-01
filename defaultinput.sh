#!/usr/bin/env bash
# This file using server source as a video
# > CAUTION: You'll get black screen if the server
# > Only uses audio input
SOURCE='YOUR_INPUT_SERVER_HERE' # can be an video file
RTMP='YOUR_SERVER_STREAMING_HERE'
KEY='YOUR_KEY_HERE'
default_config='config.json' # must be json
function setup (){
	if [[ "$(find $default_config)" != "$default_config" ]];
		echo "prepare setup"
	else
		exit 0;
	fi
}
function help (){
	echo '''List of arguments:
-f Default file source (required)
-s Streaming sources (required)
-k Streaming key (optional)'''
}
while getopts 'f:s:k:h' option; do
	case $option in 
		f) SOURCE=$OPTARG;;
		s) RTMP=$OPTARG;;
		k) KEY=$OPTARG;;
		h) help;;
		\?) echo "invaild"; exit 1;;

	esac
done
function main (){
if [[ $@ == "" ]]; then
	help; exit 1
fi
echo "SOURCE: $SOURCE"
echo "RTMP: $RTMP"
echo "KEY: $KEY"
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
}
main "$@"