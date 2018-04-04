#!/bin/bash -vx
source ./config/$1
rs232_command="$2"
file_desc="$3"

echo "rs232_command: ${rs232_command}"
echo "file_desc: ${file_desc}"
sleep 3

SOURCE_DIR="/home/sandaya/Public/PollData"
if [ ! -d ${SOURCE_DIR} ] ; then
  echo "Destination dir ${SOURCE_DIR} not found!"
  exit 1
fi


date_today="$(date +'%Y%m%d')"
date_time="$(date +'%Y%m%d%H%M%S')"

dest_dir="${SOURCE_DIR}/Site${site_id}/${rs232_command}"
file_path="${dest_dir}/${site_id}_${file_desc}_${date_time}-0000.txt"
if [ ! -d "${dest_dir}" ]; then
  mkdir -p ${dest_dir}
fi
sleep 5
sshpass -p Test*tagz ssh -p${console_port} -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null tlseng@${console_ip} "(echo -e \\\\001${rs232_command}; sleep 3; echo -e \\\\035quit; sleep 1) | telnet localhost 2112 | grep -i ${rs232_command}" >  ${file_path}
wait
sync -f ${file_path}
cat ${file_path}
sleep 3
if [ -s "$file_path" ]
then 
   echo "Success! File exists and is not empty "
else
   echo "Failure! File does not exist, or is empty "
fi
exit 0


