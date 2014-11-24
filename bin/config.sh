#!/bin/bash

#################################################################
## CONFIGURATION INITIALE
#################################################################

echo '## CONFIGURATION INITIALE';

# Seulement assets
read -p "- Récupérer uniquement les assets (y/n) ? " use_onlyassets
if [[ $use_onlyassets == 'y' ]]; then
    rm -rf "InteStarter/inc";
fi;

# Choix du dossier
read -p "- Créer un sous-dossier \"inte\" (y/n) ? " use_subfolder
case "$use_subfolder" in
    y|Y|O|o )
        # On renomme le dossier créé et on s'y déplace
        mv "InteStarter" "inte";
        cd "inte/";
        MAINDIR=${PWD}"/";
    ;;
    * )
        # On récupère le contenu du dossier créé
        mv InteStarter/* .
        rm -rf "InteStarter/";
    ;;
esac

# On recupere le nom du projet
read -p "- Comment s'appelle ce projet ? (Front-End) " project_name
if [[ $project_name == '' ]]; then
    project_name='Front-End';
fi;

# On recupere l'ID du projet
read -p "- Quel est l'ID de ce projet ? (default) " project_id
if [[ $project_id == '' ]]; then
    project_id='default';
fi;

# On recupere l'URL du projet
read -p "- Quelle est l'URL du projet ? " project_url

# On recupere la description du projet
read -p "- Quelle est la description rapide du projet ? " project_description

# Utilisation de Compass
read -p "- Utiliser Compass (y/n) ? " use_compass
use_compass_imgsprite='';
if [[ $use_compass == 'y' ]]; then
    read -p "-- Compass : Utiliser des sprites image (y/n) ? " use_compass_imgsprite
    read -p "-- Compass : Utiliser une font-icon (y/n) ? " use_compass_fonticon
fi;

# Modules supplementaires CSSCommon
read -p "- Utiliser des modules supplementaires CSSCommon (y/n) ? " use_csscommon

# Utilisation de Grunt
read -p "- Utiliser Grunt (y/n) ? " use_grunt

# Bibliothèque JS
read -p "- Utiliser jQuery (y/n) ? " use_jquery

# Plugins JS
read -p "- Utiliser des plugins JSUtilities ? " add_jsutilities_plugins

# Responsive
read -p "- Est-ce un site responsive (y/n) ? " is_responsive
content_width='';
case "${is_responsive}" in
    y|Y|O|o )
    ;;
    * )
        read -p "- Quelle est la largeur du contenu sans marges (Default:980) ? " content_width
    ;;
esac

cd "${MAINDIR}";

###################################
## Write config
###################################

if [[ $use_onlyassets != 'y' ]]; then
    echo "
define('PROJECT_NAME','${project_name/\'/’}');
define('PROJECT_ID','${project_id/\'/’}');
define('PROJECT_URL','${project_url/\'/’}');
define('PROJECT_DESCRIPTION','${project_description/\'/’}');
" >> "${MAINDIR}inc/config.php";
fi;

###################################
## Styleguide classes
###################################

if [[ $use_onlyassets != 'y' ]]; then
    sed -i '' "s/--default/--${project_id}/" "${MAINDIR}index.php";
fi;

###################################
## Basic values
###################################

# CSS / COMPASS
compass_folders="scss/ scss/csscommon/ scss/utilities/ scss/${project_id}/ images/css-sprite/ images/css-sprite-2x/ icons/ icons/original/";
csscommon_default_modules="default common content buttons forms grid layouts";
csscommon_additional_modules="tables push navigation tabs images print effects";

# JS / JSU
directory_jsu="${MAINDIR}JavaScriptUtilities/";
jquery_plugins="fake-select fake-inputbox";
jquery_path="assets/js/jquery/plugins/";