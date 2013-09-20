#!/bin/bash

project_url='http://site.dev/';
prod_folder='prod';

# Delete prod
rm -rf $prod_folder

# Re-create prod
mkdir $prod_folder

# Copy assets
cp -R assets/ $prod_folder"/assets/"

# Convert all PHP files in HTML
for i in *.php
do
    if test -f "$i"
    then
        url=${i/\.php/};
        # Cache page
        curl $project_url$url".php" -o $prod_folder"/"$url".html";
        # Replace php links
        sed -i '' 's/\.php/\.html/g' $prod_folder"/"$url".html";
    fi
done
