#!/bin/bash

#################################################################
## GESTION DU JS
#################################################################

echo '## GESTION DU JS';

# On ajoute les fichiers JS essentiels
cd "${MAINDIR}assets/js/";

# On propose de télécharger une librairie JS
if [[ $is_wp_theme == 'n' && $is_magento_skin == 'n' ]]; then
    case "${use_jquery}" in
        j|J|o|O|Y|y )
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
fi;

###################################
## Use JSUtilities
###################################

if [[ $add_jsutilities_plugins == 'y' ]]; then
    # Clone repository
    git clone --depth=1 https://github.com/Darklg/JavaScriptUtilities.git

    # Install default plugins
    case "${use_jquery}" in
        j|J|o|O|Y|y )
            echo '- Installation de plugins jQuery';
            for i in $jquery_plugins
            do
                cp -r "${directory_jsu}${jquery_path}${i}/" "${MAINDIR}${jquery_path}${i}/";
                echo "<script src=\"${jquery_path}${i}/${i}.min.js\"></script>" >> "${MAINDIR}inc/tpl/header/head.php";
                css_file="assets/css/${i}.css";
                if [[ $use_compass == 'y' ]]; then
                    cat ${directory_jsu}${css_file} >> "${MAINDIR}assets/scss/${project_id}/_plugins.scss";
                else
                    cp "${directory_jsu}${css_file}" "${MAINDIR}${css_file}";
                    if [[ $use_onlyassets != 'y' ]]; then
                        echo "<link rel=\"stylesheet\" type=\"text/css\" href=\"${css_file}\" />" >> "${MAINDIR}inc/tpl/header/head.php";
                    fi;
                fi;
            done;
        ;;
    esac

    # Delete folder
    rm -rf "${MAINDIR}JavaScriptUtilities";
fi;

