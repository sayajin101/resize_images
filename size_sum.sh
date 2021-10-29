#!/bin/bash

path="/path/to/files/.";

total_size=0;
for f in `find ${path} -type f -size +1M -exec file --mime-type {} \+ | awk -F: '{if ($2 ~/image\//) print $1}'`; do
        file_size=$(du -cb $f | grep total$ | cut -f1 | paste -sd+ - | bc);
        total_size=`expr $total_size + $file_size`;
done;

echo "$total_size";
