#!/bin/bash

prod_folder='prod';

# Delete prod
rm -rf ${prod_folder}

# Re-create prod
mkdir ${prod_folder}

if test -d "assets/";then
    # Copy assets
    cp -R assets/ "${prod_folder}/assets/";

    # Delete sources
    rm -rf "${prod_folder}/assets/scss/";
    rm -rf "${prod_folder}/assets/icons/";
fi;

if test -d "views/";then
    # Copy views
    cp -R views/ "${prod_folder}/views/";
fi;

# Convert all PHP files in HTML
for i in *.php
do
    if test -f "$i"
    then
        url=${i/\.php/};
        html_file="${prod_folder}/${url}.html";
        # Cache page
        php "${url}.php" > "${html_file}";
        # Replace php links
        intestarter_sed 's/\.php/\.html/g' "${html_file}";
    fi;
done;

# Remove System & hidden files
find "${prod_folder}" -iname ".DS_Store" -delete && dot_clean .
