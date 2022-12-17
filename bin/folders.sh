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

# On cree le repertoire des assets
if ! [ -d "${SRCDIR}/" ]; then
    echo '- Creation de src/';
    mkdir "${SRCDIR}/";
fi

cd "${ASSETSDIR}/";

# htaccess
if [[ $is_magento2_skin == 'n' ]]; then
    if ! [ -f "${ASSETSDIR}/.htaccess" ]; then
        echo '- Ajout du .htaccess assets';
        mv "${MAINDIR}files/assets.htaccess" "${ASSETSDIR}/.htaccess";
    fi;
    if ! [ -f "${SRCDIR}/.htaccess" ]; then
        echo '- Ajout du .htaccess src';
        mv "${MAINDIR}files/src.htaccess" "${SRCDIR}/.htaccess";
    fi;
fi;

if [[ $is_wp_theme == 'n' && $is_magento2_skin == 'n' ]]; then
    # htaccess
    echo '- Ajout du .htaccess';
    cat "${MAINDIR}files/base.htaccess" >> "${MAINDIR}.htaccess";
    # Gitignore
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

# On cree les répertoires contenant le Scss
for i in $src_folders
do
    if ! [ -d "${SRCDIR}/${i}" ]; then
      echo "- Creation de ${i}";
      mkdir "${SRCDIR}/${i}";
    fi;
done;
