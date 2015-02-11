#!/bin/bash

###################################
## Extract file names
###################################

main_files="";
for f in *.php; do
    if [ "${main_files}" != "" ]; then
        main_files+=" ";
    fi;
    main_files+=${f//\.php/};
done