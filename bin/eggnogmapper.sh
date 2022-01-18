#!/usr/bin/env bash
###############################################################################
##                                                                           ##
## Purpose of script: Run eggNOG mapper search                               ##
##                                                                           ##
###############################################################################

# var settings 
args=("$@")
NCPUS=${args[0]}
Q_TYPE=${args[1]}
QUERY=${args[2]}
OUTPUT_NAME=${args[3]}
LOGCMD=${args[4]}


# Run eggNOG mapper
if [ "$Q_TYPE" = "n" ]; then
    CMD="emapper.py -m diamond --itype CDS --sensmode more-sensitive --cpu $NCPUS -i $QUERY -o $OUTPUT_NAME"
    echo $CMD > $LOGCMD
    eval $CMD
else
    CMD="emapper.py --sensmode more-sensitive --cpu $NCPUS -i $QUERY -o $OUTPUT_NAME"
    echo $CMD > $LOGCMD
    eval $CMD
fi
