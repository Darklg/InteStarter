#!/bin/bash

#################################################################
## MAGENTO
#################################################################

echo '## MAGENTO';

MAGENTODIR="${MAINDIR}../../../../";
if [[ "${is_magento2_skin}" == 'y' ]]; then
    MAGENTODIR="${MAGENTODIR}../";
fi;

if [[ "${use_grunt}" == 'y' ]]; then

    echo '- Création de templates Sass';

    # Add templates
    if [[ "${is_magento_skin}" == 'y' ]] || [[ "${is_magento2_skin}" == 'y' ]]; then

        # HEADER
        mkdir "${SCSSDIR}/${project_id}/header";
        touch "${SCSSDIR}/${project_id}/header/_logo.scss";
        echo "@import \"${project_id}/header/logo\";" >> "${SCSSFILE}";
        touch "${SCSSDIR}/${project_id}/header/_cart.scss";
        echo "@import \"${project_id}/header/cart\";" >> "${SCSSFILE}";
        touch "${SCSSDIR}/${project_id}/header/_customer.scss";
        echo "@import \"${project_id}/header/customer\";" >> "${SCSSFILE}";
        touch "${SCSSDIR}/${project_id}/header/_search.scss";
        echo "@import \"${project_id}/header/search\";" >> "${SCSSFILE}";
        touch "${SCSSDIR}/${project_id}/header/_navigation.scss";
        echo "@import \"${project_id}/header/navigation\";" >> "${SCSSFILE}";

        # CHECKOUT
        mkdir "${SCSSDIR}/${project_id}/checkout";
        touch "${SCSSDIR}/${project_id}/checkout/_cart.scss";
        echo "@import \"${project_id}/checkout/cart\";" >> "${SCSSFILE}";
        touch "${SCSSDIR}/${project_id}/checkout/_checkout.scss";
        cat "${MAINDIR}files/magento/checkout.scss" >> "${SCSSDIR}/${project_id}/checkout/_checkout.scss";
        echo "@import \"${project_id}/checkout/checkout\";" >> "${SCSSFILE}";
        touch "${SCSSDIR}/${project_id}/checkout/_success.scss";
        echo "@import \"${project_id}/checkout/success\";" >> "${SCSSFILE}";

        # CATALOG
        mkdir "${SCSSDIR}/${project_id}/catalog";
        touch "${SCSSDIR}/${project_id}/_catalog.scss";
        echo "@import \"${project_id}/catalog\";" >> "${SCSSFILE}";
        touch "${SCSSDIR}/${project_id}/catalog/_toolbar.scss";
        echo "@import \"${project_id}/catalog/toolbar\";" >> "${SCSSFILE}";
        touch "${SCSSDIR}/${project_id}/catalog/_filters.scss";
        echo "@import \"${project_id}/catalog/filters\";" >> "${SCSSFILE}";
        touch "${SCSSDIR}/${project_id}/catalog/_grid.scss";
        echo "@import \"${project_id}/catalog/grid\";" >> "${SCSSFILE}";
        touch "${SCSSDIR}/${project_id}/catalog/_item.scss";
        echo "@import \"${project_id}/catalog/item\";" >> "${SCSSFILE}";
        touch "${SCSSDIR}/${project_id}/catalog/_view.scss";
        echo "@import \"${project_id}/catalog/view\";" >> "${SCSSFILE}";

        # CUSTOMER
        mkdir "${SCSSDIR}/${project_id}/customer";
        touch "${SCSSDIR}/${project_id}/_customer.scss";
        echo "@import \"${project_id}/customer\";" >> "${SCSSFILE}";
        touch "${SCSSDIR}/${project_id}/customer/_public.scss";
        echo "@import \"${project_id}/customer/public\";" >> "${SCSSFILE}";
        touch "${SCSSDIR}/${project_id}/customer/_loggedin.scss";
        echo "@import \"${project_id}/customer/loggedin\";" >> "${SCSSFILE}";

    fi;

    # Creating config RB
    if [[ $is_magento2_skin == 'y' ]]; then
        cat "${SCSSDIR}/integento/example-config.rb" >> "${MAGENTODIR}config.rb";
        intestarter_sed "s/Mytheme/${project_name}/g" "${MAGENTODIR}config.rb";
    fi;

    # Changing path for Magento 2
    if [[ $is_magento2_skin == 'y' ]]; then
        intestarter_sed "s/assets\///g" "${MAINDIR}grunt/svgmin.js";
        intestarter_sed "s/assets\///g" "${MAINDIR}grunt/string-replace.js";
        intestarter_sed "s/assets\///g" "${MAINDIR}grunt/webfont.js";
        intestarter_sed "s/scss\//styles\//g" "${MAINDIR}grunt/webfont.js";
    fi;

    # Utils
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
            intestarter_sed "s/assets\//..\/skin\/frontend\/${project_id}\/default\/assets\//g" "${i}";
        done;
    fi;

fi;
