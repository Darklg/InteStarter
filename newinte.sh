#!/bin/bash

# Test commands
main_commands="npm grunt git compass";
for i in $main_commands
do
    command -v "$i" >/dev/null 2>&1 || { echo >&2 "Vous avez besoin du programme \"${i}\" pour continuer."; exit 1; }
done;

SOURCEDIR="$( dirname "${BASH_SOURCE[0]}" )/";

# Cloning repository or getting local version if available
echo '# - RECUPERATION DE INTESTARTER';
if [ ! -d "${SOURCEDIR}files" ]; then
    git clone --depth=1 https://github.com/Darklg/InteStarter.git
else
    git clone "${SOURCEDIR}.git";
fi;

# Set main directory
MAINDIR="${PWD}/";
ASSETSDIR="${MAINDIR}/assets";
SCSSDIR="${ASSETSDIR}/scss";
SCSSFILE="${SCSSDIR}/main.scss";
EXECDIR="${MAINDIR}InteStarter/";

if [ ! -d "${EXECDIR}" ]; then
    echo 'Le clonage a échoué';
    return 1;
fi

# Avoid .git conflict
rm -rf "${MAINDIR}InteStarter/.git/";
rm -rf "${MAINDIR}InteStarter/.gitignore";

#################################################################
## Basic steps
#################################################################

. "${EXECDIR}bin/tools.sh";
. "${EXECDIR}bin/config.sh";
. "${EXECDIR}bin/folders.sh";
. "${EXECDIR}bin/css.sh";
. "${EXECDIR}bin/js.sh";
. "${EXECDIR}bin/grunt.sh";
. "${EXECDIR}bin/gulp.sh";
. "${EXECDIR}bin/responsive.sh";
if [[ $is_magento_skin == 'y' ]] || [[ $is_magento2_skin == 'y' ]]; then
    . "${EXECDIR}bin/magento.sh";
fi;

. "${EXECDIR}bin/documentation.sh";

#################################################################
## Compilations initiales
#################################################################

echo '## COMPILATIONS INITIALES';

# Generate file
if [[ $use_gulp != 'n' && $use_compass == 'y' ]]; then
    compass compile;
fi;

# First build
if [[ $use_grunt != 'n' && $use_compass_fonticon == 'y' ]];then
    grunt build;
fi;

# Baseline for regression tests
if [[ $use_regression_tests == 'y' ]];then
    grunt run_tests;
fi;

# First build
if [[ $use_gulp == 'y' ]];then
    gulp;
fi;

#################################################################
## MENAGE
#################################################################

echo '## MENAGE';

cd "${MAINDIR}";

# Suppression des fichiers inutiles & de développement
rm -rf files
rm -rf bin
rm -rf .sass-cache
rm newinte.sh

# Suppression des fichiers non assets
if [[ $use_onlyassets == 'y' || $use_gulp == 'y' ]]; then
    if [[ $is_wp_theme == 'n' ]]; then
        rm -rf inc/
        rm -rf index.php
    fi;
    rm -rf styleguide.php
fi;

echo '## FINI !'
