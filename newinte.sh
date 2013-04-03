#!/bin/bash

# On clone le repository
echo '# RECUPERATION DE INTESTARTER'
git clone git://github.com/Darklg/InteStarter.git


read -p "# - Utiliser un sous-dossier (y/n) ? " use_subfolder
case "$use_subfolder" in
    y|Y|O|o )
        # On renomme le dossier créé et on s'y déplace
        mv InteStarter inte
        cd inte/
    ;;
    * )
        # On récupère le contenu du dossier cré
        mv InteStarter/* .
        rm -rf InteStarter/
    ;;
esac

# On recupere le nom du projet
read -p "# - Comment s'appelle ce projet ? " project_name
echo "define('PROJECT_NAME','"${project_name/\'/’}"');" >> inc/config.php

# On recupere le nom du projet
read -p "# - Quel est la description rapide du projet ? " project_description
echo "define('PROJECT_DESCRIPTION','"${project_description/\'/’}"');" >> inc/config.php

# On cree le repertoire des assets
if ! [ -d assets/ ]; then
  mkdir assets/
fi

cd assets/

# On cree le répertoire contenant les images
if ! [ -d images/ ]; then
  mkdir images/
fi

# On cree le répertoire contenant les fonts
if ! [ -d fonts/ ]; then
  mkdir fonts/
fi

# On cree le répertoire contenant le JS
if ! [ -d js/ ]; then
  mkdir js/
fi

# On essaie de télécharger une librairie JS
cd js/
read -p "# - Utiliser Mootools, jQuery, ou aucune librairie (m/j/n) ? " choice
case "$choice" in
    m|M )
        echo '# GO MOOTOOLS'
        curl -O http://ajax.googleapis.com/ajax/libs/mootools/1.4/mootools-yui-compressed.js;
        if test -f mootools-yui-compressed.js; then
            echo '<script src="assets/js/mootools-yui-compressed.js"></script><script src="assets/js/events.js"></script>' >> ../../inc/tpl/header/head.php;
            echo "window.addEvent('domready',function(){});" > events.js;
        fi
    ;;
    j|J )
        echo '# OK POUR JQUERY'
        curl -O http://code.jquery.com/jquery.min.js;
        if test -f jquery.min.js; then
            echo '<script src="assets/js/jquery.min.js"></script><script src="assets/js/events.js"></script>' >> ../../inc/tpl/header/head.php;
            echo "jQuery(document).ready(function($) {});" > events.js;
        fi
    ;;
    * )
        echo "# OK, PAS DE LIBRAIRIE JS";
        echo '<script src="assets/js/events.js"></script>' >> ../../inc/tpl/header/head.php;
        echo "(function(){})();" > events.js;
    ;;
esac
cd ..

# On recupere html5shim
echo '# RECUPERATION DE HTML5SHIM'
cd js/
curl -O http://html5shim.googlecode.com/svn/trunk/html5.js
cd ..
if test -f js/html5.js; then
    echo '<!--[if lt IE 9]><script src="assets/js/html5.js"></script><![endif]-->' >> ../inc/tpl/header/head.php
fi

# On recupere selectivizr
echo '# RECUPERATION DE SELECTIVIZR'
mkdir selectivizr
cd selectivizr
curl -O http://selectivizr.com/downloads/selectivizr-1.0.2.zip
unzip selectivizr-1.0.2.zip
cd ..
if test -f selectivizr/selectivizr-min.js; then
    mv selectivizr/selectivizr-min.js js/selectivizr-min.js
    echo '<!--[if lt IE 9]><script src="assets/js/selectivizr-min.js"></script><![endif]-->' >> ../inc/tpl/header/head.php
fi
rm -rf selectivizr/

# On y clone CSSCommon
echo '# RECUPERATION DE CSSCOMMON'
git clone git://github.com/Darklg/CSSCommon.git

# On installe les feuilles de style
cp CSSCommon/css/cssc-default.css css/cssc-default.css
cp CSSCommon/css/cssc-common.css css/cssc-common.css
cp CSSCommon/css/cssc-base.css css/cssc-base.css

echo "
@import 'cssc-default.css';
@import 'cssc-common.css';
@import 'cssc-base.css';" >> css/zz-all.css


read -p "# - Utiliser des modules CSSCommon (y/n) ? " use_csscommon
if [[ $use_csscommon == 'y' ]]; then
    # Installation de feuilles CSS au choix
    css_sheets="buttons forms tables grid messages push modeles layouts tabs"
    for i in $css_sheets
    do
        read -p "# --- Installer le module CSS "$i" (y/n)? " choice
        case "$choice" in
            y|O )
                echo '# Installation de '$i
                cp CSSCommon/css/cssc-$i.css css/cssc-$i.css
                echo "@import 'cssc-"$i".css';" >> css/zz-all.css
            ;;
            * );;
        esac
    done
fi

# On supprime CSSCommon
rm -rf CSSCommon

# On revient à la racine
cd ..

echo '# CUSTOM';

# Configuration du viewport
read -p "# - Quelle est la largeur du contenu ? " content_width
if [[ $content_width != '' ]]; then
    content_width_wide=$(( $content_width+40 ));
    echo 'Viewport utilisé : '$content_width_wide;
    sed -i '' 's/width=980/width='$content_width_wide'/' inc/tpl/header/head.php
fi

echo '# MENAGE'

# Suppression des fichiers inutiles & de développement
rm -rf .git
rm README.md
rm newinte.sh

echo '# LETS WORK, BABY !'