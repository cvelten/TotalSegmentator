#!/bin/bash

#
# USAGE
__printHelp() {
	1>&2 cat << EOF
Usage
  docker run [docker run options] IMAGE [-h] [-l LICENSE] [-d [TASK1,TASK2,...]]

Options
  -h | --help                           = Display this message and exit
  -l | --license <string>               = Register the given TotalSegmentator license
  -d | --download                       = Download all pretrained model weights (or those given by -t|--tasks)
  -t | --tasks <string1,string2,...>    = Download the given pretrained model weights; must not contain whitespaces
EOF
}

# 
# Option Parsing
TEMP=$(getopt -o hl:d: --long help,license:,download: \
              -n 'docker-total-entrypoint' -- "$@")
if [ $? != 0 ] ; then 1>&2 echo "Terminating..." >&2 ; exit 1 ; fi
# Note the quotes around '$TEMP': they are essential!
eval set -- "$TEMP"

VERBOSE=false
LICENSE=""
DOWNLOAD=false
TASKS=""

while true; do
  case "$1" in
	-h | --help ) __printHelp; exit 0 ;;
    -l | --license ) LICENSE="$2"; shift 2 ;;
    -d | --download ) DOWNLOAD=true; shift ;;
    -t | --tasks ) DOWNLOAD=true; TASKS="$2"; shift 2 ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done

if [ ! -z $LICENSE ]; then
    totalseg_set_license -l $LICENSE
fi

if [ -z $TASKS ]; then
    TASKS="total,total_fast,total_mr,total_fast_mr,brain_structures,liver_vessels,lung_vessels,cerebral_bleed,coronary_arteries,pleural_pericard_effusion,body,body_fast,vertebrae_body,heartchambers_highres,appendicular_bones,tissue_types,tissue_types_mr,face,face_mr"
fi

if [ $DOWNLOAD ]; then
    for task in ${TASKS//,/ }; do
        download_pretrained_weights.py -t $task
    done
fi