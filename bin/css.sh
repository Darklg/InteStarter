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
    touch "${MAINDIR}assets/scss/${project_id}/_forms.scss";
    if [[ $is_responsive == 'y' ]]; then
        mv "${MAINDIR}files/_base-responsive.scss" "${MAINDIR}assets/scss/${project_id}/_base.scss";
    else
        mv "${MAINDIR}files/_base.scss" "${MAINDIR}assets/scss/${project_id}/_base.scss";
    fi;
    cat "${MAINDIR}files/_base-main.scss" >> "${MAINDIR}assets/scss/${project_id}/_base.scss";

    if [[ $use_onlyassets == 'n' ]]; then
        echo '<link rel="stylesheet" type="text/css" href="assets/css/main.css?v=<?php echo time(); ?>" />' >> "${MAINDIR}inc/tpl/header/head.php";
    fi;

    cd "${MAINDIR}assets/scss/";

    # CSS Common
    if [ $(git rev-parse --is-inside-work-tree) ] || [ $is_wp_theme == 'y' ] || [ $is_magento_skin == 'y' ]; then
        git submodule add https://github.com/Darklg/SassCSSCommon.git csscommon;
    else
        git clone --depth=1 https://github.com/Darklg/SassCSSCommon.git csscommon;
        rm -rf "${MAINDIR}assets/scss/csscommon/.git";
    fi;
    cat "${MAINDIR}files/base-csscommon.scss" >> "${MAINDIR}assets/scss/main.scss";

    # Integento
    if [[ $is_magento_skin == 'y' ]]; then
        git submodule add https://github.com/Darklg/InteGentoStyles.git
        cat "${MAINDIR}files/base-integento.scss" >> "${MAINDIR}assets/scss/main.scss";
    fi;

    # Utilities
    cd "${MAINDIR}assets/";
    cp -R CSSCommon/scss/utilities/ scss/utilities/

    # Retina sprite
    sed -i '' 's/images\/css-sprite/assets\/images\/css-sprite/' scss/utilities/_retina-sprites.scss



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

# Img sprite
if [[ $use_compass_imgsprite == 'y' ]];then
    # Copy images
    mv "${MAINDIR}files/icon-letter.png" "${MAINDIR}assets/images/css-sprite/icon-letter.png";
    mv "${MAINDIR}files/icon-letter-big.png" "${MAINDIR}assets/images/css-sprite-2x/icon-letter.png";
    # Update scss
    sed -i '' 's/\/\/\ imgsprite\ //g' "${MAINDIR}assets/scss/main.scss";
    sed -i '' 's/\/\/\ imgsprite//g' "${MAINDIR}assets/scss/main.scss";
else
    # Delete useless files
    rm "${MAINDIR}assets/scss/utilities/_retina-sprites.scss";
    rm "${MAINDIR}assets/scss/utilities/list-files.rb";
    # Delete useless folders
    rm -rf "${MAINDIR}assets/images/css-sprite/";
    rm -rf "${MAINDIR}assets/images/css-sprite-2x/";
    # Remove old references to imgsprite
    sed -i '' '/^\/\/\ imgsprite/d' "${MAINDIR}assets/scss/main.scss";
    sed -i '' '/list-files.rb")$/d' "${MAINDIR}config.rb";
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

    echo "
.button {
    & {

    }
    &:hover,
    &:focus {

    }
    &:active {

    }
}

.button--secondary {
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
    padding-right: 30px;
    background: transparent no-repeat right 0 center;
    background-image: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAFCAQAAADvCgS4AAAAGklEQVR4AWNg+I8BcQGCyhAAXRlhpcQAQsoAMGIY6KADYAUAAAAASUVORK5CYII=);
}

" >> "${MAINDIR}assets/scss/${project_id}/_forms.scss";

if [[ $is_magento_skin == 'y' ]]; then

    echo "

/* Selectors */

.form-list .field,
.form-list .fields .field {
    @extend %project--fieldgroup;
}

.box-info .box-title h3,
.fieldset .legend {
    @extend %project--legend;
}

.form-list label {
    @extend %project--label;
}

.form-list .input-box {
    select,
    textarea,
    input[type=text],
    input[type=email],
    input[type=password] {
        @extend %project--field;
    }

    select {
        @extend %project--select;
    }
}

/* Radios & Checkboxes
-------------------------- */

%fake-check-ghost,
%fake-radio-ghost {
    & + label {
        padding-left: 1.5em;
    }

    & + label:before {
        top: 0.45em;
        border: 1px solid rgba($color-hl,0.4);
        box-shadow: 0 0 0 1px rgba($color-hl,0);
    }

    &:checked + label:before {
        border-color: $color-hl;
        color: $color-hl;
        box-shadow: 0 0 0 1px rgba($color-hl,0.999);
    }
}

/* Checkboxes */

.form-list {
    li.control {
        z-index: 1;
        position: relative;
    }

    [id=\"primary_billing\"],
    [id=\"primary_shipping\"],
    [id=\"shipping:save_in_address_book\"],
    [id=\"billing:save_in_address_book\"],
    [id=\"shipping:same_as_billing\"],
    #is_subscribed,
    #subscription,
    #change_password {
        @extend %fake-check-ghost;
    }
}

/* Radio */

.sp-methods input[type=radio],
#checkoutSteps input[name=\"shipping_method\"],
#checkoutSteps .control input[name=\"checkout_method\"],
#co-billing-form .control input[type=radio] {
    @extend %fake-radio-ghost;
}

.field.name-prefix .input-box input[type=radio] {
    & {
        @extend %fake-radio-ghost;
    }

    & + label {
        display: inline-block;
        vertical-align: top;
    }

    & + label ~ label {
        margin-left: 2em;
    }
}


" >> "${MAINDIR}assets/scss/${project_id}/_forms.scss";

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
