#!/bin/bash

#################################################################
## Utiliser Gulp
#################################################################

if [[ "${use_gulp}" != 'n' ]]; then
    # Install Gulp & default modules
    npm install --silent --save-dev gulp
    npm install --silent --save-dev gulp-filelist
    npm install --silent --save-dev gulp-iconfont
    npm install --silent --save-dev gulp-iconfont-css
    npm install --silent --save-dev gulp-pug
    npm install --silent --save-dev gulp-remove-empty-lines
    npm install --silent --save-dev gulp-replace
    npm install --silent --save-dev gulp-sass
    npm install --silent --save-dev gulp-strip-css-comments
    npm install --silent --save-dev gulp-trimlines

    # Create Grunt Files
    mv "${MAINDIR}files/gulpfile.js" "${MAINDIR}gulpfile.js";
    mv "${MAINDIR}files/gulp" "${MAINDIR}gulp";

    # Set project ID
    intestarter_sed "s/PROJECTID/${project_id}/g" "${MAINDIR}gulpfile.js";

    gulp;

    cd "${MAINDIR}";
fi;
