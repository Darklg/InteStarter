#!/bin/bash

#################################################################
## GESTION DU CSS
#################################################################

echo '## GESTION DU CSS';

cd assets/

# Configuration du viewport
read -p "- Doit-on utiliser Compass (y/n) ? " use_compass

# On y clone CSSCommon
echo '- Recuperation de CSSCommon';
git clone https://github.com/Darklg/CSSCommon.git

# On installe les feuilles de style
if [[ $use_compass == 'y' ]]; then

    # On cree les répertoires contenant le Scss
    compass_folders="scss/ scss/csscommon/ scss/utilities/ scss/"$project_id"/ images/css-sprite/ images/css-sprite-2x/";
    for i in $compass_folders
    do
        if ! [ -d $i ]; then
          echo '- Creation de '$i;
          mkdir $MAINDIR'assets/'$i;
        fi
    done;

    # On cree le fichier de config compass
    mv $MAINDIR"files/config.rb" $MAINDIR"config.rb";

    # On initialise le fichier principal
    touch $MAINDIR"assets/scss/main.scss";
    touch $MAINDIR"assets/scss/"$project_id"/_fonts.scss";
    touch $MAINDIR"assets/scss/"$project_id"/_base.scss";

    echo '<link rel="stylesheet" type="text/css" href="assets/css/main.css" />
' >> $MAINDIR"inc/tpl/header/head.php";

    cp CSSCommon/css/cssc-default.css scss/csscommon/_cssc-default.scss
    cp CSSCommon/css/cssc-common.css scss/csscommon/_cssc-common.scss
    cp CSSCommon/css/cssc-content.css scss/csscommon/_cssc-content.scss
    cp CSSCommon/css/cssc-layouts.css scss/csscommon/_cssc-layouts.scss

    cp -R CSSCommon/scss/utilities/ scss/utilities/

    mv $MAINDIR"files/main.scss" $MAINDIR"assets/scss/main.scss";

else
    cp CSSCommon/css/cssc-default.css css/cssc-default.css
    cp CSSCommon/css/cssc-common.css css/cssc-common.css
    cp CSSCommon/css/cssc-content.css css/cssc-content.css
    cp CSSCommon/css/cssc-layouts.css css/cssc-layouts.css

    echo '<link rel="stylesheet" type="text/css" href="assets/css/cssc-default.css" />
    <link rel="stylesheet" type="text/css" href="assets/css/cssc-common.css" />
    <link rel="stylesheet" type="text/css" href="assets/css/cssc-content.css" />
    <link rel="stylesheet" type="text/css" href="assets/css/cssc-layouts.css" />
    ' >> $MAINDIR"inc/tpl/header/head.php";

fi


# Installation de modules CSS au choix
read -p "- Utiliser des modules CSSCommon (y/n) ? " use_csscommon
if [[ $use_csscommon == 'y' ]]; then
    css_sheets="buttons forms tables grid push navigation tabs images print effects"
    for i in $css_sheets
    do
        read -p "-- Installer le module CSS "$i" (y/n)? " choice
        case "$choice" in
            y|O )
                echo '-- Installation de '$i;

                if [[ $use_compass == 'y' ]]; then
                    cp CSSCommon/css/cssc-$i.css scss/csscommon/_cssc-$i.scss
                    echo '@import "csscommon/_cssc-'$i'.scss";' >> $MAINDIR"assets/scss/main.scss";
                else
                    cp CSSCommon/css/cssc-$i.css css/cssc-$i.css
                    echo '<link rel="stylesheet" type="text/css" href="assets/css/cssc-'$i'.css" />' >> $MAINDIR"inc/tpl/header/head.php";
                fi
            ;;
            * );;
        esac
    done
fi

# Project file
if [[ $use_compass == 'y' ]]; then
echo '/* ----------------------------------------------------------
  '$project_name'
---------------------------------------------------------- */

@import "'$project_id'/_fonts.scss";
@import "'$project_id'/_base.scss";
' >> $MAINDIR"assets/scss/main.scss";
fi


# On supprime CSSCommon
rm -rf CSSCommon

cd $MAINDIR;

# Generate file
if [[ $use_compass == 'y' ]]; then
    compass compile;
fi;