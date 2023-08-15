#!/bin/bash

# Test commands
main_commands="curl git yarn";
for i in $main_commands
do
    command -v "$i" >/dev/null 2>&1 || { echo >&2 "Vous avez besoin du programme \"${i}\" pour continuer."; exit 1; }
done;

SOURCEDIR="$( dirname "${BASH_SOURCE[0]}" )/";

# Cloning repository or getting local version if available
echo '# - RECUPERATION DE INTESTARTER';
if [ ! -d "${SOURCEDIR}files" ]; then
    # Distant
    git clone --depth=1 https://github.com/Darklg/InteStarter.git
else
    # Local
    git clone "${SOURCEDIR}.git";
fi;

# Set main directory
MAINDIR="${PWD}/";
ASSETSDIR="${MAINDIR}assets";
SRCDIR="${MAINDIR}src";
SCSSDIR="${SRCDIR}/scss";
SCSSFILE="${SCSSDIR}/main.scss";
EXECDIR="${MAINDIR}InteStarter/";

if [ ! -d "${EXECDIR}" ]; then
    echo 'Le clonage a échoué';
    return 1;
fi

# Avoid .git conflict
rm -rf "${MAINDIR}InteStarter/.git/";
rm -rf "${MAINDIR}InteStarter/.gitignore";
rm -rf "${MAINDIR}InteStarter/README.md";

# Retrieveing intestarter content
mv InteStarter/* .
rm -rf "InteStarter/";
EXECDIR="${PWD}/";

#################################################################
## Basic steps
#################################################################

. "${EXECDIR}bin/tools.sh";

if [[ "${1}" == 'update' ]];then
    . "${SOURCEDIR}bin/update.sh";
else
    . "${EXECDIR}bin/config.sh";
    . "${EXECDIR}bin/folders.sh";
    . "${EXECDIR}bin/css.sh";
    . "${EXECDIR}bin/gulp.sh";
    . "${EXECDIR}bin/js.sh";
    if [[ $is_magento2_skin == 'y' ]]; then
        . "${EXECDIR}bin/magento.sh";
    fi;

    if [[ $is_static_website == 'y' ]]; then
        . "${EXECDIR}bin/static.sh";
    fi;


    . "${EXECDIR}bin/documentation.sh";

    echo '## FIRST BUILD';
    gulp;
fi;


. "${SOURCEDIR}bin/clean.sh";
