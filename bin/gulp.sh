#!/bin/bash

#################################################################
## Use Gulp
#################################################################

# Create package.json
mv "${MAINDIR}files/package.json" "${MAINDIR}package.json";
intestarter_sed "s/project_id/${project_id}/" "${MAINDIR}package.json";

# Install Gulp & default modules
npm install --silent --save-dev gulp;
npm install --silent --save-dev gulp-autoprefixer;
npm install --silent --save-dev gulp-filelist;
npm install --silent --save-dev gulp-iconfont;
npm install --silent --save-dev gulp-iconfont-css;
npm install --silent --save-dev gulp-pug;
npm install --silent --save-dev gulp-remove-empty-lines;
npm install --silent --save-dev gulp-replace;
npm install --silent --save-dev gulp-sass;
npm install --silent --save-dev gulp-sass-glob;
npm install --silent --save-dev gulp-strip-css-comments;
npm install --silent --save-dev gulp-trimlines;
npm install --silent --save-dev browser-sync;
npm install --silent --save-dev gulp-concat;
npm install --silent --save-dev gulp-minify;

# Create Gulp Files
mv "${MAINDIR}files/gulpfile.js" "${MAINDIR}gulpfile.js";
mv "${MAINDIR}files/pug" "${MAINDIR}src/pug";

# Set project ID
intestarter_sed "s/PROJECTID/${project_id}/g" "${MAINDIR}gulpfile.js";
intestarter_sed "s/MySite/${project_name}/g" "${MAINDIR}src/pug/layouts/layout.pug";
intestarter_sed "s/MySite/${project_name}/g" "${MAINDIR}src/pug/styleguide.pug";

gulp;

cd "${MAINDIR}";
