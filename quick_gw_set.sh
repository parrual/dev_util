tb_version=${1}
ora_version=${2}

export TBGW_HOME=/home/wooseok/hdd/branches/6_rel/${tb_version}/gateway
export ORA_CLNT_BASE=/home/wooseok/hdd/oracle
export ORA_CLNT_HOME=$ORA_CLNT_BASE/instant_client_${ora_version}
export PATH=$ORA_CLNT_HOME/bin:$PATH
export LD_LIBRARY_PATH=$ORA_CLNT_HOME/lib:$LD_LIBRARY_PATH
export LIBPATH=$ORA_CLNT_HOME/lib:$LIBPATH

if [ ! -d $TBGW_HOME ]; then
    mkdir $TBGW_HOME
    mkdir $TBGW_HOME/oracle
    mkdir $TBGW_HOME/oracle/config
    mkdir $TBGW_HOME/oracle/log
fi

if [ ! -d $ORA_CLNT_BASE ]; then
    mkdir $ORA_CLNT_BASE
fi

if [ ! -d $ORA_CLNT_HOME ]; then
    mkdir $ORA_CLNT_HOME
fi

cp $TB_HOME/client/bin/gw4orcl_${ora_version} $TBGW_HOME/gw4orcl
cp /home/wooseok/tibero_Backup/tbgw.cfg $TBGW_HOME/oracle/config


