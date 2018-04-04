#!/bin/bash -x

SITE_ID=""
SITE_DESC=""
WIN_DESTINATION_DIR="/home/sandaya/Desktop/PollData/"
WIN_SOURCE_DIR="/home/sandaya/Public/PollData/"


if [ ! -d "${WIN_DESTINATION_DIR}" ]; then
  echo "${WIN_DESTINATION_DIR} not found!"
  exit 1
fi

for source in ${WIN_SOURCE_DIR}  
do
  WIN_SOURCE_DIR=${source%*/}
  echo ${WIN_SOURCE_DIR}


  cd ${WIN_SOURCE_DIR}
  pwd
  sites="Site*"
  echo "Sites: ${sites}"

  for dirc in ${sites} 
  do
    pwd
    dir=${dirc%*/}
    echo "Dir: ${dir}"
    SITE_ID=${dir:4}

    cd "${dir}"
    for subdir in *
    do 
      pwd
      subdir=${subdir%*/}
      cd "${subdir}"
      echo "subdir: ${subdir}"

      date_past=$(date -d "-0 days" +%Y%m%d%H0000)
      date_today=$(date +%Y%m%d)


      for file in *
      do
        pwd
    	  filer=${file%*/}
        echo "file: ${filer}"

        filedte_part=${filer##*_}
        echo "filedte_part: ${filedte_part}"

        dte_part=${filedte_part:0:14}
        echo "det_part: ${dte_part}"

        if [ "${dte_part}" -gt "${date_past}" ]; then
          echo "gt"
          continue
        fi
        if [ ! -d "${WIN_DESTINATION_DIR}${dir}/${subdir}" ]; then
          mkdir -p "${WIN_DESTINATION_DIR}${dir}/${subdir}"
        fi
        echo "${filer}" "${WIN_DESTINATION_DIR}${dir}/${subdir}/${filer}"
        if [ ! -f "${WIN_DESTINATION_DIR}${dir}/${subdir}/${filer}" ]; then
          mv "${filer}" "${WIN_DESTINATION_DIR}${dir}/${subdir}/${filer}"
          # echo "${subdir}/${filer} ---> ${WIN_DESTINATION_DIR}${dir}\\${subdir}\\${filer}"
        fi
      done
      cd ..
    done
    cd ..
  done
done 
