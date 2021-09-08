#!/usr/bin/env bash
###############################################################################
##                                                                           ##
## Purpose of script: Merge multiple InterProScan XML files                  ##
##                                                                           ##
###############################################################################

# var settings 
args=("$@")
MERGED_XML=${args[0]}
QUERY_TYPE=${args[1]}

# Run InterProScan XML merging
CMD="sed -i '1d' *results.xml;
sed -i '\$d' *results.xml;
cat *results.xml > $MERGED_XML;"
if [ "$QUERY_TYPE" = "p" ]
then
	CMD=$CMD . " sed -i '1 i\<?xml version=\"1.0\" encoding=\"UTF-8\"?><protein-matches xmlns=\"http://www.ebi.ac.uk/interpro/resources/schemas/interproscan5\" interproscan-version=\"5.51-85.0\">' $MERGED_XM
L;
	echo '</protein-matches>' >> $MERGED_XML"
else
	CMD=$CMD . " sed -i '1 i\<?xml version=\"1.0\" encoding=\"UTF-8\"?><nucleotide-sequence-matches xmlns=\"http://www.ebi.ac.uk/interpro/resources/schemas/interproscan5\" interproscan-version=\"5.51-85.0\">
' $MERGED_XML;
        echo '</nucleotide-sequence-matches>' >> $MERGED_XML"
fi
eval $CMD
