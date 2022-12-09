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
QTYPE=${args[4]}
LOGCMD=${args[5]}

if $QTYPE == 'n';
then
        ANALYSE="transcriptome"
else
        ANALYSE="proteome"
fi


# Run BUSCO
CMD="busco -i $TRANSCRIPTOME -o $OUTPUT -l $LINEAGE -m $ANALYSE -c $NCPUS "
echo $CMD > $LOGCMD
eval $CMD
