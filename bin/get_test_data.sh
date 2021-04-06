#!/usr/bin/env bash
###############################################################################
##                                                                           ##
## Purpose of script: get test data for testing orson                        ##
##                                                                           ##
###############################################################################

args=("$@")
BASEDIR=${args[0]}
QUERY=${args[1]}

datadir="$BASEDIR/test_dataset"

if [ ! -d "$datadir" ] || ([ -d "$datadir" ] && [ ! "$(ls -A $datadir)" ])
then 
     mkdir -p $datadir
     wget -r -nc -l1 -nH --cut-dirs=6 -A 'query.fa' ftp://ftp.ifremer.fr/ifremer/dataref/bioinfo/sebimer/sequence-set/ORSON/ -P $datadir
fi

if [ -f "$datadir/query.fa" ]
then
   ln -s $datadir/query.fa $QUERY
fi
