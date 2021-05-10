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

if [ ! -f "$container_dir/beedeem-4.7.0.sif" ] && [ ! -f "$container_dir/diamond-2.0.9.sif" ] && [ ! -f "$container_dir/iprscan-5.51-85.0.sif" ]
then
     wget -r -nc -l1 -nH --cut-dirs=6 -A '*.sif' ftp://ftp.ifremer.fr/ifremer/dataref/bioinfo/sebimer/tools/ORSON/ -P $container_dir
fi

if [ -f "$container_dir/beedeem-4.7.0.sif" ] && [ -f "$container_dir/diamond-2.0.9.sif" ] && [ -f "$container_dir/iprscan-5.51-85.0.sif" ]
then
     touch $SING_IMAGES_OK
fi
