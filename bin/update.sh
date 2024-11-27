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

    # Check if proxy is enabled
    intestarter__has_proxy='1';
    if [[ $(grep -c "    proxy" "${MAINDIR}gulpfile.js") -eq 0 ]];then
        intestarter__has_proxy='0';
    fi;

    # Delete old gulpfile
    rm  "${MAINDIR}gulpfile.js";

    # Copy new gulpfile
    mv "${MAINDIR}files/gulpfile.js" "${MAINDIR}gulpfile.js";

    # Add proxy if needed
    if [[ "${intestarter__has_proxy}" == '1' ]];then
        intestarter_sed 's!// #proxy!proxy!g' "gulpfile.js";
    fi;
fi;

echo '- Clean cache';
if [[ -f "${MAINDIR}package-lock.json" ]];then
    rm "${MAINDIR}package-lock.json";
fi;
rm -rf "${MAINDIR}node_modules";

echo '- Fix some package versions';
intestarter_sed 's/"stylelint": "^/"stylelint": "/g' "package.json";
intestarter_sed 's/"gulp-stylelint": "^/"gulp-stylelint": "/g' "package.json";

echo '- Update NPM dependencies';
npm update --save --legacy-peer-deps;
yarn;

echo '- Launch a new compilation';
npx update-browserslist-db@latest;
gulp;

echo '- Info';
npm outdated;

echo '- Extra checks';
# Alert if sass files contains some words
intestarter__warnings_in_sass_files=('darken(' 'lighten(');
for intestarter__warning in "${intestarter__warnings_in_sass_files[@]}"; do
    if [[ $(grep -r -l "${intestarter__warning}" "${MAINDIR}src/scss/") ]];then
        echo "Warning: Sass files contains '${intestarter__warning}'";
    fi;
done;
