#!/bin/bash

# include
source $DEV_UTIL/include.sh

# main
cyan_echo "===== Script [easy_tac.sh] is executed. ====="

if [ "$TB_HOME" != `echo \`pwd\`` ]; then
    echo "Please check \$TB_HOME and current path."
    echo "TB_HOME: $TB_HOME"
else
    {   # generate tip files with UTF-8
        cyan_echo "STEP 0: Get neo-gen scripts"
        echo `pwd` 
        cp ~/tibero_Backup/gen_tip_for_tac.sh $TB_HOME/config
        cp ~/tibero_Backup/tbctl $TB_HOME/bin
    }
    {
        cd $TB_HOME
        cyan_echo "STEP 1: Make Tip Files."
        cd config
        rm cm.*.tip
        rm tibero*.tip
        rm psm_commands
        rm $TB_HOME/client/config/tbdsn.tbr

        ./gen_tip_for_tac.sh -n 2 -s tibero
    }
    {
        cd $TB_HOME
        cyan_echo "STEP 2: New Mount."
        tb_newmount.sh -n 2 -s tibero
    }
fi


