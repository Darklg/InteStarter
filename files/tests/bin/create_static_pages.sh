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

###################################
## Generate static files
###################################

for i in $main_files; do
    php "${i}.php" > "test-${i}.html";
done;