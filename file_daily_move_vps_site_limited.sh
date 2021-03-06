#!/bin/bash 
source ./config/$1

SITE_ID="${site_id}"
PAST_DAYS_FROM="$2"
PAST_DAYS_TO="$3"

echo "${SITE_ID} ${PAST_DAYS_FROM} ${PAST_DAYS_TO}"

for ((i = ${PAST_DAYS_FROM};  i >= ${PAST_DAYS_TO}; i--  )) {

  echo ${i}
}


SITE_DESC=""
WIN_DESTINATION_DIR="Z:/VPS-PollData/"
WIN_SOURCE_DIR_win7TE="\\\\sim-en-bwhit6\\VPS-PollData\\"


if [ ! -d "${WIN_DESTINATION_DIR}" ]; then
  net use Z: \\\\10.20.95.59\\AVA /user:sandaya xpoint6
  if [ $? -ne 0 ]; then
    echo "${WIN_DESTINATION_DIR} not found!"
    exit 1
  fi
else
   echo "${WIN_DESTINATION_DIR} found!"
fi

for source in ${WIN_SOURCE_DIR_win7TE}
do
  WIN_SOURCE_DIR=${source%*/}
  echo ${WIN_SOURCE_DIR}


  if [ ! -d "${WIN_SOURCE_DIR}" ] ; then
    net use I: "${WIN_SOURCE_DIR}"
    if [ $? -ne 0 ]; then
      echo "${WIN_SOURCE_DIR} not found!"
      continue
    fi
  else   
    echo "${WIN_SOURCE_DIR} found!"
  fi  

  cd ${WIN_SOURCE_DIR}
  pwd
  sites="Site*"
  echo "Sites: ${sites}"

  for dirc in Site${SITE_ID} 
  do
    pwd
    dir=${dirc%*/}
    echo "Dir: ${dir}"

    cd "${dir}"
    for subdir in *
    do 
      pwd
      subdir=${subdir%*/}
      if [[ ${subdir} == *"i@55"* ]]; then
        SITE_DESC="ProbeSamples"
      elif [[ "${subdir}" == *"i&14"* ]]; then
        SITE_DESC="UllagePressure"
      elif [[ "${subdir}" == *"i@C3"* ]]; then
        SITE_DESC="DimEvents"
      fi
      echo "subdir: ${subdir} ${SITE_DESC}"
      cd "${subdir}"

      date_past=$(date -d "-${PAST_DAYS_TO} days" +%Y%m%d%H0000)
      date_today=$(date +%Y%m%d)

      for ((i = ${PAST_DAYS_FROM};  i >= ${PAST_DAYS_TO}; i--  )) {
        pwd
        vps_files="${SITE_ID}_${SITE_DESC}_$(date -d "-$i days" +%Y%m%d)*.txt" 
      
        ls ${vps_files}
        if [ $? -ne 0 ]; then
          continue
        fi

        for file in ${vps_files}
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
          echo "${filer}" "${WIN_DESTINATION_DIR}${dir}\\${subdir}\\${filer}"
          if [ ! -f "${WIN_DESTINATION_DIR}${dir}${subdir}\\${filer}" ]; then
            echo "${filer} ----> ${WIN_DESTINATION_DIR}${dir}\\${subdir}\\${filer}"
            mv -fv "${filer}"  "${WIN_DESTINATION_DIR}${dir}\\${subdir}\\${filer}"
          fi
        done
      }
      cd ..
    done
    cd ..
  done
done 
