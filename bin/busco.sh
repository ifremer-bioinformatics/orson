#!/usr/bin/env bash
###############################################################################
##                                                                           ##
## Purpose of script: Run BUSCO to evaluate transcriptome completness        ##
##                                                                           ##
###############################################################################

# var settings 
args=("$@")
NCPUS=${args[0]}
TRANSCRIPTOME=${args[1]}
OUTPUT=${args[2]}
LINEAGE=${args[3]}
LOGCMD=${args[4]}

# Run BUSCO
CMD="busco -i $TRANSCRIPTOME -o $OUTPUT -l $LINEAGE -m transcriptome -c $NCPUS --offline"
echo $CMD > $LOGCMD
eval $CMD
