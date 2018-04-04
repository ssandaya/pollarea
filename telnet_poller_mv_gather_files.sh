#!/bin/bash -v
net use g: \\\\sim-en-sandaya\\Users\\simulate\\VPS-PollData
if [ $? -ne 0 ]
then
	echo "failed to connect"
	exit 1
else
	echo "connected"
fi

for d in g:/Site*
do
  dir = d
  echo ${dir}

  # cd ${dir}
  # for subdir in *
  # do 
  #   pwd

  #   subdir=${subdir%*/}
  #   cd "${subdir}"
    
  # done
  # cd ..
done


net use g: /delete
if [ $? -ne 0 ]
then
	echo "failed to delete"
	exit 1
else
	echo "deleted"
fi
