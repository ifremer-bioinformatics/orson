#!/usr/bin/env bash
###############################################################################
##                                                                           ##
## Purpose of script: Extract species taxid for restricted BLAST process     ##
##                                                                           ##
###############################################################################

# var settings 
args=("$@")
RESTRICTED_TAX_ID=${args[0]}
LOGCMD=${args[1]}

# Extract species ids contained in the entered taxids
CMD="get_species_taxids.sh -t $RESTRICTED_TAX_ID > ${RESTRICTED_TAX_ID}.txids"
echo $CMD > $LOGCMD
eval $CMD
