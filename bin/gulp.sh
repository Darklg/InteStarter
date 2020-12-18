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
intestarter_sed "s/project_id/${project_id}/" "${MAINDIR}package.json";
intestarter_sed "s/p_hostname/${project_hostname}/" "${MAINDIR}package.json";

# Install Gulp & default modules
yarn add --dev \
    browser-sync \
    gulp \
    gulp-autoprefixer \
    gulp-concat \
    gulp-filelist \
    gulp-iconfont \
    gulp-iconfont-css \
    gulp-minify \
    gulp-pug \
    gulp-remove-empty-lines \
    gulp-replace \
    gulp-sass \
    gulp-sass-glob \
    gulp-strip-css-comments \
    gulp-svgmin \
    gulp-trimlines

# Create Gulp Files
mv "${MAINDIR}files/gulpfile.js" "${MAINDIR}gulpfile.js";
mv "${MAINDIR}files/pug" "${MAINDIR}src/pug";

# Set watch mode
if [[ "${is_wp_theme}" == 'y' || "${is_magento2_skin}" == 'y' ]]; then
    intestarter_sed "s~// #proxy~proxy~g" "${MAINDIR}gulpfile.js";
else
    intestarter_sed "s~// #server~server~g" "${MAINDIR}gulpfile.js";
fi;

# Set project ID
intestarter_sed "s/PROJECTID/${project_id}/g" "${MAINDIR}gulpfile.js";
intestarter_sed "s/MySite/${project_name}/g" "${MAINDIR}src/pug/layouts/layout.pug";
intestarter_sed "s/MySite/${project_name}/g" "${MAINDIR}src/pug/index.pug";

gulp;

cd "${MAINDIR}";
