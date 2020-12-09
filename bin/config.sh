#!/bin/bash

#################################################################
## CONFIGURATION INITIALE
#################################################################

echo '## CONFIGURATION INITIALE';

# Thème WP
if [ -z ${from_wpinstaller+x} ]; then
    is_wp_theme=$(intestarter_yn "- Est-ce un thème WordPress ?" 'n');
else
    is_wp_theme='y';
fi;

is_magento2_skin='n';
if [[ $is_wp_theme == 'n' ]]; then
    is_magento2_skin=$(intestarter_yn "- Est-ce un skin Magento 2 ?" 'n');
fi;

if [[ $is_magento2_skin == 'y' ]]; then
    ASSETSDIR="${MAINDIR}";
    SCSSDIR="${ASSETSDIR}/styles";
    SCSSFILE="${SCSSDIR}/styles.scss";
fi;

# Seulement assets
use_onlyassets='y';
if [[ $is_wp_theme == 'n' && $is_magento2_skin == 'n' ]]; then
    use_onlyassets=$(intestarter_yn "- Récupérer uniquement les assets ?" 'n');
fi;

if [[ $use_onlyassets == 'y' ]]; then
    rm "InteStarter/index.php";
    rm "InteStarter/styleguide.php";
fi;
if [[ $is_wp_theme == 'n' ]]; then
    rm "InteStarter/styleguide-wp.php";
fi;

# Choix du dossier
if [[ $is_wp_theme == 'y' ]]; then
    # Moving useful files
    if [ ! -d "tpl/" ]; then
        mkdir "tpl/";
    fi;

    # Removing useless files
    rm -rf "InteStarter/inc/";

fi;

# On récupère le contenu du dossier créé
mv InteStarter/* .
rm -rf "InteStarter/";
EXECDIR="${PWD}/";

if [ -z ${from_wpinstaller+x} ]; then
    # On recupere le nom du projet
    default_project_name='Front-End';
    read -p "- Comment s'appelle ce projet ? (${default_project_name}) : " project_name
    if [[ $project_name == '' ]]; then
        project_name="${default_project_name}";
    fi;

    # On recupere l'ID du projet
    default_project_id=$(intestarter_slug "${project_name}");
    read -p "- Quel est l'ID de ce projet ? (${default_project_id}) : " project_id
    if [[ $project_id == '' ]]; then
        project_id="${default_project_id}";
    fi;
else
    echo "Using values from WPUInstaller : ${project_name} - ${project_id}";
fi;

# Use only assets
if [[ $use_onlyassets == 'n' ]]; then
    # On recupere l'URL du projet
    read -p "- Quelle est l'URL du projet ? " project_url

    # On recupere la description du projet
    default_project_description="${project_name}";
    read -p "- Quelle est la description rapide du projet ? (${default_project_description}) : " project_description
    if [[ $project_description == '' ]]; then
        project_description="${default_project_description}";
    fi;
fi;

use_jquery='n';
if [[ $is_wp_theme == 'n' && $is_magento2_skin == 'n' ]]; then
    # Bibliothèque JS
    use_jquery=$(intestarter_yn "- Utiliser jQuery ?" 'n');
fi;

add_slick_slider='n';
if [[ $use_jquery == 'y' ]]; then
    # Plugins JS
    add_slick_slider=$(intestarter_yn "- Installer Slick Slider ?" 'n');
fi;

add_jsutilities_plugins='n';
if [[ $is_wp_theme == 'n' && $is_magento2_skin == 'n' && $use_jquery == 'y' ]]; then
    # Plugins JS
    add_jsutilities_plugins=$(intestarter_yn "- Utiliser des plugins JSUtilities ?" 'n');
fi;

cd "${MAINDIR}";

###################################
## Write config
###################################

if [[ $use_onlyassets == 'n' ]]; then
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

styleguide_forms_path="${MAINDIR}inc/";
if [[ $is_wp_theme == 'y' ]]; then
    styleguide_forms_path="${MAINDIR}";
fi;
if [[ -f "${styleguide_forms_path}tpl/styleguide/forms.php" ]];then
    intestarter_sed "s/--default/--${project_id}/" "${styleguide_forms_path}tpl/styleguide/forms.php";
fi

###################################
## Basic values
###################################

main_folders="css/ images/ fonts/";
if [[ $is_magento2_skin == 'n' ]];then
    main_folders="${main_folders} js/";
fi;

# CSS / COMPASS
if [[ $is_magento2_skin == 'y' ]]; then
    src_folders="styles/ styles/${project_id}/";
else
    src_folders="scss/ scss/${project_id}/";
fi;
src_folders="${src_folders} js/ icons/";
csscommon_default_modules="default common content buttons forms grid layouts";
csscommon_additional_modules="tables push navigation tabs images print effects";

# JS / JSU
directory_jsu="${MAINDIR}JavaScriptUtilities/";
jquery_plugins="fake-select fake-inputbox";
jquery_path="assets/js/jquery/plugins/";
