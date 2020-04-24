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

is_magento_skin='n';
if [[ $is_wp_theme == 'n' ]]; then
    is_magento_skin=$(intestarter_yn "- Est-ce un skin Magento 1 ?" 'n');
fi;

is_magento2_skin='n';
if [[ $is_wp_theme == 'n' && $is_magento_skin == 'n' ]]; then
    is_magento2_skin=$(intestarter_yn "- Est-ce un skin Magento 2 ?" 'n');
fi;

if [[ $is_magento2_skin == 'y' ]]; then
    ASSETSDIR="${MAINDIR}";
    SCSSDIR="${ASSETSDIR}/styles";
    SCSSFILE="${SCSSDIR}/styles.scss";
fi;

create_utils_magento='n';
if [[ $is_magento_skin == 'y' ]]; then
    create_utils_magento=$(intestarter_yn "- Creer un dossier _utils/ ?" 'n');
fi;

# Seulement assets
use_onlyassets='y';
if [[ $is_wp_theme == 'n' && $is_magento_skin == 'n' && $is_magento2_skin == 'n' ]]; then
    use_onlyassets=$(intestarter_yn "- Récupérer uniquement les assets ?" 'n');
fi;

# Site dynamique
is_static='n';
if [[ $is_wp_theme == 'n' && $is_magento_skin == 'n' && $is_magento2_skin == 'n' && $use_onlyassets == 'n' ]]; then
    is_static=$(intestarter_yn "- Est-ce un site statique ?" 'n');
fi;

if [[ $use_onlyassets == 'y' ]]; then
    rm "InteStarter/index.php";
    rm "InteStarter/styleguide.php";
fi;
if [[ $is_wp_theme == 'n' ]]; then
    rm "InteStarter/styleguide-wp.php";
fi;

# Choix du dossier
use_subfolder='n';
if [[ $is_wp_theme == 'n' && $is_magento_skin == 'n' && $is_magento2_skin == 'n' ]]; then
    use_subfolder=$(intestarter_yn "- Créer un sous-dossier \"inte\" ?" 'n');
fi;
case "$use_subfolder" in
    y|Y|O|o )
        # On renomme le dossier créé et on s'y déplace
        mv "InteStarter" "inte";
        cd "inte/";
        MAINDIR="${PWD}/";
        EXECDIR="${PWD}/";
    ;;
    * )
        if [[ $is_wp_theme == 'y' ]]; then
            # Moving useful files
            if [ ! -d "tpl/" ]; then
                mkdir "tpl/";
            fi;

            if [[ $use_gulp == 'n' ]];then
                mkdir "tpl/styleguide/";
                cp -R "InteStarter/inc/tpl/styleguide/" "tpl/styleguide/";
            fi;

            # Removing useless files
            rm -rf "InteStarter/inc/";

        fi;

        # On récupère le contenu du dossier créé
        mv InteStarter/* .
        rm -rf "InteStarter/";
        EXECDIR="${PWD}/";
    ;;
esac

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


use_gulp=$(intestarter_yn "- Utiliser Gulp ?" 'y');
if [[ "${use_gulp}" == 'y' ]];then
    use_compass='y';
    use_compass_fonticon='y';
    use_regression_tests='n';
    use_grunt='n';
else
    # Utilisation de Compass
    use_compass=$(intestarter_yn "- Utiliser Compass ?" 'y');
    use_compass_fonticon='';
    if [[ $use_compass == 'y' ]]; then
        use_compass_fonticon=$(intestarter_yn "- -- Compass : Utiliser une font-icon ?" 'y');
    fi;

    # Modules supplementaires CSSCommon
    use_csscommon='n';
    if [[ $use_compass == 'n' ]]; then
        use_csscommon=$(intestarter_yn "- Utiliser des modules supplementaires CSSCommon ?" 'n');
    fi;

    # Utilisation de Grunt
    use_regression_tests='n';
    use_grunt=$(intestarter_yn "- Utiliser Grunt ?" 'y');
    if [[ $use_grunt == 'y' && $is_wp_theme == 'n' && $is_magento_skin == 'n' && $is_magento2_skin == 'n' && $use_onlyassets == 'n' ]]; then
        # Tests de regression JS
        use_regression_tests=$(intestarter_yn "- Utiliser des tests de regression ?" 'y');
    fi;
fi

use_jquery='n';
if [[ $is_wp_theme == 'n' && $is_magento_skin == 'n' && $is_magento2_skin == 'n' ]]; then
    # Bibliothèque JS
    use_jquery=$(intestarter_yn "- Utiliser jQuery ?" 'n');
fi;

add_slick_slider='n';
if [[ $use_jquery == 'y' ]]; then
    # Plugins JS
    add_slick_slider=$(intestarter_yn "- Installer Slick Slider ?" 'n');
fi;

add_jsutilities_plugins='n';
if [[ $is_wp_theme == 'n' && $is_magento_skin == 'n' && $is_magento2_skin == 'n' && $use_jquery == 'y' ]]; then
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
intestarter_sed "s/--default/--${project_id}/" "${styleguide_forms_path}tpl/styleguide/forms.php";

###################################
## Basic values
###################################

main_folders="css/ images/ fonts/";
if [[ $is_magento2_skin == 'n' ]];then
    main_folders="${main_folders} js/";
fi;

# CSS / COMPASS
if [[ $is_magento2_skin == 'y' ]]; then
    compass_folders="styles/ styles/${project_id}/";
else
    compass_folders="scss/ scss/${project_id}/";
fi;
compass_folders="${compass_folders} icons/ icons/original/";
csscommon_default_modules="default common content buttons forms grid layouts";
csscommon_additional_modules="tables push navigation tabs images print effects";

# JS / JSU
directory_jsu="${MAINDIR}JavaScriptUtilities/";
jquery_plugins="fake-select fake-inputbox";
jquery_path="assets/js/jquery/plugins/";
