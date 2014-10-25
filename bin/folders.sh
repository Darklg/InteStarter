#!/bin/bash

#################################################################
## CREATION DES DOSSIERS
#################################################################

echo '## CREATION DES DOSSIERS';

# On cree le repertoire des assets
if ! [ -d assets/ ]; then
  echo '- Creation de assets/';
  mkdir $MAINDIR"assets/";
fi

cd $MAINDIR"assets/";

# On cree les répertoires principaux
main_folders="css/ images/ fonts/ js/ js/ie/";
for i in $main_folders
do
    if ! [ -d $i ]; then
      echo '- Creation de '$i;
      mkdir $MAINDIR'assets/'$i;
    fi
done;

cd $MAINDIR;