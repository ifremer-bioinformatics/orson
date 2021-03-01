#!/usr/bin/env bash
###############################################################################
##                                                                           ##
## Purpose of script: Run hit annotation using BeeDeeM                       ##
##                                                                           ##
###############################################################################

# var settings 
args=("$@")
XML_FILES=${args[0]}
ZML_OUT=${args[1]}
TYPE=${args[2]}
LOGCMD=${args[3]}
CHUNK_NAME=$(basename ${XML_FILES%.*})
CHUNK_ZML_OUT_NAME=${CHUNK_NAME}_${ZML_OUT}

####################################################################################
# temporary configuration of the BeeDeeM env in the absence of a singularity image #
####################################################################################
ANNOTATE_SCRIPT=/appli/bioinfo/beedeem/4.6.0/annotate.sh
. /etc/profile.d/modules.sh
module load java/1.8.0_121
##################################################################################

# Run BeeDeeM
KL_WORKING_DIR=$PWD

CMD="$ANNOTATE_SCRIPT -i $XML_FILES -o $CHUNK_ZML_OUT_NAME -type $TYPE -writer zml"
echo $CMD > $LOGCMD
eval $CMD
