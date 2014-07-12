#!/bin/bash

project_url='http://site.dev/';
project_filename='intestarter';
prod_folder='prod';
date_now=$(date +"%Y-%m-%d");

# Delete prod
rm -rf $prod_folder

# Re-create prod
mkdir $prod_folder

if test -d "assets/";then
    # Copy assets
    cp -R assets/ $prod_folder"/assets/"
fi;

if test -d "views/";then
    # Copy views
    cp -R views/ $prod_folder"/views/"
fi;

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
    fi;
done;

# Remove System & hidden files
find $prod_folder -iname ".DS_Store" -delete && dot_clean .

# Ask to create a zip file
read -p "- Create a zip export file ? (y/n) ? " export_zip
if [[ $export_zip == 'y' ]]; then
    # Zip folder
    zip -r "export-"$project_filename"-"$date_now".zip" $prod_folder
    # Delete prod folder
    rm -rf $prod_folder
    # Open current folder
    open .
fi;

