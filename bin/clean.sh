#!/bin/bash

#################################################################
## MENAGE
#################################################################

echo '## MENAGE';

cd "${MAINDIR}";

# Suppression des fichiers inutiles & de développement
rm -rf files;
rm -rf bin;
rm -rf .sass-cache;
if [[ -f "newinte.sh" ]];then
    rm newinte.sh;
fi;

echo '## FINI !'
