#!/bin/bash
source $DEV_UTIL/include.sh

pwd=`pwd` 
file_name="$1.sh"

is_exist=$(exist_check_file "${DEV_UTIL}" "${file_name}") 
if [ $is_exist -eq 0 ]; then
    cp "${DEV_UTIL}/script.templete" "$pwd/${file_name}"
    line='cyan_echo "'"===== Script [$file_name] is executed. ====="'"'
    echo "$line" >> $file_name
    if [ ${pwd} != $DEV_UTIL ]; then
        mv ${file_name} ${DEV_UTIL}/${file_name}
    fi
else
    red_echo "That file is already existed. Please re-name for the file and retry." 
fi

