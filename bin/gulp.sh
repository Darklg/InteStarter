#!/bin/bash

#################################################################
## Use Gulp
#################################################################

# Create package.json
mv "${MAINDIR}files/package.json" "${MAINDIR}package.json";

# Replace some variables
if [[ "${project_hostname}" == '' ]];then
    project_hostname="${project_id}.test";
fi;
intestarter_sed "s/p_id/${project_id}/" "${MAINDIR}package.json";
intestarter_sed "s/p_name/${project_name}/" "${MAINDIR}package.json";
intestarter_sed "s/p_hostname/${project_hostname}/" "${MAINDIR}package.json";


# Add fsvents
npm i fsevents@latest -f --save-optional

# Install Gulp & default modules
yarn add --dev \
    browser-sync \
    stylelint@15 \
    glob \
    gulp-stylelint \
    gulp@4 \
    gulp-autoprefixer@8 \
    gulp-concat \
    gulp-iconfont \
    gulp-iconfont-css \
    jshint \
    sass \
    gulp-jshint \
    gulp-minify \
    gulp-pug \
    gulp-remove-empty-lines \
    gulp-replace \
    gulp-sass \
    gulp-sass-glob \
    gulp-strip-css-comments@2 \
    gulp-svgmin \
    gulp-trimlines

# Static files
intestarter__create_static_files;

# Gulp Files
mv "${MAINDIR}files/gulpfile.js" "${MAINDIR}gulpfile.js";
mv "${MAINDIR}files/pug" "${MAINDIR}src/pug";

# Load intestarter gulp
mkdir "${MAINDIR}src/gulp";
cd "${MAINDIR}src/gulp";
if [ $(git rev-parse --is-inside-work-tree) ] || [ $is_wp_theme == 'y' ] || [ $is_magento2_skin == 'y' ]; then
    echo "-- add intestarter_gulpfile submodule";
    git submodule add --force https://github.com/Darklg/intestarter_gulpfile.git;
else
    echo "-- clone intestarter_gulpfile";
    git clone --depth=1 https://github.com/Darklg/intestarter_gulpfile.git;
    rm -rf "${MAINDIR}src/gulp/intestarter_gulpfile.git";
fi;
cd "${MAINDIR}";

# Set watch mode
if [[ "${is_wp_theme}" == 'y' ]]; then
    intestarter_sed "s~// #proxy~proxy~g" "${MAINDIR}gulpfile.js";
else
    intestarter_sed "s~// #server~server~g" "${MAINDIR}gulpfile.js";
fi;

if [[ "${s_magento2_skin}" == 'y' ]]; then
    intestarter_sed "s~assets/~web/~g" "${MAINDIR}gulpfile.js";
fi;

# Set project ID
intestarter_sed "s/PROJECTID/${project_id}/g" "${MAINDIR}gulpfile.js";
intestarter_sed "s/MySite/${project_name}/g" "${MAINDIR}src/pug/layouts/layout.pug";
intestarter_sed "s/project_id/${project_id}/" "${MAINDIR}src/pug/parts/forms.html";
intestarter_sed "s/MySite/${project_name}/g" "${MAINDIR}src/pug/index.pug";

cd "${MAINDIR}";
