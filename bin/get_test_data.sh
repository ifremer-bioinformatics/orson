#!/usr/bin/env bash
###############################################################################
##                                                                           ##
## Purpose of script: get test data for testing orson                        ##
##                                                                           ##
###############################################################################

args=("$@")
BASEDIR=${args[0]}
ready=${args[1]}
QUERY=${args[2]}

datadir="$BASEDIR/test_dataset"
dbdir="$BASEDIR/test_database"

if [ ! -d "$datadir" ] || ([ -d "$datadir" ] && [ ! "$(ls -A $datadir)" ])
then 
     mkdir -p $datadir
     wget -r -nc -l1 -nH --cut-dirs=6 -A 'query.fa' ftp://ftp.ifremer.fr/ifremer/dataref/bioinfo/sebimer/sequence-set/ORSON/ -P $datadir
fi

if [ ! -d "$dbdir" ] || ([ -d "$dbdir" ] && [ ! "$(ls -A $dbdir)" ])
then
    mkdir -p $dbdir
    wget -r -nc -l2 -nH --cut-dirs=7 -A 'Uniprot_SwissProt*' ftp://ftp.ifremer.fr/ifremer/dataref/bioinfo/sebimer/sequence-set/ORSON/test_database -P $dbdir
fi

if ([ -f "$datadir/query.fa" ] && [ -f "$dbdir/Uniprot_SwissProtM.pal" ])
then
   touch $ready
   ln -s $datadir/query.fa $QUERY
fi
