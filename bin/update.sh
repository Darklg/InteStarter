#!/bin/bash

echo '## UPDATE';

###################################
## Missing files
###################################

intestarter__create_static_files;

###################################
## CSS Common
###################################

if [[ -f "${MAINDIR}src/scss/csscommon/.git" ]];then
    echo "- Update CSSCommon submodule";
    cd "${MAINDIR}src/scss/csscommon/";
    git pull origin master;git pull origin main;
fi;

###################################
## Gulp
###################################

if [[ ! -d "${MAINDIR}src/gulp" ]];then
    mkdir "${MAINDIR}src/gulp";
fi;
if [[ -d "${MAINDIR}gulp" ]];then
    echo "- Deleted old gulp dir";
    rm -rf "${MAINDIR}gulp";
fi;
if [[ -f "${MAINDIR}src/gulp/intestarter_gulpfile/.git" ]];then
    echo "- Update intestarter_gulpfile submodule";
    cd "${MAINDIR}src/gulp/intestarter_gulpfile/";
    git pull origin master;git pull origin main;
else
    if [ $(git rev-parse --is-inside-work-tree) ]; then
        echo "- Add intestarter_gulpfile submodule";
        cd "${MAINDIR}src/gulp";
        git submodule add --force https://github.com/Darklg/intestarter_gulpfile.git;
    fi;
fi;
cd "${MAINDIR}";

if [[ -f "${MAINDIR}gulpfile.js" ]];then
    echo "- Update gulpfile";
    rm  "${MAINDIR}gulpfile.js";
    mv "${MAINDIR}files/gulpfile.js" "${MAINDIR}gulpfile.js";
fi;

echo '- Fix some package versions';
intestarter_sed 's/"stylelint": "^/"stylelint": "/g' "package.json";
intestarter_sed 's/"gulp-stylelint": "^/"gulp-stylelint": "/g' "package.json";

echo '- Update NPM dependencies';
npm update --save --legacy-peer-deps;

echo '- Launch a new compilation';
npx update-browserslist-db@latest;
gulp;

echo '- Info';
npm outdated;
