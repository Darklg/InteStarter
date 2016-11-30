#!/bin/bash

#################################################################
## GESTION DU CSS
#################################################################

echo '## GESTION DU CSS';

cd "assets/";

# On y clone CSSCommon
echo '- Recuperation de CSSCommon';
git clone --depth=1 https://github.com/Darklg/CSSCommon.git

# On installe les feuilles de style
if [[ $use_compass == 'y' ]]; then


    # On cree les répertoires contenant le Scss
    for i in $compass_folders
    do
        if ! [ -d "${i}" ]; then
          echo "- Creation de ${i}";
          mkdir "${MAINDIR}assets/${i}";
        fi;
    done;

    # On cree le fichier de config compass
    mv "${MAINDIR}files/config.rb" "${MAINDIR}config.rb";

    # On initialise le fichier principal
    mv "${MAINDIR}files/main.scss" "${MAINDIR}assets/scss/main.scss";
    touch "${MAINDIR}assets/scss/${project_id}/_fonts.scss";
    touch "${MAINDIR}assets/scss/${project_id}/_plugins.scss";
    touch "${MAINDIR}assets/scss/${project_id}/_forms.scss";
    mv "${MAINDIR}files/_base.scss" "${MAINDIR}assets/scss/${project_id}/_base.scss";

    if [[ $use_onlyassets == 'n' ]]; then
        echo '<link rel="stylesheet" type="text/css" href="assets/css/main.css?v=<?php echo time(); ?>" />' >> "${MAINDIR}inc/tpl/header/head.php";
    fi;

    cd "${MAINDIR}assets/scss/";

    # CSS Common
    if [ $(git rev-parse --is-inside-work-tree) ] || [ $is_wp_theme == 'y' ] || [ $is_magento_skin == 'y' ]; then
        echo "-- add SassCSSCommon submodule";
        git submodule add https://github.com/Darklg/SassCSSCommon.git csscommon;
    else
        echo "-- clone SassCSSCommon";
        git clone --depth=1 https://github.com/Darklg/SassCSSCommon.git csscommon;
        rm -rf "${MAINDIR}assets/scss/csscommon/.git";
    fi;
    cat "${MAINDIR}files/base-csscommon.scss" >> "${MAINDIR}assets/scss/main.scss";

    # Integento
    if [[ $is_magento_skin == 'y' ]]; then
        git submodule add https://github.com/Darklg/InteGentoStyles.git
        cat "${MAINDIR}files/base-integento.scss" >> "${MAINDIR}assets/scss/main.scss";
    fi;

else

    for i in $csscommon_default_modules
    do
        cp "CSSCommon/css/cssc-${i}.css" "css/cssc-${i}.css";
        if [[ $use_onlyassets != 'y' ]]; then
            echo "<link rel=\"stylesheet\" type=\"text/css\" href=\"assets/css/cssc-${i}.css\" />" >> "${MAINDIR}inc/tpl/header/head.php";
        fi;
    done;

fi;

# Installation de modules CSS au choix
if [[ $use_csscommon == 'y' ]]; then
    for i in $csscommon_additional_modules
    do
        read -p "-- Installer le module CSS ${i} (y/n)? " choice
        case "$choice" in
            y|Y|O )
                echo "-- Installation de ${i}";
                cp "CSSCommon/css/cssc-${i}.css" "css/cssc-${i}.css";
                if [[ $use_onlyassets != 'y' ]]; then
                    echo "<link rel=\"stylesheet\" type=\"text/css\" href=\"assets/css/cssc-${i}.css\" />" >> "${MAINDIR}inc/tpl/header/head.php";
                fi;
            ;;
            * );;
        esac;
    done;
fi;


if [[ $use_compass == 'y' ]]; then
# Project file
echo "
/* ----------------------------------------------------------
  ${project_name}
---------------------------------------------------------- */
" >> "${MAINDIR}assets/scss/main.scss";
fi;

# Font icon
if [[ $use_compass_fonticon == 'y' ]];then
    rsync -az "${MAINDIR}files/icons/" "${MAINDIR}assets/icons/original/";
    touch "${MAINDIR}assets/scss/${project_id}/_icons.scss";
    echo "@import \"${project_id}/icons\";" >> "${MAINDIR}assets/scss/main.scss";
    # Update Scss
    sed -i '' 's/\/\/\ fonticon\ //g' "${MAINDIR}assets/scss/main.scss";
    # Tweak icons
    cat "${MAINDIR}files/base-icons.scss" >> "${MAINDIR}assets/scss/${project_id}/_base.scss";
fi;

if [[ $use_compass == 'y' ]]; then
# Project file
echo "@import \"${project_id}/fonts\";
@import \"${project_id}/plugins\";
@import \"${project_id}/forms\";
@import \"${project_id}/base\";
@import \"${project_id}/header\";
@import \"${project_id}/footer\";
@import \"${project_id}/home\";
@import \"${project_id}/content\";" >> "${MAINDIR}assets/scss/main.scss";

# Main files
touch "${MAINDIR}assets/scss/${project_id}/_header.scss"
touch "${MAINDIR}assets/scss/${project_id}/_footer.scss"
touch "${MAINDIR}assets/scss/${project_id}/_home.scss"
touch "${MAINDIR}assets/scss/${project_id}/_content.scss"

# Content file
echo "@charset \"UTF-8\";

/* ----------------------------------------------------------
  Content
---------------------------------------------------------- */

.cssc-content {
    font-size: 14px;
}

.cssc-content {
    h2, h3, h4 {
        font-family: \$font-second;
    }
}

" >> "${MAINDIR}assets/scss/${project_id}/_content.scss";

# Forms file
echo "@charset \"UTF-8\";

/* ----------------------------------------------------------
  Buttons
---------------------------------------------------------- */

.cssc-button--${project_id} {
    & {

    }
    &:hover,
    &:focus {

    }
    &:active {

    }
}
" >> "${MAINDIR}assets/scss/${project_id}/_forms.scss";
fi;

if [[ $is_magento_skin == 'y' ]]; then
    cat "${MAINDIR}files/magento/buttons.scss" >> "${MAINDIR}assets/scss/${project_id}/_forms.scss";
fi;

echo "
/* ----------------------------------------------------------
  Forms
---------------------------------------------------------- */

.cssc-form--${project_id} {

}

/* Form items */

%project--fieldgroup {
    & {
        margin-bottom: 2em;
    }

    &:last-child {
        margin-bottom: 0;
    }
}

%project--legend {
    margin-bottom: 1.1em;
    text-transform: uppercase;
    font-size: 1.1em;
}

%project--label {
    text-transform: uppercase;
}

%project--field,
%project--select {
    @extend .inputreset;
}

%project--field {
    border: 1px solid #000;
}

%project--select {
    @extend .cssc-select;
    padding-right: 30px!important;
    background: transparent no-repeat right 0 center;
    background-image: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAFCAQAAADvCgS4AAAAGklEQVR4AWNg+I8BcQGCyhAAXRlhpcQAQsoAMGIY6KADYAUAAAAASUVORK5CYII=);
}

" >> "${MAINDIR}assets/scss/${project_id}/_forms.scss";

if [[ $is_magento_skin == 'y' ]]; then

    cat "${MAINDIR}files/magento/forms.scss" >> "${MAINDIR}assets/scss/${project_id}/_forms.scss";

else

    echo "

/* Selectors */

.cssc-form label {
    @extend %project--label;
}

.cssc-form .box  {
    select,
    textarea,
    input[type=text],
    input[type=email],
    input[type=password] {
        @extend %project--field;
    }
}
" >> "${MAINDIR}assets/scss/${project_id}/_forms.scss";

fi;

# On supprime CSSCommon
rm -rf CSSCommon

cd "${MAINDIR}";
