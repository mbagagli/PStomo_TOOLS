#!/bin/bash
# This simple bash script recover the Event_err from a
# PStomo run (DIRPATH) and extract the location errors in the 3 directions.
# A file will be created and stored (SAVEPATH) to be later on plotted
# by the matlab function reloc_plot.m
#
# AUTHOR: Matteo Bagagli @ INGV.PI
# DATE:   03/2014

if [ "$#" -ne "2" ]; then
    echo "USAGE: $(basename $0) DIRPATH SAVEPATH"
    exit
fi
# ================================================
indir=${1}
outdir=${2}
indirname=$(echo ${indir} | awk -F "/" '{print $NF}')

xx=1
for EVERR in `find ${indir} -maxdepth 1 -name "Event_err_*.log"`; do
    grep km ${EVERR} | awk '{print $2, $4, $6, $9}' > ${indir}/Rel_${indirname}.${xx}
    cp ${indir}/Rel_${indirname}.${xx} ${outdir}
    echo "... Rel_${indirname}.${xx} file stored in ${outdir} !!!"
    xx=$((xx+1))
done
echo "... DONE"
