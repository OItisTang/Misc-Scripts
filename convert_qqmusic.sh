#!/bin/bash

#######################################################################
# This script is used to convert QQMusic's music file names into      #
# standard form, for example:                                         #
#   convert 1234.tm0 into Beat It_Michael Jackson_Thriller.mp3        #
#                                                                     #
# by Chenggang Tang (OItisTang@gmail.com)                             #
#                                                                     #
# How to use:                                                         #
#   1. copy out qqmusic.sqlite and iMusic folder from QQMusic App     #
#   2. put this script into the same dir as files from step 1         #
#   3. run this script in terminal                                    #
#                                                                     #
#######################################################################

if [ ! -f qqmusic.sqlite ] || [ ! -d iMusic ]; then
    echo "Please copy \"qqmusic.sqlite\" FILE and \"iMusic\" FOLDER from QQMusic App in your iPhone!"
    exit 1
fi

musicdata=`sqlite3 qqmusic.sqlite <<EOF
.separator _
select file, name, singer, album from SONGS where file like "%iMusic%";
EOF`

OLDIFS=$IFS
IFS=$'\n'

if [ "`which id3tag`" != "" ]; then
    HASID3TAG="true"
    echo "id3tag exists! music files' tags will be updated!"
else
    HASID3TAG="false"
    echo "id3tag not exist, so music files' tags will not be updated!"
fi

count=0
for data in $musicdata; do
    data=${data##*\/}
    src=${data%%_*}
    dst=${data#*_}
    if [ -f iMusic/$src ]; then
        echo -e "iMusic/$src\t->  iMusic/$dst.mp3"
        mv "iMusic/$src" "iMusic/$dst.mp3"
        let ++count

        if [ "$HASID3TAG" == "true" ]; then
            IFS='_'
            tags=($dst)
            #echo s"${tags[0]}" a"${tags[1]}" A"${tags[2]}" "iMusic/$dst.mp3"
            id3tag -s"${tags[0]}" -a"${tags[1]}" -A"${tags[2]}" "iMusic/$dst.mp3"
            IFS=$'\n'
        fi
    fi
done

IFS=$OLDIFS

echo "Converted $count!"

