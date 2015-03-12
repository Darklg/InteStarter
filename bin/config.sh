#!/bin/bash

###################################
## Functions
###################################

## Questions
function intestarter_yn() {
    default_choice="[Y/n]";
    if [[ ${2} == 'n' ]]; then
        default_choice="[y/N]";
    fi;
    while true; do
        read -p "${1} ${default_choice} : " yn
        case $yn in
            [YyOo]* ) yn="y"; break;;
            [Nn]* ) yn="n"; break;;
            * ) yn=${2}; break;;
        esac
    done
    echo "${yn}";
}

## Create slug
function intestarter_slug() {
    # Thx to https://gist.github.com/saml/4674977
    title="$1";
    max_length="${2:-48}";
    slug="$({
        tr '[A-Z]' '[a-z]' | tr -cs '[[:alnum:]]' '-'
    } <<< "$title")";
    slug="${slug##-}";
    slug="${slug%%-}";
    slug="${slug:0:$max_length}";
    echo "${slug}";
}

#################################################################
## CONFIGURATION INITIALE
#################################################################

echo '## CONFIGURATION INITIALE';

# Seulement assets
use_onlyassets=$(intestarter_yn "- Récupérer uniquement les assets ?" 'n');

# Choix du dossier
use_subfolder=$(intestarter_yn "- Créer un sous-dossier \"inte\" ?" 'n');
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
    project_id=$(intestarter_slug "${project_name}");
fi;

if [[ $use_onlyassets == 'n' ]]; then
    # On recupere l'URL du projet
    read -p "- Quelle est l'URL du projet ? " project_url

    # On recupere la description du projet
    read -p "- Quelle est la description rapide du projet ? " project_description
fi;

# Utilisation de Compass
use_compass=$(intestarter_yn "- Utiliser Compass ?" 'y');
use_compass_fonticon='';
use_compass_imgsprite='';
if [[ $use_compass == 'y' ]]; then
    use_compass_fonticon=$(intestarter_yn "- -- Compass : Utiliser une font-icon ?" 'y');
    use_compass_imgsprite=$(intestarter_yn "- -- Compass : Utiliser des sprites image ?" 'n');
fi;

# Modules supplementaires CSSCommon
use_csscommon=$(intestarter_yn "- Utiliser des modules supplementaires CSSCommon ?" 'n');

# Utilisation de Grunt
use_grunt=$(intestarter_yn "- Utiliser Grunt ?" 'y');
use_regression_tests='';
if [[ $use_grunt == 'y' ]]; then
    # Tests de regression JS
    use_regression_tests=$(intestarter_yn "- Utiliser des tests de regression ?" 'y');
fi;

# Bibliothèque JS
use_jquery=$(intestarter_yn "- Utiliser jQuery ?" 'n');

# Plugins JS
add_jsutilities_plugins=$(intestarter_yn "- Utiliser des plugins JSUtilities ?" 'n');

# Support IE < 9
support_ie8=$(intestarter_yn "- Gérer IE8 ?" 'n');

# Responsive
is_responsive=$(intestarter_yn "- Est-ce un site responsive ?" 'y');
content_width='';
content_width_wide='';
if [[ $is_responsive == 'n' ]]; then
    read -p "- Quelle est la largeur du contenu sans marges (Default:980) ? " content_width
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

if [[ $use_onlyassets == 'n' ]]; then
    sed -i '' "s/--default/--${project_id}/" "${MAINDIR}inc/tpl/styleguide/forms.php";
fi;

###################################
## Basic values
###################################

main_folders="css/ images/ fonts/ js/ js/ie/";

# CSS / COMPASS
compass_folders="scss/ scss/csscommon/ scss/utilities/ scss/${project_id}/ images/css-sprite/ images/css-sprite-2x/ icons/ icons/original/";
csscommon_default_modules="default common content buttons forms grid layouts";
csscommon_additional_modules="tables push navigation tabs images print effects";

# JS / JSU
directory_jsu="${MAINDIR}JavaScriptUtilities/";
jquery_plugins="fake-select fake-inputbox";
jquery_path="assets/js/jquery/plugins/";