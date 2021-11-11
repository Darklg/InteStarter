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

# Install Gulp & default modules
yarn add --dev \
    browser-sync \
    stylelint \
    glob \
    gulp-stylelint \
    gulp \
    gulp-autoprefixer \
    gulp-concat \
    gulp-filelist \
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
    gulp-strip-css-comments \
    gulp-svgmin \
    gulp-trimlines

# Gulp Files
mv "${MAINDIR}files/stylelint/stylelintrc.txt" "${MAINDIR}.stylelintrc";
mv "${MAINDIR}files/stylelint/stylelintignore.txt" "${MAINDIR}.stylelintignore";
mv "${MAINDIR}files/gulpfile.js" "${MAINDIR}gulpfile.js";
mv "${MAINDIR}files/pug" "${MAINDIR}src/pug";

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

# Add nvmrc
node -v > .nvmrc;

cd "${MAINDIR}";
