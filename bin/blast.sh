#!/usr/bin/env bash
###############################################################################
##                                                                           ##
## Purpose of script: Run BLAST search                                       ##
##                                                                           ##
###############################################################################

# var settings 
args=("$@")
NCPUS=${args[0]}
Q_TYPE=${args[1]}
QUERY=${args[2]}
DB=${args[3]}
OUTPUT_NAME=${args[4]}
RESTRICTED_SEARCH=${args[5]}
RESTRICTED_TAX_ID=${args[6]}
LOGCMD=${args[7]}
CHUNK_NAME=$(basename ${QUERY%.*})
CHUNK_OUTPUT_NAME=${CHUNK_NAME}_${OUTPUT_NAME}

# Run BLAST
if [ $Q_TYPE = "n" ]; then
        ANALYSE="blastx"
else
        ANALYSE="blastp"
fi

if [ "$RESTRICTED_SEARCH" = "true" ]; then
    CMD="$ANALYSE -query $QUERY -db $DB -out $CHUNK_OUTPUT_NAME -evalue 1e-3 -outfmt 5 -max_target_seqs 20 -max_hsps 1 -num_threads $NCPUS -parse_deflines -taxidlist ${RESTRICTED_TAX_ID}"
    echo $CMD > $LOGCMD
    eval $CMD
else
    CMD="$ANALYSE -query $QUERY -db $DB -out $CHUNK_OUTPUT_NAME -evalue 1e-3 -outfmt 5 -max_target_seqs 20 -max_hsps 1 -num_threads $NCPUS -parse_deflines"
    echo $CMD > $LOGCMD
    eval $CMD
fi
