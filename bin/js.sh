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
        mkdir mootools;
        cd mootools;
        mkdir classes;
        curl -O http://ajax.googleapis.com/ajax/libs/mootools/1.4/mootools-yui-compressed.js;
        if test -f mootools-yui-compressed.js; then
            if [[ $use_onlyassets != 'y' ]]; then
                echo '<script src="assets/js/mootools/mootools-yui-compressed.js"></script><script src="assets/js/events.js"></script>' >> "${MAINDIR}inc/tpl/header/head.php";
            fi;
            echo "window.addEvent('domready',function(){});" > "${MAINDIR}assets/js/events.js";
        fi
        cd "${MAINDIR}";
    ;;
    j|J )
        echo '- Installation de jQuery';
        mkdir jquery;
        cd jquery;
        mkdir plugins;
        curl -O http://code.jquery.com/jquery.min.js;
        if test -f jquery.min.js; then
            if [[ $use_onlyassets != 'y' ]]; then
                echo '<script src="assets/js/jquery/jquery.min.js"></script><script src="assets/js/events.js"></script>' >> "${MAINDIR}inc/tpl/header/head.php";
            fi;
            echo "jQuery(document).ready(function($) {});" > "${MAINDIR}assets/js/events.js";
        fi
        cd "${MAINDIR}";
    ;;
    * )
        echo '- Aucune librairie utilisée.';
        if [[ $use_onlyassets != 'y' ]]; then
            echo '<script src="assets/js/events.js"></script>' >> "${MAINDIR}inc/tpl/header/head.php";
        fi;
        echo "(function(){})();" > "${MAINDIR}assets/js/events.js";
    ;;
esac

cd "${MAINDIR}";