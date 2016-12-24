#!/bin/bash

################# usage

usage() {
	if [ $# -lt 2 ]; then
		echo "usage: $0 filename max_duration"
		exit 1
	fi
}

usage $@

#########################

cmd=eval
if [ ${DRY_RUN} ]; then cmd=echo; fi

filename=$1
max_duration=$2
file_duration=`avprobe ${filename} -show_format -v quiet | sed -n 's/duration=//p'`
file_duration=$((${file_duration%.*}+1))

file_extension=${filename##*.}
file_basename=${filename%.*}

part=0
position=0

time while [ "${position}" -lt "${file_duration}" ]; do
	part=$((part+1))
	${cmd} avconv -ss ${position} -i ${filename} -t ${max_duration} -vcodec copy -acodec copy -v info ${file_basename}_part${part}.${file_extension}

	position=$((position+max_duration))
done
