#!/bin/sh

##
# This script is for re-encoding ac3 or dts codec.
#
# Prerequisite
#   - ffmpeg : https://trac.ffmpeg.org/wiki/Encode/AAC
##

#######################################################################
help () {
    echo "The tools for re-encoding ac3 or dtc codec."
    echo "Input video will be moved into `orig` directory if re-encoded."
    echo "Output file will be saved into `reencoded` directory."
    echo "usage: ./ac3_dts_killer.sh directory"
}
#######################################################################

## [Precondition] Arguments verification
if [ -z $1 ] || [ $1 = "-h" ] || [ $1 = "--help" ]; then
    help
    exit
elif [ ! -d $1 ]; then
    echo "$1 is not a directory."
    exit
fi

## [Precondition] Check ffmpeg
readonly FFMPEG=$( which ffmpeg )
if [ -z $FFMPEG ] || [ ! -f $FFMPEG ]; then
    echo "ffmpeg not found"
    exit
fi

## Step 1. Path handling
readonly SCRIPT_PATH="$( readlink -f $0)"
readonly SCRIPT_DIR="$( dirname $SCRIPT_PATH )"
readonly CURRENT_DIR="$PWD"
readonly TARGET_DIR="$( readlink -f $1 )"
readonly LOGS="$TARGET_DIR/logs.txt"

echo "===== Step 1. Show context"       >> "${LOGS}"
echo "  - current dir : $CURRENT_DIR"   >> "${LOGS}"
echo "  - script path : $SCRIPT_PATH"   >> "${LOGS}"
echo "  - target dir  : $TARGET_DIR"    >> "${LOGS}"
echo "  - ffmpeg path : $FFMPEG"        >> "${LOGS}"
echo ""

# Step 2. Prepare target directory that will be save re-encoded videos.
readonly backup_dir="$TARGET_DIR/orig"
readonly out_dir="$TARGET_DIR/reencoded"

echo "===== Step 2. Create target directory ====="  >> "${LOGS}"
echo "  - backup dir : $backup_dir"     >> "${LOGS}"
echo "  - output dir : $out_dir"        >> "${LOGS}"
echo ""

mkdir -p "$backup_dir"
mkdir -p "$out_dir"

# Step 3. Re-encode
echo "===== Step 3. Re-encode ====="    >> "${LOGS}"
# Step 3.1. Search video list
idx=1
find ${TARGET_DIR} -maxdepth 1 -type f -not -path '*git' -not -path '*git/.git' -not -path 'Thumb.db' | while read line; do
    input="$line"
	filename="$(basename "$input")"
	extension="${filename##*.}"
	filename="${filename%.*}"
    output="${out_dir}/${filename}__aac.${extension}"

    echo "process ${line}"
	echo "($idx) ${line}"               >> "${LOGS}"
    echo "  - filename : ${filename}"   >> "${LOGS}"
    echo "  - extension: ${extension}"  >> "${LOGS}"
	echo "  - output   : $output"       >> "${LOGS}"

    $FFMPEG -nostdin -loglevel error -i "${input}" -c:v copy -c:a libfdk_aac -vbr 3 "$output" -y
    if [ "$?" -ne "0" ]; then
        echo "  - FAILED"                                   >> "${LOGS}"
    else
        echo "  - reencode successfully"                    >> "${LOGS}"
        echo "  - move input file to backup directory"      >> "${LOGS}"
        mv "$input" "$backup_dir"
    fi
        
	idx=`expr $idx + 1`
done
