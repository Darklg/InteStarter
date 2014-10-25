#!/bin/bash

# On clone le repository
echo '# - RECUPERATION DE INTESTARTER'
git clone https://github.com/Darklg/InteStarter.git

# Set main directory
MAINDIR=${PWD}"/";

#################################################################
## Basic steps
#################################################################

chmod -R 777 $MAINDIR"InteStarter/bin/"

. $MAINDIR"InteStarter/bin/config.sh"
. $MAINDIR"bin/folders.sh"
. $MAINDIR"bin/css.sh"
. $MAINDIR"bin/js.sh"
. $MAINDIR"bin/grunt.sh"
. $MAINDIR"bin/ie.sh"
. $MAINDIR"bin/responsive.sh"

#################################################################
## MENAGE
#################################################################

echo '## MENAGE';

cd $MAINDIR;

# Suppression des fichiers inutiles & de développement
rm -rf .git
rm -rf files
rm -rf bin
rm README.md
rm newinte.sh
rm deploy.sh

echo '## LET’S WORK, BABY !'