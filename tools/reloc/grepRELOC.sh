#!/bin/bash

dir=${1}
out_dir=/home/billy/Dropbox/tesi_spec/matlab/reloc/

cd ./${dir}

for i in `ls | grep Event_err | cat -n | awk {'print $1'}`
do

grep km Event_err_${i}.log | awk '{print $2, $4, $6, $9}' > Rel_${dir}.${i}
cp Rel_${dir}.${i} $out_dir

echo "... done ${i} file !!!"

done

