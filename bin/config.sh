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
    ASSETSDIR="${MAINDIR}web";
    SCSSFILE="${SCSSDIR}/styles.scss";
fi;

is_static_website='n';
if [[ $is_wp_theme == 'n' && $is_magento2_skin == 'n' ]]; then
    is_static_website=$(intestarter_yn "- Est-ce un site statique PHP ?" 'n');
fi;

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

    # Project hostname
    default_project_hostname="${project_id}.test";
    read -p "- Project hostname ? (${default_project_hostname}) : " project_hostname
    if [[ "${default_project_hostname}" == '' ]];then
        project_hostname="${default_project_hostname}";
    fi;
else
    echo "Using values from WPUInstaller : ${project_name} - ${project_id} - ${project_hostname}";
fi;

# Ask if jQuery is needed
use_jquery='y';
if [[ $is_wp_theme == 'n' ]]; then
    use_jquery=$(intestarter_yn "- Utiliser jQuery ?" 'n');
fi;

add_slick_slider='n';
if [[ $is_wp_theme == 'n' && $is_magento2_skin == 'n' ]]; then
    # Plugins JS
    add_slick_slider=$(intestarter_yn "- Installer Slick Slider ?" 'n');
fi;

if [[ $add_slick_slider == 'y' ]]; then
    # Plugins JS
    add_slick_slider_cutoff=$(intestarter_yn "- Gérer un slider en cut-off ?" 'n');
fi;

add_jsutilities_plugins='n';
if [[ $is_wp_theme == 'n' && $is_magento2_skin == 'n' && $use_jquery == 'y' ]]; then
    # Plugins JS
    add_jsutilities_plugins=$(intestarter_yn "- Utiliser des plugins JSUtilities ?" 'n');
fi;

cd "${MAINDIR}";

###################################
## Basic values
###################################

main_folders="css/ images/ fonts/";
if [[ $is_magento2_skin == 'n' ]];then
    main_folders="${main_folders} js/";
fi;

# CSS / COMPASS
src_folders="scss/ scss/${project_id}/";
src_folders="${src_folders} js/ icons/";

# JS / JSU
directory_jsu="${MAINDIR}JavaScriptUtilities/";
jquery_plugins="fake-select fake-inputbox";
jquery_path="assets/js/jquery/plugins/";
