#!/usr/bin/env bash
# This file using server source as a video
# > CAUTION: You'll get black screen if the server
# > Only uses audio input
default_config='config.yml' # must be yaml
# https://stackoverflow.com/questions/5014632
function yaml {
   local prefix=$2
   local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
   sed -ne "s|^\($s\):|\1|" \
        -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
   awk -F$fs '{
      indent = length($1)/2;
      vname[indent] = $2;
      for (i in vname) {if (i > indent) {delete vname[i]}}
      if (length($3) > 0) {
         vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
         printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
      }
   }'
}
function help (){
	echo """List of arguments:
-f Default file source (required)
-s Streaming sources (required)
-k Streaming key (optional)"""
}
if [[ "$(find $default_config &> /dev/null; echo "$?")" != "0" ]]; then
   echo "Let's get started!"
   read -p "What path do you want to set as a video? (could be a link source/required): " SOURCE
   if [[ "$SOURCE" == "" ]]; then
      echo "Video path/source required, please try again"
      exit 1
   fi
   read -p "Please provide streaming service also? (requied/must run RTMP): rtmp://" SRTMP
   if [[ "$RTMP" == "" ]]; then
      echo "Streaming server required, please try again"
      exit 1
   fi
   read -p "Please provide with a stream key (optional): " KEY
echo """
file_path: '$(pwd)/$SOURCE' # can be a link source
rtmp_source: '$RTMP'
rtmp_key: '$KEY'
""" > $default_config
echo "setup is done, please now run ./defaultinput.sh"
exit 0
fi

while getopts 'f:s:k:h' option; do
	case $option in 
		f) SOURCE=$OPTARG;;
		k) KEY=$OPTARG;;
		s) RTMP=$OPTARG;;
		h) help;;
		\?) echo "invaild"; exit 1;;
	esac
done
function main (){
if [[ "$*" == "" ]]; then
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