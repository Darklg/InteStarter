#!/bin/bash

#################################################################
## GESTION DU CSS
#################################################################

echo '## GESTION DU CSS';

cd "assets/";

# On y clone CSSCommon
echo '- Recuperation de CSSCommon';
git clone https://github.com/Darklg/CSSCommon.git

# On installe les feuilles de style
if [[ $use_compass == 'y' ]]; then

    # On cree les répertoires contenant le Scss
    for i in $compass_folders
    do
        if ! [ -d "${i}" ]; then
          echo "- Creation de ${i}";
          mkdir "${MAINDIR}assets/${i}";
        fi
    done;

    # On cree le fichier de config compass
    mv "${MAINDIR}files/config.rb" "${MAINDIR}config.rb";

    # On initialise le fichier principal
    touch "${MAINDIR}assets/scss/main.scss";
    touch "${MAINDIR}assets/scss/${project_id}/_fonts.scss";
    touch "${MAINDIR}assets/scss/${project_id}/_forms.scss";
    touch "${MAINDIR}assets/scss/${project_id}/_base.scss";

    if [[ $use_onlyassets != 'y' ]]; then
        echo '<link rel="stylesheet" type="text/css" href="assets/css/main.css" />' >> "${MAINDIR}inc/tpl/header/head.php";
    fi;
    for i in $csscommon_default_modules
    do
        cp "CSSCommon/css/cssc-${i}.css" "scss/csscommon/_cssc-${i}.scss";
        echo "@import \"csscommon/_cssc-${i}.scss\";"; >> "${MAINDIR}assets/scss/main.scss";
    done;

    cp -R CSSCommon/scss/utilities/ scss/utilities/

    sed -i '' 's/images\/css-sprite/assets\/images\/css-sprite/' scss/utilities/_retina-sprites.scss


    mv "${MAINDIR}files/main.scss" "${MAINDIR}assets/scss/main.scss";

else

    for i in $csscommon_default_modules
    do
        cp "CSSCommon/css/cssc-${i}.css" "css/cssc-${i}.css";
        if [[ $use_onlyassets != 'y' ]]; then
            echo "<link rel=\"stylesheet\" type=\"text/css\" href=\"assets/css/cssc-${i}.css\" />" >> "${MAINDIR}inc/tpl/header/head.php";
        fi;
    done;

fi

# Installation de modules CSS au choix
if [[ $use_csscommon == 'y' ]]; then
    for i in $csscommon_additional_modules
    do
        read -p "-- Installer le module CSS ${i} (y/n)? " choice
        case "$choice" in
            y|O )
                echo "-- Installation de ${i}";

                if [[ $use_compass == 'y' ]]; then
                    cp "CSSCommon/css/cssc-${i}.css" "scss/csscommon/_cssc-${i}.scss";
                    echo "@import \"csscommon/_cssc-${i}.scss\";"; >> "${MAINDIR}assets/scss/main.scss";
                else
                    cp "CSSCommon/css/cssc-${i}.css" "css/cssc-${i}.css";
                    if [[ $use_onlyassets != 'y' ]]; then
                        echo "<link rel=\"stylesheet\" type=\"text/css\" href=\"assets/css/cssc-${i}.css\" />" >> "${MAINDIR}inc/tpl/header/head.php";
                    fi;
                fi
            ;;
            * );;
        esac
    done
fi

# Img sprite
if [[ $use_compass_imgsprite == 'y' ]];then
    # Copy images
    mv "${MAINDIR}files/icon-letter.png" "${MAINDIR}assets/images/css-sprite/icon-letter.png";
    mv "${MAINDIR}files/icon-letter-big.png" "${MAINDIR}assets/images/css-sprite-2x/icon-letter.png";
    # Update scss
    sed -i '' 's/\/\/\ imgsprite\ //g' "${MAINDIR}assets/scss/main.scss";
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
    mv "${MAINDIR}files/icn-heart.svg" "${MAINDIR}assets/icons/original/icn-heart.svg";
    touch "${MAINDIR}assets/scss/${project_id}/_icons.scss";
    echo "@import \"${project_id}/_icons.scss\";" >> "${MAINDIR}assets/scss/main.scss";
    # Update Scss
    sed -i '' 's/\/\/\ fonticon\ //g' "${MAINDIR}assets/scss/main.scss";
fi;

if [[ $use_compass == 'y' ]]; then
# Project file
echo "@import \"${project_id}/_fonts.scss\";
@import \"${project_id}/_base.scss\";
" >> "${MAINDIR}assets/scss/main.scss";

# Forms file
echo "@charset \"UTF-8\";

/* ----------------------------------------------------------
  Buttons
---------------------------------------------------------- */

.cssc-button--${project_id} {

}

/* ----------------------------------------------------------
  Forms
---------------------------------------------------------- */

.cssc-form--${project_id} {

}
" >> "${MAINDIR}assets/scss/${project_id}/_forms.scss";
fi

# On supprime CSSCommon
rm -rf CSSCommon

cd "${MAINDIR}";