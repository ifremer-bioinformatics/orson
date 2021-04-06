#!/usr/bin/env bash
###############################################################################
##                                                                           ##
## Purpose of script: Download databases                                     ##
##                                                                           ##
###############################################################################

# var settings 
args=("$@")
DB_DIR=${args[0]}
WK_DIR=${args[1]}
BANK_LIST=${args[2]}
DB_OK=${args[3]}
LOGCMD=${args[4]}

export KL_mirror__path="$DB_DIR"
mkdir -p $KL_mirror__path
export KL_WORKING_DIR="$WK_DIR"
mkdir -p $KL_WORKING_DIR
export KL_JRE_ARGS="-Xms128M -Xmx2048M -Djava.io.tmpdir=$KL_WORKING_DIR -DKL_LOG_TYPE=console"


if [ ! -d "$DB_DIR" ] || ([ -d "$DB_DIR" ] && [ ! "$(ls -A $DB_DIR)" ])
then
    # Download databases
    CMD="install.sh -desc $BANK_LIST"

    echo $CMD > $LOGCMD
    eval $CMD
fi

if [[ -d "$DB_DIR" && -n "$(ls -A "$DB_DIR")" ]]
then
    # DB ok
    CMD="touch $DB_OK"
    echo $CMD >> $LOGCMD
    eval $CMD
else
# DB ok
    CMD="touch missing_db"
    echo $CMD >> $LOGCMD
    eval $CMD
fi
