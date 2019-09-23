#!/bin/bash

root=/mnt/storage/archives/repos
tasksdir=/opt/archiving-tasks

~/.keychain/raspberrypi-sh

for dir in $root/*/

do
    dir=${dir%*/}
    archivename=$(basename "$dir")
    current_log="${tasksdir}/${archivename}-backup.log"
    echo "$current_log"
    date >> "${current_log}"
    cd ${root}/"${dir##*/}" || exit
    git pull origin master >> "${current_log}"
    echo "--END--" >> "${current_log}"
done

