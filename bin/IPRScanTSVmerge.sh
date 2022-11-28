#!/usr/bin/env bash
###############################################################################
##                                                                           ##
## Purpose of script: Merge multiple InterProScan XML files                  ##
##                                                                           ##
###############################################################################

# var settings 
args=("$@")
MERGED_TSV=${args[0]}

# Format individual InterProScan TSV
sed -i '1d' \.*\.fasta.tsv
sed -i '$d' *\.*\.fasta.tsv

# Merge individual InterProScan TSV
cat *\.*\.fasta.tsv > $MERGED_TSV

