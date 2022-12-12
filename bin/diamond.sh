#!/usr/bin/env bash
###############################################################################
##                                                                           ##
## Purpose of script: Run diamond search                                     ##
##                                                                           ##
###############################################################################

# var settings 
args=("$@")
NCPUS=${args[0]}
Q_TYPE=${args[1]}
QUERY=${args[2]}
DB=${args[3]}
SENSITIVITY=${args[4]}
OUTPUT_NAME=${args[5]}
LOGCMD=${args[6]}
CHUNK_NAME=$(basename ${QUERY%.*})
CHUNK_OUTPUT_NAME=${CHUNK_NAME}_${OUTPUT_NAME}

# Run diamond
if [ "$Q_TYPE" = "n" ]; then
    CMD="diamond blastx -p $NCPUS -d $DB -o $CHUNK_OUTPUT_NAME -f 5 -q $QUERY -k 20 --max-hsps 1 -e 1e-3 --$SENSITIVITY"
    echo $CMD > $LOGCMD
    eval $CMD
else
    CMD="diamond blastp -p $NCPUS -d $DB -o $CHUNK_OUTPUT_NAME -f 5 -q $QUERY -k 20 --max-hsps 1 -e 1e-3 --$SENSITIVITY"
    echo $CMD > $LOGCMD
    eval $CMD
fi
