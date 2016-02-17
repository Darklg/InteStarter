#!/bin/bash

#################################################################
## CREATION DES DOSSIERS
#################################################################

echo '## CREATION DES DOSSIERS';

# On cree le repertoire des assets
if ! [ -d assets/ ]; then
    echo '- Creation de assets/';
    mkdir "${MAINDIR}assets/";
fi

cd "${MAINDIR}assets/";

# htaccess
if [[ $is_wp_theme == 'n' && $is_magento_skin == 'n' ]]; then
    if ! [ -f .htaccess ]; then
        echo '- Ajout du .htaccess';
        mv "${MAINDIR}files/assets.htaccess" "${MAINDIR}assets/.htaccess";
    fi;
fi;

# Gitignore
if [[ $is_wp_theme == 'n' && $is_magento_skin == 'n' ]]; then
    echo '- Ajout du .gitignore';
    cat "${MAINDIR}files/base.gitignore" >> "${MAINDIR}.gitignore";
fi;

# On cree les répertoires principaux
for i in $main_folders
do
    if ! [ -d "${i}" ]; then
        echo "- Creation de ${i}";
        mkdir "${MAINDIR}assets/${i}";
    fi
done;

cd "${MAINDIR}";
