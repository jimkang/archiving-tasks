#!/bin/bash

# Unlike back-up-web-sites.sh, this backs up the web site at the location in the
# arguments iterating through web sites at subdirectories of that location.
serveraddress=$1
serverbasedir=$2
domain=$3
root=/mnt/storage/archives/web-sites/${domain}
serverroot=${serverbasedir}/${domain}
tasksdir=/opt/archiving-tasks
user=$(whoami)

if [[ ! $serverbasedir ]] || [[ ! $domain ]]; then
  printf "Usage: ./back-up-single-web-site.sh <server address> <containing directory path on server, e.g. /usr/share/nginx/html> <domain, e.g. smidgeo.com>\n\nThis script depends on the directory corresponding to the directory on the server existing on the backup server.";
  exit 1;
fi

dir=${root%*/}
archivename=$(basename "$dir")
current_log="${tasksdir}/${archivename}-backup.log"
error_log="${tasksdir}/${archivename}-backup-error.log"
echo "--START--" >> "${current_log}"
date >> "${current_log}"
date >> "${error_log}"
# You need to use source here. You can't just execute
# that file and expect the exports to get the env vars
# out there, for some reason.
source ~/.keychain/raspberrypi-sh
echo "SSH_AGENT_PID: ${SSH_AGENT_PID}" >> "${current_log}"
echo "SSH_AUTH_SOCK: ${SSH_AUTH_SOCK}" >> "${current_log}"
echo "USER: ${user}" >> "${current_log}"
echo "DIR: ${root}" >> "${current_log}"
echo "serverroot: ${serverroot}" >> "${current_log}"
cd "${root}" || exit 1
rsync -azv --progress --exclude '.git' -e "ssh -i /home/pi/.ssh/id_rsa" bot@${serveraddress}:${serverroot}/ . >> ${current_log} 2>> ${error_log}
echo "--END--" >> "${current_log}"
