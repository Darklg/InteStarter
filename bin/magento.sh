#!/bin/bash

#################################################################
## MAGENTO
#################################################################

echo '## MAGENTO';

# Add templates
if [[ "${is_magento2_skin}" == 'y' ]]; then
    MAGENTODIR="${MAGENTODIR}../";

    echo '- Création de templates Sass';

    # HEADER
    mkdir "${SCSSDIR}/${project_id}/header";
    for _file in {"logo","cart","customer","search","navigation"}; do
      touch "${SCSSDIR}/${project_id}/header/_${_file}.scss";
      echo "@import \"${project_id}/header/${_file}\";" >> "${SCSSFILE}";
    done

    # CHECKOUT
    mkdir "${SCSSDIR}/${project_id}/checkout";
    for _file in {"cart","checkout","sidebar","success"}; do
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
    cat "${MAINDIR}files/magento/customer-loggedin.scss" >> "${SCSSDIR}/${project_id}/customer/_loggedin.scss";
    echo "@import \"${project_id}/customer/loggedin\";" >> "${SCSSFILE}";
    cat "${MAINDIR}files/magento/customer-public.scss" >> "${SCSSDIR}/${project_id}/customer/_public.scss";
    echo "@import \"${project_id}/customer/public\";" >> "${SCSSFILE}";

    # CONTENT
    mkdir "${SCSSDIR}/${project_id}/content";
    for _file in {"blocks","faq","contact"}; do
      touch "${SCSSDIR}/${project_id}/content/_${_file}.scss";
      echo "@import \"${project_id}/content/${_file}\";" >> "${SCSSFILE}";
    done
fi;

# Creating config RB
if [[ $is_magento2_skin == 'y' ]]; then
    # Root config.rb
    cat "${SCSSDIR}/integento/example-config.rb" >> "${MAGENTODIR}config.rb";
    intestarter_sed "s/Mytheme/${project_name}/g" "${MAGENTODIR}config.rb";
    intestarter_sed "s/assets\/css/web\/css/g" "${MAGENTODIR}config.rb";
    intestarter_sed "s/assets\/images/web\/images/g" "${MAGENTODIR}config.rb";
    intestarter_sed "s/assets\/js/web\/js/g" "${MAGENTODIR}config.rb";
    intestarter_sed "s/assets\/scss/styles/g" "${MAGENTODIR}config.rb";
    # Theme config.rb
    intestarter_sed "s/assets\/css/web\/css/g" "${MAINDIR}config.rb";
    intestarter_sed "s/assets\/images/web\/images/g" "${MAINDIR}config.rb";
    intestarter_sed "s/assets\/js/web\/js/g" "${MAINDIR}config.rb";
    intestarter_sed "s/assets\/scss/styles/g" "${MAINDIR}config.rb";
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
    MAGE2_DEF_HEAD_DIR="${MAINDIR}/Magento_Theme/layout/";
    MAGE2_DEF_HEAD_FILE="${MAGE2_DEF_HEAD_DIR}default_head_blocks.xml"
    if [ ! -f "${MAGE2_DEF_HEAD_FILE}" ]; then
        mkdir -p "${MAGE2_DEF_HEAD_DIR}";
        echo '- Création de default_head_blocks.xml';
        mv "${MAINDIR}files/magento/default_head_blocks.xml" "${MAGE2_DEF_HEAD_DIR}";
    fi;

fi;
