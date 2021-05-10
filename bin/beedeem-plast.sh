#!/usr/bin/env bash
###############################################################################
##                                                                           ##
## Purpose of script: Run PLAST search                                       ##
##                                                                           ##
###############################################################################

# var settings 
args=("$@")
DB_DIR=${args[0]}
WK_DIR=${args[1]}
NCPUS=${args[2]}
Q_TYPE=${args[3]}
QUERY=${args[4]}
DB=${args[5]}
OUTPUT_NAME=${args[6]}
LOGCMD=${args[7]}
CHUNK_NAME=$(basename ${QUERY%.*})
CHUNK_OUTPUT_NAME=${CHUNK_NAME}_${OUTPUT_NAME}

export KL_mirror__path=$DB_DIR
export KL_WORKING_DIR=$WK_DIR
export KL_JRE_ARGS="-Xms128M -Xmx2048M -Djava.io.tmpdir=$KL_WORKING_DIR -DKL_LOG_TYPE=console"

PLAST_PATH="plast.sh"

# Run PLAST
if [ "$Q_TYPE" = "n" ]; then
    CMD="$PLAST_PATH -p plastx -i $QUERY -d $DB -o $CHUNK_OUTPUT_NAME -maxhits 20 -maxhsps 1 -e 1e-3 -a $NCPUS"
    echo $CMD > $LOGCMD
    eval $CMD
else
    CMD="$PLAST_PATH -p plastp -i $QUERY -d $DB -o $CHUNK_OUTPUT_NAME -maxhits 20 -maxhsps 1 -e 1e-3 -a $NCPUS -outfmt 4"
    echo $CMD > $LOGCMD
    eval $CMD
fi
