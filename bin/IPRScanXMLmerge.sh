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
CMD="sed -i '1d' *.xml;
sed -i '\$d' *.xml;
cat *.xml > $MERGED_XML;
if [ "$QUERY_TYPE" = "p" ]; then
	sed -i '1 i\<?xml version=\"1.0\" encoding=\"UTF-8\"?><protein-matches xmlns=\"http://www.ebi.ac.uk/interpro/resources/schemas/interproscan5\" interproscan-version=\"5.51-85.0\">' $MERGED_XML;
	echo '</protein-matches>' >> $MERGED_XML"
else
	sed -i '1 i\<?xml version=\"1.0\" encoding=\"UTF-8\"?><nucleotide-sequence-matches xmlns=\"http://www.ebi.ac.uk/interpro/resources/schemas/interproscan5\" interproscan-version=\"5.51-85.0\">' $MERGED_XML;
        echo '</nucleotide-sequence-matches>' >> $MERGED_XML"
fi
eval $CMD
