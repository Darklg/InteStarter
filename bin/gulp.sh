#!/bin/bash

#################################################################
## Use Gulp
#################################################################

# Create package.json
mv "${MAINDIR}files/package.json" "${MAINDIR}package.json";
intestarter_sed "s/project_id/${project_id}/" "${MAINDIR}package.json";

# Install Gulp & default modules
yarn add --dev \
    gulp \
    gulp-autoprefixer \
    gulp-filelist \
    gulp-iconfont \
    gulp-iconfont-css \
    gulp-pug \
    gulp-remove-empty-lines \
    gulp-replace \
    gulp-sass \
    gulp-sass-glob \
    gulp-strip-css-comments \
    gulp-trimlines \
    browser-sync \
    gulp-concat \
    gulp-minify

# Create Gulp Files
mv "${MAINDIR}files/gulpfile.js" "${MAINDIR}gulpfile.js";
mv "${MAINDIR}files/pug" "${MAINDIR}src/pug";

# Set project ID
intestarter_sed "s/PROJECTID/${project_id}/g" "${MAINDIR}gulpfile.js";
intestarter_sed "s/MySite/${project_name}/g" "${MAINDIR}src/pug/layouts/layout.pug";
intestarter_sed "s/MySite/${project_name}/g" "${MAINDIR}src/pug/styleguide.pug";

gulp;

cd "${MAINDIR}";
