#!/bin/bash

path="/path/to/files/.";

###############################################
# resize all images over 1Mb in size to 1080p #
###############################################
for image in `find ${path} -type f -size +1M -exec file --mime-type {} \+ | awk -F: '{if ($2 ~/image\//) print $1}'`; do
        excluded_mime_type="image/tiff";
        mime_type=$(file --mime-type $image | awk '{print $2}');
        if [ "$mime_type" == "$excluded_mime_type" ]; then
                continue;
        fi;

        file_path=$(echo "$image" | cut -d '.' -f 4-);
        width=$(identify -ping -format "%w" $image);

        if [ $width -gt 1080 ]; then
                convert ${image} -resize x1080\> ${image};
                converted_size_in_bytes=$(du -b $image | awk '{print $1}');

                mysql -udb_user db_name -ssse "UPDATE files SET file_size_bytes = '${converted_size_in_bytes}', updated_at = NOW() WHERE file_path = 'files$file_path';"
        fi;
done;
