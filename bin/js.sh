#!/bin/bash

#################################################################
## GESTION DU JS
#################################################################

echo '## GESTION DU JS';

# On ajoute les fichiers JS essentiels
if [[ -d "${ASSETSDIR}/js/" ]];then
    cd "${ASSETSDIR}/js/";
fi;

# Main pug file
touch "${SRCDIR}/pug/includes/head-js.html";
touch "${SRCDIR}/pug/includes/foot-js.html";

# If jQuery is needed : download it
case "${use_jquery}" in
    j|J|o|O|Y|y )
        echo '- Installation de jQuery';
        mkdir jquery;
        cd jquery;
        curl -o jquery.min.js https://code.jquery.com/jquery-3.6.0.min.js
        if test -f jquery.min.js; then
            echo '<script src="assets/js/jquery/jquery.min.js?v=3.6.0"></script>' >> "${SRCDIR}/pug/includes/head-js.html";
        fi
        cd "${MAINDIR}";
    ;;
    * )
        echo '- Aucune librairie utilisée.';
    ;;
esac

# Default JS
cp "${MAINDIR}files/js/"*.js "${SRCDIR}/js/";

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
                echo "<script src=\"${jquery_path}${i}/${i}.min.js\"></script>" >> "${SRCDIR}/pug/includes/head-js.html";
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
    cat "${MAINDIR}files/slick/slick-cutoff.js" >> "${ASSETSDIR}/js/slick-cutoff.js";
    cat "${MAINDIR}files/slick/slick-cutoff.scss" >> "${SCSSDIR}/${project_id}/_plugins.scss";
fi;
