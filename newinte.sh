#!/bin/bash

# Test commands
main_commands="npm grunt git";
for i in $main_commands
do
    command -v "$i" >/dev/null 2>&1 || { echo >&2 "Vous avez besoin du programme \"${i}\" pour continuer."; exit 1; }
done;

EXECDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";

# On clone le repository
echo '# - RECUPERATION DE INTESTARTER'
git clone https://github.com/Darklg/InteStarter.git

# Set main directory
MAINDIR="${PWD}/";
DIRECTORY="${MAINDIR}InteStarter/";

if [ ! -d "$DIRECTORY" ]; then
    echo 'Le clonage a échoué';
    exit 1;
fi

# Use cloned files if launch from URL
if [ ! -f "${EXECDIR}/bin/config.sh" ]; then
    EXECDIR="${DIRECTORY}";
fi

# Avoid .git conflict
rm -rf "${MAINDIR}InteStarter/.git/";

#################################################################
## Basic steps
#################################################################

. "${EXECDIR}/bin/config.sh";
. "${EXECDIR}/bin/folders.sh";
. "${EXECDIR}/bin/css.sh";
. "${EXECDIR}/bin/js.sh";
. "${EXECDIR}/bin/grunt.sh";
. "${EXECDIR}/bin/ie.sh";
. "${EXECDIR}/bin/responsive.sh";

#################################################################
## MENAGE
#################################################################

# Generate file
if [[ $use_compass == 'y' ]]; then
    compass compile;
fi;

echo '## MENAGE';

cd "${MAINDIR}";

# Suppression des fichiers inutiles & de développement
rm -rf files
rm -rf bin
rm -rf .sass-cache
rm README.md
rm newinte.sh
rm deploy.sh

# Suppression des fichiers non assets
if [[ $use_onlyassets == 'y' ]]; then
    rm -rf inc/
    rm -rf index.php
fi;

echo '## FINI !'