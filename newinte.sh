#!/bin/bash

# On clone le repository
echo '# RECUPERATION DE INTESTARTER'
git clone git@github.com:Darklg/InteStarter.git

# On renomme le dossier créé et on s'y déplace
mv InteStarter inte
cd inte/

# On essaie de télécharger une librairie JS
cd js/
read -p "# - Utiliser Mootools ou jQuery (m/j)? " choice
case "$choice" in 
    m|M )
        echo '# GO MOOTOOLS'
        curl -O http://ajax.googleapis.com/ajax/libs/mootools/1.4/mootools-yui-compressed.js
        if test -f mootools-yui-compressed.js; then
            echo '<script src="js/mootools-yui-compressed.js"></script>' >> ../inc/tpl/header/head.php
        fi
    ;;
    j|J ) 
        echo '# OK POUR JQUERY'
        curl -O http://code.jquery.com/jquery.min.js
        if test -f jquery.min.js; then
            echo '<script src="js/jquery.min.js"></script>' >> ../inc/tpl/header/head.php
        fi
    ;;
    * ) echo "# OK, PAS DE LIBRAIRIE JS";;
esac
cd ..

# On recupere html5shim
echo '# RECUPERATION DE HTML5SHIM'
cd js/
curl -O http://html5shim.googlecode.com/svn/trunk/html5.js
cd ..
if test -f js/html5.js; then
    echo '<!--[if lt IE 9]><script src="js/html5.js"></script><![endif]-->' >> inc/tpl/header/head.php
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
    echo '<!--[if lt IE 9]><script src="js/selectivizr-min.js"></script><![endif]-->' >> inc/tpl/header/head.php
fi
rm -rf selectivizr/

# On y clone CSSNormalize
echo '# RECUPERATION DE CSSNORMALIZE'
git clone git@github.com:Darklg/CSSNormalize.git

# On installe les feuilles de style
cp CSSNormalize/css/reset.css css/reset.css
cp CSSNormalize/css/normalize.css css/normalize.css
cp CSSNormalize/css/normalize-common.css css/normalize-common.css
cp CSSNormalize/css/normalize-base.css css/normalize-base.css

echo "
@import 'reset.css';
@import 'normalize.css';
@import 'normalize-common.css';
@import 'normalize-base.css';" >> css/zz-all.css

# Installation de feuilles CSS au choix
css_sheets="forms buttons grid tables messages code gallery push modeles layouts tabs"
for i in $css_sheets
do
    read -p "# - Installer le module CSS "$i" (y/n)? " choice
    case "$choice" in 
        y|O )
            echo '# Installation de '$i
            cp CSSNormalize/css/normalize-$i.css css/normalize-$i.css
            echo "@import 'normalize-"$i".css';" >> css/zz-all.css
        ;;
        * );;
    esac
done

echo '# MENAGE'
# On supprime CSSNormalize
rm -rf CSSNormalize

# Suppression des fichiers inutiles & de développement
rm -rf .git
rm README.md
rm newinte.sh

echo '# LETS WORK, BABY !'