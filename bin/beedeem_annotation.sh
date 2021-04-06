#!/usr/bin/env bash
###############################################################################
##                                                                           ##
## Purpose of script: Run hit annotation using BeeDeeM                       ##
##                                                                           ##
###############################################################################

# var settings 
args=("$@")
DB_DIR=${args[0]}
WK_DIR=${args[1]}
XML_FILES=${args[2]}
ZML_OUT=${args[3]}
TYPE=${args[4]}
LOGCMD=${args[5]}
CHUNK_NAME=$(basename ${XML_FILES%.*})
CHUNK_ZML_OUT_NAME=${CHUNK_NAME}_${ZML_OUT}

# Run BeeDeeM
export KL_mirror__path=$DB_DIR
export KL_WORKING_DIR=$WK_DIR
export KL_JRE_ARGS="-Xms128M -Xmx2048M -Djava.io.tmpdir=$KL_WORKING_DIR -DKL_LOG_TYPE=console"

CMD="annotate.sh -i $XML_FILES -o $CHUNK_ZML_OUT_NAME -type $TYPE -writer zml"
echo $CMD > $LOGCMD
eval $CMD
