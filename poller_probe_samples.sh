#!/bin/bash -vx
source ./config/$1
rs232_command="$2"
file_desc="$3"

echo "rs232_command: ${rs232_command}"
echo "file_desc: ${file_desc}"
sleep 30

date_today="$(date +'%Y%m%d')"
date_time="$(date +'%Y%m%d%H%M%S')"
#i@5501
dest_dir="/cygdrive/c/cygwin64/home/simulate/proc/polldata/costco/${date_today}/${site_id}/${rs232_command}/"
echo ${dest_dir}
mkdir -p ${dest_dir}
sleep 5
file_path="${dest_dir}/${site_id}-${file_desc}-${date_time}-0000.txt"
echo ${dest_dir}
mkdir -p ${dest_dir}
sleep 5
(echo -e \\001${rs232_command}; sleep 5; echo -e \\035quit; sleep 5) | telnet ${console_ip} ${console_port} | grep -i "${rs232_command}" >  ${file_path}
wait
sync -f ${file_path}
sleep 30
exit 0
