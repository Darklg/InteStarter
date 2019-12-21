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
        for _file in {"logo","cart","customer","search","navigation"}; do
          touch "${SCSSDIR}/${project_id}/header/_${_file}.scss";
          echo "@import \"${project_id}/header/${_file}\";" >> "${SCSSFILE}";
        done

        # CHECKOUT
        mkdir "${SCSSDIR}/${project_id}/checkout";
        for _file in {"cart","checkout","success"}; do
          touch "${SCSSDIR}/${project_id}/checkout/_${_file}.scss";
          echo "@import \"${project_id}/checkout/${_file}\";" >> "${SCSSFILE}";
        done
        cat "${MAINDIR}files/magento/checkout.scss" >> "${SCSSDIR}/${project_id}/checkout/_checkout.scss";

        # CATALOG
        mkdir "${SCSSDIR}/${project_id}/catalog";
        for _file in {"toolbar","filters","grid","item","view"}; do
          touch "${SCSSDIR}/${project_id}/catalog/_${_file}.scss";
          echo "@import \"${project_id}/catalog/${_file}\";" >> "${SCSSFILE}";
        done

        # CUSTOMER
        mkdir "${SCSSDIR}/${project_id}/customer";
        for _file in {"public","loggedin"}; do
          touch "${SCSSDIR}/${project_id}/customer/_${_file}.scss";
          echo "@import \"${project_id}/customer/${_file}\";" >> "${SCSSFILE}";
        done

    fi;

    # Creating config RB
    if [[ $is_magento2_skin == 'y' ]]; then
        cat "${SCSSDIR}/integento/example-config.rb" >> "${MAGENTODIR}config.rb";
        intestarter_sed "s/Mytheme/${project_name}/g" "${MAGENTODIR}config.rb";
        intestarter_sed "s/assets\/scss/styles/g" "${MAGENTODIR}config.rb";
        intestarter_sed "s/assets\/css/web\/css/g" "${MAGENTODIR}config.rb";
        intestarter_sed "s/assets\/images/web\/images/g" "${MAGENTODIR}config.rb";
        intestarter_sed "s/assets\/js/web\/js/g" "${MAGENTODIR}config.rb";
    fi;

    # Changing path for Magento 2
    if [[ $is_magento2_skin == 'y' ]]; then
        intestarter_sed "s/assets\///g" "${MAINDIR}grunt/svgmin.js";
        intestarter_sed "s/assets\///g" "${MAINDIR}grunt/string-replace.js";
        intestarter_sed "s/assets\///g" "${MAINDIR}grunt/webfont.js";
        intestarter_sed "s/scss\//styles\//g" "${MAINDIR}grunt/webfont.js";
        intestarter_sed "s/'fonts\/icons/'web\/fonts\/icons/g" "${MAINDIR}grunt/webfont.js";
    fi;

    if [[ "${is_magento2_skin}" == 'y' ]]; then
        MAGE2_DEF_HEAD_DIR="${MAGENTODIR}/Magento_Theme/layout/";
        MAGE2_DEF_HEAD_FILE="${MAGE2_DEF_HEAD_DIR}default_head_blocks.xml"
        if [ ! -f "${MAGE2_DEF_HEAD_FILE}" ]; then
            mkdir -p "${MAGE2_DEF_HEAD_DIR}";
            echo '- Création de default_head_blocks.xml';
            mv "${MAINDIR}files/magento/default_head_blocks.xml" "${MAGE2_DEF_HEAD_DIR}";
        fi;

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
