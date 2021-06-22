#!/bin/bash

function cyan_echo(){
    echo -e "\033[0;96m${1}\033[0m"
}

function red_echo(){
    echo -e "\033[0;91m${1}\033[0m"
}

function exist_check_tbhome {
    flag=0
    for sub_dir in $(ls -d ${1}/*/); do
        if [ "${sub_dir%%/}" = "${2}" ]; then
            flag=1
        fi
    done
    echo $flag
}

function exist_check_dir() {
    flag=0
    for sub_dir in $(ls -d ${1}/*/); do
        if [ "${sub_dir%%/}" = "$1/${2}" ]; then
            flag=1
        fi
    done
    echo $flag
}

function exist_check_file() {
    flag=0
    for sub_file in $(ls -ap ${1} | grep -v '/$'); do
        if [ "${sub_file}" = "${2}" ]; then
            flag=1
        fi
    done
    echo $flag
}

function exist_check() {
    flag=0
    for sub_thing in $(ls -a ${1}); do
        if [ "${sub_thing}" = "${2}" ]; then
            flag=1
        fi
    done
    echo $flag
}

function work_well {
    echo "argv: $1 $2"
    if [ "${1}" = "${2}" ]; then 
        cyan_echo "works well.."
    else
        red_echo "works wrong.."
    fi
}

if [ "${1}" = "test" ]; then
    {
        work_well "1" "1"
        work_well "1" "0"
    }
    {
        work_well `echo $(exist_check_dir "./test" "path")` "1" 
        work_well `echo $(exist_check_dir "./test" "no_path")` "0" 
    }
    {
        work_well `echo $(exist_check_file "./test" "file")` "1"
        work_well `echo $(exist_check_file "./test" "no_file")` "0"
    }
    {
        work_well `echo $(exist_check "./test" "file")` "1"
        work_well `echo $(exist_check "./test" "no_file")` "0"   
        work_well `echo $(exist_check "./test" "path")` "1"
        work_well `echo $(exist_check "./test" "no_path")` "0"
    }
fi
