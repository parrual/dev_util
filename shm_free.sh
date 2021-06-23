#!/bin/bash

# include
source $DEV_UTIL/include.sh

# main
cyan_echo "===== Script [shm_free.sh] is executed. ====="

cmd="$(ipcs -m | grep $1 | awk '{ print $2 }')"
if [ -n cmd ]; then 
    cyan_echo "Try to Remove Shared Memory: $cmd"
    ipcrm -m $cmd
    cyan_echo "Complete to Remove Shared Memory: $cmd" 
fi
