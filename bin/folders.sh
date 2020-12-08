#!/bin/bash

#################################################################
## CREATION DES DOSSIERS
#################################################################

echo '## CREATION DES DOSSIERS';

# On cree le repertoire des assets
if ! [ -d "${ASSETSDIR}/" ]; then
    echo '- Creation de assets/';
    mkdir "${ASSETSDIR}/";
fi

cd "${ASSETSDIR}/";

# htaccess
if [[ $is_wp_theme == 'n' && $is_magento2_skin == 'n' ]]; then
    if ! [ -f .htaccess ]; then
        echo '- Ajout du .htaccess';
        mv "${MAINDIR}files/assets.htaccess" "${ASSETSDIR}/.htaccess";
    fi;
fi;

# Gitignore
if [[ $is_wp_theme == 'n' && $is_magento2_skin == 'n' ]]; then
    echo '- Ajout du .gitignore';
    cat "${MAINDIR}files/base.gitignore" >> "${MAINDIR}.gitignore";
fi;

# On cree les répertoires principaux
for i in $main_folders
do
    if ! [ -d "${i}" ]; then
        echo "- Creation de ${i}";
        mkdir "${ASSETSDIR}/${i}";
    fi
done;

cd "${MAINDIR}";
