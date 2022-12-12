#!/usr/bin/env bash
###############################################################################
##                                                                           ##
## Purpose of script: get singularity images of orson dependancies           ##
##                                                                           ##
###############################################################################

args=("$@")
BASEDIR=${args[0]}
SING_IMAGES_OK=${args[1]}

container_dir="$BASEDIR/containers"

if [ ! "$container_dir/beedeem-4.7.4.sif" ] || [ !  "$container_dir/diamond-2.0.15.sif" ] || [ !  "$container_dir/iprscan-5.59-91.0.sif" ] || [ !  "$container_dir/blast-2.13.0.sif" ] || [ !  "$container_dir/eggNOG-mapper-2.1.9.sif" ] || [ !  "$container_dir/busco-5.4.3.sif" ]
then
     wget -r -nc -l1 -nH --cut-dirs=6 -A '*.sif' ftp://ftp.ifremer.fr/ifremer/dataref/bioinfo/sebimer/tools/ORSON/ -P $container_dir
else
     touch $SING_IMAGES_OK
fi
