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

##################################################################################
# temporary configuration of the BUSCO env in the absence of a singularity image #
##################################################################################
. /appli/bioinfo/busco/5.0.0/env.sh
##################################################################################

# Run BUSCO
CMD="busco -i $TRANSCRIPTOME -o $OUTPUT -l $LINEAGE -m transcriptome -c $NCPUS --offline"
echo $CMD > $LOGCMD
eval $CMD
