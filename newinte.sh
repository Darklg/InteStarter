#!/bin/bash

# On clone le repository
echo '# - RECUPERATION DE INTESTARTER'
git clone https://github.com/Darklg/InteStarter.git

#################################################################
## CONFIGURATION INITIALE
#################################################################

echo '## CONFIGURATION INITIALE';

MAINDIR=${PWD}"/";

# Choix du dossier
read -p "- Utiliser un sous-dossier (y/n) ? " use_subfolder
case "$use_subfolder" in
    y|Y|O|o )
        # On renomme le dossier créé et on s'y déplace
        mv InteStarter inte
        cd inte/
        MAINDIR=${PWD}"/";
    ;;
    * )
        # On récupère le contenu du dossier créé
        mv InteStarter/* .
        rm -rf InteStarter/
    ;;
esac

# On recupere le nom du projet
read -p "- Comment s'appelle ce projet ? (Front-End) " project_name
if [[ $project_name == '' ]]; then
    project_name='Front-End';
fi;
echo "define('PROJECT_NAME','"${project_name/\'/’}"');" >> $MAINDIR"inc/config.php";

# On recupere l'ID du projet
read -p "- Quel est l'ID de ce projet ? (default) " project_id
if [[ $project_id == '' ]]; then
    project_id='default';
fi;
echo "define('PROJECT_ID','"${project_id/\'/’}"');" >> $MAINDIR"inc/config.php";

# On recupere l'URL du projet
read -p "- Quelle est l'URL du projet ? " project_url
echo "define('PROJECT_URL','"${project_url/\'/’}"');" >> $MAINDIR"inc/config.php";

# On recupere la description du projet
read -p "- Quel est la description rapide du projet ? " project_description
echo "define('PROJECT_DESCRIPTION','"${project_description/\'/’}"');" >> $MAINDIR"inc/config.php";


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

# On cree les répertoires principaux
main_folders="css/ images/ fonts/ js/ js/ie/";
for i in $main_folders
do
    if ! [ -d $i ]; then
      echo '- Creation de '$i;
      mkdir $MAINDIR'assets/'$i;
    fi
done;

cd $MAINDIR;

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
    touch $MAINDIR"config.rb";
    echo 'require File.join(File.dirname(__FILE__), "/assets/scss/utilities/list-files.rb")
http_path = "/"
css_dir = "assets/css"
sass_dir = "assets/scss"
images_dir = "assets/images"
javascripts_dir = "assets/js"
output_style = :compressed
relative_assets = true
line_comments = false
preferred_syntax = :scss' > $MAINDIR"config.rb";

    # On initialise le fichier principal
    touch $MAINDIR"assets/scss/main.scss";
    touch $MAINDIR"assets/scss/"$project_id"/_base.scss";

    echo '<link rel="stylesheet" type="text/css" href="assets/css/main.css" />
' >> $MAINDIR"inc/tpl/header/head.php";

    cp CSSCommon/css/cssc-default.css scss/csscommon/_cssc-default.scss
    cp CSSCommon/css/cssc-common.css scss/csscommon/_cssc-common.scss
    cp CSSCommon/css/cssc-content.css scss/csscommon/_cssc-content.scss

    cp -R CSSCommon/scss/utilities/ scss/utilities/

    echo '@charset "UTF-8";

/* ----------------------------------------------------------
  Config
---------------------------------------------------------- */

/* Vars
-------------------------- */

$color-main: #000;

/* Directories
-------------------------- */

// $sprites: sprite-map("css-sprite/*.png");       /* :) */
// $sprites2x: sprite-map("css-sprite-2x/*.png");  /* :) */

/* ----------------------------------------------------------
  Utilities
---------------------------------------------------------- */

@import "utilities/_plugins.scss";
@import "utilities/_retina-sprites.scss";

/* ----------------------------------------------------------
  CSSCommon
---------------------------------------------------------- */

@import "csscommon/_cssc-default.scss";
@import "csscommon/_cssc-common.scss";
@import "csscommon/_cssc-content.scss";
' >> $MAINDIR"assets/scss/main.scss";

else
    cp CSSCommon/css/cssc-default.css css/cssc-default.css
    cp CSSCommon/css/cssc-common.css css/cssc-common.css
    cp CSSCommon/css/cssc-content.css css/cssc-content.css

    echo '<link rel="stylesheet" type="text/css" href="assets/css/cssc-default.css" />
    <link rel="stylesheet" type="text/css" href="assets/css/cssc-common.css" />
    <link rel="stylesheet" type="text/css" href="assets/css/cssc-content.css" />
    ' >> $MAINDIR"inc/tpl/header/head.php";

fi


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
        mkdir jquery;
        cd jquery;
        mkdir classes;
        curl -O http://ajax.googleapis.com/ajax/libs/mootools/1.4/mootools-yui-compressed.js;
        if test -f mootools-yui-compressed.js; then
            echo '<script src="assets/js/mootools/mootools-yui-compressed.js"></script><script src="assets/js/events.js"></script>' >> $MAINDIR"inc/tpl/header/head.php";
            echo "window.addEvent('domready',function(){});" > $MAINDIR"assets/js/events.js";
        fi
    ;;
    j|J )
        echo '- Installation de jQuery';
        mkdir jquery;
        cd jquery;
        mkdir plugins;
        curl -O http://code.jquery.com/jquery.min.js;
        if test -f jquery.min.js; then
            echo '<script src="assets/js/jquery/jquery.min.js"></script><script src="assets/js/events.js"></script>' >> $MAINDIR"inc/tpl/header/head.php";
            echo "jQuery(document).ready(function($) {});" > $MAINDIR"assets/js/events.js";
        fi
    ;;
    * )
        echo '- Aucune librairie utilisée.';
        echo '<script src="assets/js/events.js"></script>' >> $MAINDIR"inc/tpl/header/head.php";
        echo "(function(){})();" > $MAINDIR"assets/js/events.js";
    ;;
esac

cd $MAINDIR;

#################################################################
## Utiliser Grunt
#################################################################

# Demande de confirmation
read -p "- Utiliser Grunt (y/n) ? " use_grunt
if [[ $use_grunt == 'y' ]]; then
    # Create package.json
    echo '{"name": "'$project_id'","version": "0.0.0","description": ""}' > $MAINDIR"package.json";
    # Install Grunt & default modules
    npm install --save-dev grunt-shell;

    # Create Grunt File
    echo "module.exports = function(grunt) {
    // Load modules
    grunt.loadNpmTasks('grunt-shell');
    grunt.loadNpmTasks('grunt-contrib-clean');

    // Project configuration.
    grunt.initConfig({
        clean: ['**/.DS_Store', '**/thumbs.db']
    });

    // Load tasks
    grunt.registerTask('default', []);
};" > $MAINDIR"Gruntfile.js";
fi;

cd $MAINDIR;

#################################################################
## COMPATIBILITE IE
#################################################################

echo '## COMPATIBILITE IE';

cd assets/js/ie/;

# On recupere html5shim
echo '- Récupération de html5shim ( Tags HTML5 sur IE < 9 )';
curl -O http://html5shim.googlecode.com/svn/trunk/html5.js
if test -f html5.js; then
    echo '<!--[if lt IE 9]><script src="assets/js/html5.js"></script><![endif]-->' >> $MAINDIR"inc/tpl/header/head.php";
fi

# On recupere selectivizr
echo '- Récupération de selectivizr ( Selecteurs avancés sur IE < 9 )';
mkdir selectivizr
cd selectivizr
curl -O http://selectivizr.com/downloads/selectivizr-1.0.2.zip
unzip selectivizr-1.0.2.zip
cd ..
if test -f selectivizr/selectivizr-min.js; then
    mv selectivizr/selectivizr-min.js selectivizr-min.js
    echo '<!--[if lt IE 9]><script src="assets/js/selectivizr-min.js"></script><![endif]-->' >> $MAINDIR"inc/tpl/header/head.php";
fi
rm -rf selectivizr/

cd $MAINDIR;

#################################################################
## VIEWPORT & RESPONSIVE
#################################################################

echo '## VIEWPORT & RESPONSIVE';

# Configuration du viewport
read -p "- Est-ce un site responsive (y/n) ? " is_responsive
case "$is_responsive" in
    y|Y|O|o )
        sed -i '' 's/width=980/width=device-width/' $MAINDIR"inc/tpl/header/head.php";
        sed -i '' 's/<body>/<body class="cssc-is-responsive">/' $MAINDIR"inc/tpl/header.php";
    ;;
    * )
        read -p "- Quelle est la largeur du contenu sans marges (Default:980) ? " content_width
        if [[ $content_width != '' ]]; then
            content_width_wide=$(( $content_width+40 ));
            echo 'Viewport utilisé : '$content_width_wide;
            sed -i '' 's/width=980/width='$content_width_wide'/' $MAINDIR"inc/tpl/header/head.php";
        fi
    ;;
esac

#################################################################
## MENAGE
#################################################################

echo '## MENAGE';

cd $MAINDIR;

# Suppression des fichiers inutiles & de développement
rm -rf .git
rm README.md
rm newinte.sh
rm deploy.sh

echo '## LET’S WORK, BABY !'