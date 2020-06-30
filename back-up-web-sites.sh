#!/bin/bash

serveraddress=$1
serverbasedir=$2
domain=$3
root=/mnt/storage/archives/web-sites/${domain}
serverroot=${serverbasedir}/${domain}
tasksdir=/opt/archiving-tasks

if [[ ! $serverbasedir ]] || [[ ! $domain ]]; then
  printf "Usage: ./back-up-web-sites.sh <server address> <containing directory path on server, e.g. /usr/share/nginx/html> <domain, e.g. smidgeo.com>\n\nThis script depends on the directory corresponding to the directory on the server existing on the backup server.";
  exit 1;
fi

~/.keychain/raspberrypi-sh

for dir in $root/*/

do
    dir=${dir%*/}
    archivename=$(basename "$dir")
    current_log="${tasksdir}/${domain}-${archivename}-backup.log"
    echo "$current_log"
    echo "--START--" >> "${current_log}"
    date >> "${current_log}"
    cd "${root}/${dir##*/}" || exit
    rsync -a "bot@${serveraddress}:${serverroot}/${archivename}/" .  >> "${current_log}"
    echo "--END--" >> "${current_log}"
done
