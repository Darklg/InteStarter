#!/bin/bash

# Test commands
main_commands="npm grunt git compass";
for i in $main_commands
do
    command -v "$i" >/dev/null 2>&1 || { echo >&2 "Vous avez besoin du programme \"${i}\" pour continuer."; exit 1; }
done;

SOURCEDIR="$( dirname "${BASH_SOURCE[0]}" )/";
EXECDIR="$( cd "${SOURCEDIR}" && pwd )/";

# Cloning repository or getting local version if available
echo '# - RECUPERATION DE INTESTARTER';
if [ ! -d "${SOURCEDIR}files" ]; then
    git clone https://github.com/Darklg/InteStarter.git
else
    git clone "${SOURCEDIR}.git";
fi;

# Set main directory
MAINDIR="${PWD}/";
DIRECTORY="${MAINDIR}InteStarter";

if [ ! -d "${DIRECTORY}" ]; then
    echo 'Le clonage a échoué';
    exit 1;
fi

# Use cloned files if launch from URL
if [ ! -f "${EXECDIR}bin/config.sh" ]; then
    EXECDIR="${DIRECTORY}/";
fi

# Avoid .git conflict
rm -rf "${MAINDIR}InteStarter/.git/";
rm -rf "${MAINDIR}InteStarter/.gitignore";

#################################################################
## Basic steps
#################################################################

. "${EXECDIR}bin/config.sh";
. "${EXECDIR}bin/folders.sh";
. "${EXECDIR}bin/css.sh";
. "${EXECDIR}bin/js.sh";
. "${EXECDIR}bin/grunt.sh";
if [[ $support_ie8 == 'y' ]]; then
    . "${EXECDIR}bin/ie.sh";
fi;
. "${EXECDIR}bin/responsive.sh";

#################################################################
## Compilations initiales
#################################################################

echo '## COMPILATIONS INITIALES';

# Generate file
if [[ $use_compass == 'y' ]]; then
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

#################################################################
## MENAGE
#################################################################

echo '## MENAGE';

cd "${MAINDIR}";

# Suppression des fichiers inutiles & de développement
rm -rf files
rm -rf bin
rm -rf .sass-cache
rm README.md
rm newinte.sh

# Suppression des fichiers non assets
if [[ $use_onlyassets == 'y' ]]; then
    rm -rf inc/
    rm -rf index.php
fi;

echo '## FINI !'