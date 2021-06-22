#!/bin/bash
#Script for building tibero 5,6 more easily

start="\n
+-----------------------------+\n
| TIBERO EAAAAAASY JAM v0.0.0 |\n
+-----------------------------+
"
cond1="\n
 [1] 6 main\n 
 [2] 6 related\n
 [3] 6 TAC\n
 [4] 5 related
"
function set_tbhome(){
    while [ -z `echo $TB_HOME` ]; do
        case $1 in
            1) # 6 main
                TB_DIR=`echo ~/tibero`
                TB_HOME=`echo $TB_DIR/6`;;
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

        if [ $1 != 1 ]; then
            echo " Working Directory is [ $TB_DIR ]."
        fi 

        if [ -z `echo $TB_HOME` ]; then
            echo " TB_HOME is not set yet. Which version do you want?"
            read fixset coreset

            if [ ${fixset} -gt -1 -a ${fixset} -lt 10 -a ${coreset} -gt 1000 -a ${coreset} -lt 10000 ]; then
                TB_VER="FS0${fixset}_CS_${coreset}"
                TB_HOME="${TB_DIR}/${TB_VER}"
            fi
        fi
    done
}

echo -e $start

# 0. if TB_HOME is not set, then set it.
set_tbhome "${1}"

flag=0
for sub_dir in $(ls -d ${TB_DIR}/*/); do
    if [ "${sub_dir%%/}" = "$TB_HOME" ]; then
        flag=1 
    fi
done
if [ $flag -eq 0 ]; then
    echo " TB_HOME is not matched with path argument: TB_HOME is [ $TB_HOME ], but path is [ $TB_DIR ]."
    echo -e $cond1
    echo -e "\n Please retry with other argument."
    unset TB_HOME
    read new_arg
    set_tbhome "${new_arg}"
fi

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
    echo -e "\033[1;34m ==========[JAM AUTOCONF START]==========\033[0m"
    jam autoconf;
    echo -e "\033[1;34m ===========[JAM AUTOCONT END]===========\033[0m"
    if [ ! -d $TB_HOME/tools/bin/ -o ! -d $TB_HOME/tools/sbin/ ]; then
        echo -e "\033[1;34m ============[JAM TOOL START]============\033[0m"
        jam tool;
        echo -e "\033[1;34m =============[JAM TOOL END]=============\033[0m"
    fi
    echo -e "\033[1;34m ===============[JAM START]==============\033[0m"
    jam -j10;
    echo -e "\033[1;34m ================[JAM END]===============\033[0m"
}

