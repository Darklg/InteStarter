#!/bin/bash

#################################################################
## GESTION DU JS
#################################################################

echo '## GESTION DU JS';

# On ajoute les fichiers JS essentiels
if [[ -d "${ASSETSDIR}/js/" ]];then
    cd "${ASSETSDIR}/js/";
fi;

# On propose de télécharger une librairie JS
if [[ $is_wp_theme == 'n' && $is_magento2_skin == 'n' ]]; then
    case "${use_jquery}" in
        j|J|o|O|Y|y )
            echo '- Installation de jQuery';
            mkdir jquery;
            cd jquery;
            mkdir plugins;
            curl -o jquery.min.js https://code.jquery.com/jquery-3.5.1.min.js
            if test -f jquery.min.js; then
                if [[ $use_onlyassets != 'y' ]]; then
                    echo '<script src="assets/js/jquery/jquery.min.js?v=3.5.1"></script><script src="assets/js/app.js"></script>' >> "${MAINDIR}inc/tpl/header/head.php";
                fi;
                echo '<script src="assets/js/jquery/jquery.min.js?v=3.5.1"></script>' >> "${SRCDIR}/pug/includes/head-js.html";
                echo "jQuery(document).ready(function($) {});" > "${SRCDIR}/js/events.js";
            fi
            cd "${MAINDIR}";
        ;;
        * )
            echo '- Aucune librairie utilisée.';
            if [[ $use_onlyassets != 'y' ]]; then
                echo '<script src="assets/js/app.js"></script>' >> "${MAINDIR}inc/tpl/header/head.php";
            fi;
            echo "(function(){})();" > "${SRCDIR}/js/events.js";
        ;;
    esac
fi;

# Default JS
echo "console.log('App JS');" >> "${SRCDIR}/js/default.js";

# Load app JS in styleguide head
echo '<script src="assets/js/app.js"></script>' >> "${SRCDIR}/pug/includes/head-js.html";

# Load app JS in WordPress
if [[ $is_wp_theme == 'y' ]]; then
    PHP_APP_JS_LOADING="\$js_files['app'] = array(\n\t\t'uri' => '\/assets\/js\/app.js',\n\t\t'footer' => 1\n\t);\n\treturn \$js_files;";
    intestarter_simple_sed "return \$js_files;" "${PHP_APP_JS_LOADING}" "${MAINDIR}functions.php";
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
                cat ${directory_jsu}${css_file} >> "${SCSSDIR}/${project_id}/_plugins.scss";
            done;
        ;;
    esac

    # Delete folder
    rm -rf "${MAINDIR}JavaScriptUtilities";
fi;

###################################
## Slick Slider
###################################

if [[ "${add_slick_slider}" == 'y' ]]; then
    cd "${MAINDIR}";

    # Download Slick
    npm install slick-carousel --no-save --no-optional;

    # Copy content
    cat "node_modules/slick-carousel/slick/slick.min.js" >> "${SRCDIR}/js/slick.min.js";
    cat "node_modules/slick-carousel/slick/slick.css" >> "${SCSSDIR}/${project_id}/_plugins.scss";

    # Delete source
    rm -rf mv node_modules/slick-carousel/;
fi;

# Cut-off slider
if [[ "${add_slick_slider_cutoff}" == 'y' ]];then
    cat "${MAINDIR}files/js/slick-cutoff.js" >> "${ASSETSDIR}/js/slick-cutoff.js";
    cat "${MAINDIR}files/scss/slick-cutoff.scss" >> "${SCSSDIR}/${project_id}/_plugins.scss";
fi;
