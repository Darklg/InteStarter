#!/bin/bash

#################################################################
## MAGENTO
#################################################################

echo '## MAGENTO';

MAGENTODIR="${MAINDIR}../../../../";

if [ -f "${MAGENTODIR}api.php" && $use_grunt == 'y' ]; then

    echo '- Création de templates Sass';

    # Add templates
    touch "${MAINDIR}assets/scss/${project_id}/_checkout.scss";
    mkdir "${MAINDIR}assets/scss/${project_id}/checkout";
    touch "${MAINDIR}assets/scss/${project_id}/checkout/_cart.scss";
    touch "${MAINDIR}assets/scss/${project_id}/checkout/_checkout.scss";
    touch "${MAINDIR}assets/scss/${project_id}/_catalog.scss";
    mkdir "${MAINDIR}assets/scss/${project_id}/catalog";
    touch "${MAINDIR}assets/scss/${project_id}/catalog/_filters.scss";
    touch "${MAINDIR}assets/scss/${project_id}/catalog/_grid.scss";
    touch "${MAINDIR}assets/scss/${project_id}/catalog/_item.scss";
    touch "${MAINDIR}assets/scss/${project_id}/catalog/_view.scss";
    touch "${MAINDIR}assets/scss/${project_id}/_customer.scss";
    echo "@import \"${project_id}/checkout\";
    @import \"${project_id}/checkout/cart\";
    @import \"${project_id}/checkout/checkout\";
    @import \"${project_id}/catalog\";
    @import \"${project_id}/catalog/filters\";
    @import \"${project_id}/catalog/grid\";
    @import \"${project_id}/catalog/item\";
    @import \"${project_id}/catalog/view\";
    @import \"${project_id}/customer\";" >> "${MAINDIR}assets/scss/main.scss";


    if [[ $create_utils_magento == 'y' ]]; then
        UTILSDIR="${MAGENTODIR}_utils/";
        if [ ! -d "${UTILSDIR}" ]; then
            echo '- Création du dossier _utils';
            mkdir "${UTILSDIR}";
        fi;

        echo '- Déplacement des fichiers';

        mv "${MAINDIR}config.rb" "${UTILSDIR}config.rb";
        mv "${MAINDIR}Gruntfile.js" "${UTILSDIR}Gruntfile.js";
        mv "${MAINDIR}package.json" "${UTILSDIR}package.json";
        mv "${MAINDIR}grunt/" "${UTILSDIR}grunt/";
        mv "${MAINDIR}node_modules" "${UTILSDIR}node_modules";

        echo '- Modification des chemins';

        cd "${UTILSDIR}";

        filespathconvertmage='grunt/svgmin.js grunt/webfont.js config.rb';
        for i in $filespathconvertmage
        do
            sed -i '' "s/assets\//..\/skin\/frontend\/${project_id}\/default\/assets\//g" "${i}";
        done;
    fi;

fi;
