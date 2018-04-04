#!/bin/bash -vx
source ./config/$1
dest_dir="/cygdrive/c/cygwin64/home/simulate/proc/polldata/costco/$(date +'%Y%m%d')/${site_id}/"
echo ${dest_dir}
mkdir -p ${dest_dir}
sleep 5
file_path="${dest_dir}/i@C300/${site_id}-MeterTemp-$(date +'%Y%m%d%H%M%S')-0000.txt"
(echo -e \\001i@C300; sleep 5; echo -e \\035quit; sleep 5) | telnet ${console_ip} ${console_port} | grep -i "i@C300" >  ${file_path}
wait
sync -f ${file_path}
sleep 30
exit 0
