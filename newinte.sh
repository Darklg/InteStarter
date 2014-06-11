#!/bin/bash

# On clone le repository
echo '# - RECUPERATION DE INTESTARTER'
git clone git://github.com/Darklg/InteStarter.git

#################################################################
## CONFIGURATION INITIALE
#################################################################

echo '## CONFIGURATION INITIALE';

# Choix du dossier
read -p "- Utiliser un sous-dossier (y/n) ? " use_subfolder
case "$use_subfolder" in
    y|Y|O|o )
        # On renomme le dossier créé et on s'y déplace
        mv InteStarter inte
        cd inte/
    ;;
    * )
        # On récupère le contenu du dossier créé
        mv InteStarter/* .
        rm -rf InteStarter/
    ;;
esac

# On recupere le nom du projet
read -p "- Comment s'appelle ce projet ? " project_name
echo "define('PROJECT_NAME','"${project_name/\'/’}"');" >> inc/config.php

# On recupere l'URL du projet
read -p "- Quelle est l'URL du projet ? " project_url
echo "define('PROJECT_URL','"${project_url/\'/’}"');" >> inc/config.php

# On recupere la description du projet
read -p "- Quel est la description rapide du projet ? " project_description
echo "define('PROJECT_DESCRIPTION','"${project_description/\'/’}"');" >> inc/config.php


#################################################################
## CREATION DES DOSSIERS
#################################################################

echo '## CREATION DES DOSSIERS';

# On cree le repertoire des assets
if ! [ -d assets/ ]; then
  echo '- Creation de assets/';
  mkdir assets/
fi

cd assets/

# On cree le répertoire contenant le CSS
if ! [ -d css/ ]; then
  echo '- Creation de css/';
  mkdir css/
fi

# On cree le répertoire contenant les images
if ! [ -d images/ ]; then
  echo '- Creation de images/';
  mkdir images/
fi

# On cree le répertoire contenant les fonts
if ! [ -d fonts/ ]; then
  echo '- Creation de fonts/';
  mkdir fonts/
fi

# On cree le répertoire contenant le JS
if ! [ -d js/ ]; then
  echo '- Creation de js/';
  mkdir js/
fi

cd ..

#################################################################
## GESTION DU CSS
#################################################################

echo '## GESTION DU CSS';

cd assets/

# On y clone CSSCommon
echo '- Recuperation de CSSCommon';
git clone git://github.com/Darklg/CSSCommon.git

# On installe les feuilles de style
cp CSSCommon/css/cssc-default.css css/cssc-default.css
cp CSSCommon/css/cssc-common.css css/cssc-common.css
cp CSSCommon/css/cssc-content.css css/cssc-content.css

echo '<link rel="stylesheet" type="text/css" href="cssc-default.css" />
<link rel="stylesheet" type="text/css" href="cssc-common.css" />
<link rel="stylesheet" type="text/css" href="cssc-content.css" />
' >> ../inc/tpl/header/head.php;

# Installation de modules CSS au choix
read -p "- Utiliser des modules CSSCommon (y/n) ? " use_csscommon
if [[ $use_csscommon == 'y' ]]; then
    css_sheets="buttons forms tables grid push navigation layouts tabs images print effects"
    for i in $css_sheets
    do
        read -p "-- Installer le module CSS "$i" (y/n)? " choice
        case "$choice" in
            y|O )
                echo '-- Installation de '$i;
                pwd;
                cp CSSCommon/css/cssc-$i.css css/cssc-$i.css
                echo '<link rel="stylesheet" type="text/css" href="cssc-'$i'.css" />' >> ../inc/tpl/header/head.php;
            ;;
            * );;
        esac
    done
fi

# On supprime CSSCommon
rm -rf CSSCommon

cd ..

#################################################################
## GESTION DU JS
#################################################################

echo '## GESTION DU JS';

# On ajoute les fichiers JS essentiels
cd assets/js/

# On propose de télécharger une librairie JS
read -p "- Utiliser Mootools, jQuery, ou aucune librairie (m/j/n) ? " choice
case "$choice" in
    m|M )
        echo '- Installation de MooTools';
        curl -O http://ajax.googleapis.com/ajax/libs/mootools/1.4/mootools-yui-compressed.js;
        if test -f mootools-yui-compressed.js; then
            echo '<script src="assets/js/mootools-yui-compressed.js"></script><script src="assets/js/events.js"></script>' >> ../../inc/tpl/header/head.php;
            echo "window.addEvent('domready',function(){});" > events.js;
        fi
    ;;
    j|J )
        echo '- Installation de jQuery';
        curl -O http://code.jquery.com/jquery.min.js;
        if test -f jquery.min.js; then
            echo '<script src="assets/js/jquery.min.js"></script><script src="assets/js/events.js"></script>' >> ../../inc/tpl/header/head.php;
            echo "jQuery(document).ready(function($) {});" > events.js;
        fi
    ;;
    * )
        echo '- Aucune librairie utilisée.';
        echo '<script src="assets/js/events.js"></script>' >> ../../inc/tpl/header/head.php;
        echo "(function(){})();" > events.js;
    ;;
esac

cd ../..

#################################################################
## COMPATIBILITE IE
#################################################################

echo '## COMPATIBILITE IE';

cd assets/js/

# On recupere html5shim
echo '- Récupération de html5shim ( Tags HTML5 sur IE < 9 )';
curl -O http://html5shim.googlecode.com/svn/trunk/html5.js
cd ..
if test -f js/html5.js; then
    echo '<!--[if lt IE 9]><script src="assets/js/html5.js"></script><![endif]-->' >> ../inc/tpl/header/head.php
fi

# On recupere selectivizr
echo '- Récupération de selectivizr ( Selecteurs avancés sur IE < 9 )';
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
cd ..

#################################################################
## VIEWPORT & RESPONSIVE
#################################################################

echo '## VIEWPORT & RESPONSIVE';

# Configuration du viewport
read -p "- Est-ce un site responsive (y/n) ? " is_responsive
case "$is_responsive" in
    y|Y|O|o )
        sed -i '' 's/width=980/width=device-width/' inc/tpl/header/head.php
        sed -i '' 's/<body>/<body class="cssc-is-responsive">/' inc/tpl/header.php
    ;;
    * )
        read -p "- Quelle est la largeur du contenu sans marges (Default:980) ? " content_width
        if [[ $content_width != '' ]]; then
            content_width_wide=$(( $content_width+40 ));
            echo 'Viewport utilisé : '$content_width_wide;
            sed -i '' 's/width=980/width='$content_width_wide'/' inc/tpl/header/head.php
        fi
    ;;
esac

#################################################################
## MENAGE
#################################################################

echo '## MENAGE';

# Suppression des fichiers inutiles & de développement
rm -rf .git
rm README.md
rm newinte.sh
rm deploy.sh

echo '## LET’S WORK, BABY !'