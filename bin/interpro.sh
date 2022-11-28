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
LOGCMD=${args[3]}
CHUNK_NAME=$(basename ${QUERY%.*})
CHUNK_OUTPUT_NAME=${CHUNK_NAME}_${OUTPUT_DIRNAME}

# Run IPRScan
CMD="interproscan.sh -dp -i $QUERY -t $Q_TYPE -f xml,tsv -cpu $NCPUS  -appl Pfam -app ProSiteProfiles -appl CDD -appl TIGRFAM -appl PRINTS -appl SMART -appl SUPERFAMILY -appl Hamap"
echo $CMD > $LOGCMD
eval $CMD
