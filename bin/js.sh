#!/bin/bash

#################################################################
## GESTION DU JS
#################################################################

echo '## GESTION DU JS';

# On ajoute les fichiers JS essentiels
cd assets/js/

# On propose de télécharger une librairie JS
case "${chosen_jslib}" in
    m|M )
        echo '- Installation de MooTools';
        mkdir jquery;
        cd jquery;
        mkdir classes;
        curl -O http://ajax.googleapis.com/ajax/libs/mootools/1.4/mootools-yui-compressed.js;
        if test -f mootools-yui-compressed.js; then
            echo '<script src="assets/js/mootools/mootools-yui-compressed.js"></script><script src="assets/js/events.js"></script>' >> "${MAINDIR}inc/tpl/header/head.php";
            echo "window.addEvent('domready',function(){});" > "${MAINDIR}assets/js/events.js";
        fi
    ;;
    j|J )
        echo '- Installation de jQuery';
        mkdir jquery;
        cd jquery;
        mkdir plugins;
        curl -O http://code.jquery.com/jquery.min.js;
        if test -f jquery.min.js; then
            echo '<script src="assets/js/jquery/jquery.min.js"></script><script src="assets/js/events.js"></script>' >> "${MAINDIR}inc/tpl/header/head.php";
            echo "jQuery(document).ready(function($) {});" > "${MAINDIR}assets/js/events.js";
        fi
    ;;
    * )
        echo '- Aucune librairie utilisée.';
        echo '<script src="assets/js/events.js"></script>' >> "${MAINDIR}inc/tpl/header/head.php";
        echo "(function(){})();" > "${MAINDIR}assets/js/events.js";
    ;;
esac

cd "${MAINDIR}";