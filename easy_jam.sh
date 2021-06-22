#!/bin/bash

# include
source $DEV_UTIL/include.sh

cond1="\n
 [1] 6 main\n 
 [2] 6 related\n
 [3] 6 TAC\n
 [4] 5 related
"

function set_tbhome(){
    case $1 in
        1) # 6 main
            TB_DIR=`echo ~/tibero`
            TB_HOME=`echo $TB_DIR/6`
            TB_VER="6";;
        2) # 6 related
            TB_DIR=`echo ~/hdd/branches/6_rel`;;
        3) # 6 TAC
            TB_DIR=`echo ~/hdd/branches/6_tac`;;
        4) # 5 related
            TB_DIR=`echo ~/hdd/branches/5_rel`;;
        *) # default
            echo " MUST execute with one argument."
            echo -e $cond1
            echo -e "\n Please retry."
    esac 
    echo " Working Directory is [ $TB_DIR ]."

    while [ -z `echo $TB_HOME` ]; do
        echo " TB_HOME is not set yet. Which version do you want?"
        read fixset coreset

        if [ ${fixset} -gt -1 -a ${fixset} -lt 10 -a ${coreset} -gt 1000 -a ${coreset} -lt 10000 ]; 
        then
            TB_VER="FS0${fixset}_CS_${coreset}"
            TB_HOME="${TB_DIR}/${TB_VER}"
        fi
    done

    flag=$(exist_check_tbhome "${TB_DIR}" "${TB_HOME}") 

    if [ "${flag}" = "0" ]; then
        echo " TB_HOME is not existed in TB_DIR: TB_HOME is [ $TB_HOME ], but path is [ $TB_DIR ]."
        result="0"
    else
        result="1"
    fi
}

# main
cyan_echo "===== Script [easy_jam.sh] is executed. ====="

# 0. if TB_HOME is not set, then set it.
set_tbhome ${1}
if [ "${result}" = "1" ]; then
    echo " Current TB_HOME is [ $TB_HOME ]."
    {
        cd $TB_HOME;
        . tbenv $TB_HOME tibero;

        if [ ! -d ./tools/prebuilt ]; then
            cd tools;
            ln -s ~/tibero/prebuilt prebuilt;
            cd ..;
        fi

        cd src;
        cp ~/tibero_Backup/jamrule Jamrules.local;

        cd autoconf;
        ./configure;
        cd ..;
        cyan_echo "\n==========[JAM AUTOCONF START]=========="
        jam autoconf;
        cyan_echo "\n===========[JAM AUTOCONT END]==========="
        if [ ! -d $TB_HOME/tools/bin/ -o ! -d $TB_HOME/tools/sbin/ ]; then
            cyan_echo "\n============[JAM TOOL START]============"
            jam tool;
            cyan_echo "\n=============[JAM TOOL END]============="
        fi
        cyan_echo "\n===============[JAM START]=============="
        jam -j10;
        cyan_echo "\n================[JAM END]==============="
    }
else
    red_echo "\nPlease retry."
fi
