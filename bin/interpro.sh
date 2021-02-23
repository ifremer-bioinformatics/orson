#!/usr/bin/env bash
###############################################################################
##                                                                           ##
## Purpose of script: Run InterproScan                                       ##
##                                                                           ##
###############################################################################

# var settings 
args=("$@")
NCPUS=${args[0]}
QUERY=${args[1]}
Q_TYPE=${args[2]}
OUTPUT_DIRNAME=${args[3]}
LOGCMD=${args[4]}
CHUNK_NAME=$(basename ${QUERY%.*})
CHUNK_OUTPUT_NAME=${CHUNK_NAME}_${OUTPUT_DIRNAME}

mkdir $CHUNK_OUTPUT_DIRNAME

# Run IPRScan
CMD="interproscan.sh -dp -i $QUERY -t $Q_TYPE -f xml -cpu $NCPUS -o $CHUNK_OUTPUT_NAME -appl Pfam -app ProSiteProfiles -appl CDD -appl TIGRFAM -appl PRINTS -appl SMART -appl SUPERFAMILY -appl Hamap"
echo $CMD > $LOGCMD
eval $CMD
