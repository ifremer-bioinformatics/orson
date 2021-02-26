#!/usr/bin/env bash
###############################################################################
##                                                                           ##
## Purpose of script: Merge multiple InterProScan XML files                  ##
##                                                                           ##
###############################################################################

# var settings 
args=("$@")
MERGED_XML=${args[0]}

# Run InterProScan XML merging
CMD="sed -i '1d' *.xml;
sed -i '\$d' *.xml;
cat *.xml > $MERGED_XML;
sed -i '1 i\<?xml version=\"1.0\" encoding=\"UTF-8\"?><protein-matches xmlns=\"http://www.ebi.ac.uk/interpro/resources/schemas/interproscan5\" interproscan-version=\"5.48-83.0\">' $MERGED_XML;
echo '</protein-matches>' >> $MERGED_XML"
eval $CMD
