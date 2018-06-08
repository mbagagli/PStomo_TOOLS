#!/bin/bash
# This simple bash script recover the Event_err from a 
# PStomo run (DIRPATH) and extract the location errors in the 3 directions.
# A file will be created and stored (SAVEPATH) to be later on plotted 
# by the matlab function reloc_plot.m
#
# AUTHOR: Matteo Bagagli @ INGV.PI
# DATE:   03/2014

# These lines need to be added in run_pstomo script (in order to save the Event_err log file
#  if (-e Event_err.log)  then
#     \mv Event_err.log Event_err_$i.log
#  endif



if [ "$#" -ne "2" ]; then
    echo "USAGE: $(basename $0) DIRPATH SAVEPATH"
    exit
fi
# ================================================
dir=${1}
out_dir=${2}

cd ${dir}

for ii in `ls | grep Event_err | cat -n | awk {'print $1'}`; do
 echo "${ii}"
done


for ii in `ls | grep Event_err | cat -n | awk {'print $1'}`; do
    grep km Event_err_${ii}.log | awk '{print $2, $4, $6, $9}' > Rel_${dir}.${ii}
    cp Rel_${dir}.${ii} $out_dir
    echo "...  ${ii} file stored in ${out_dir} !!!"
done
echo "... DONE"

