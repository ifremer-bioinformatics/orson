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
LOGCMD=${args[5]}
CHUNK_NAME=$(basename ${QUERY%.*})
CHUNK_OUTPUT_NAME=${CHUNK_NAME}_${OUTPUT_NAME}

##################################################################################
# temporary configuration of the BLAST env in the absence of a singularity image #
##################################################################################
. /appli/bioinfo/blast/2.9.0/env.sh
##################################################################################

# Run BLAST
if [ "$Q_TYPE" = "n" ]; then
    CMD="blastx -query $QUERY -db $DB -out $CHUNK_OUTPUT_NAME -evalue 1e-3 -outfmt 5 -max_target_seqs 20 -max_hsps 1 -num_threads $NCPUS"
    echo $CMD > $LOGCMD
    eval $CMD
else
    CMD="blastp -query $QUERY -db $DB -out $CHUNK_OUTPUT_NAME -evalue 1e-3 -outfmt 5 -max_target_seqs 20 -max_hsps 1 -num_threads $NCPUS"
    echo $CMD > $LOGCMD
    eval $CMD
fi
