#!/bin/bash

#################################################################
## MAGENTO
#################################################################

echo '## MAGENTO';

MAGENTODIR="${MAINDIR}../../../../";

if [ -f "${MAGENTODIR}api.php" ]; then

    UTILSDIR="${MAGENTODIR}_utils/";

    if [ ! -d "${UTILSDIR}" ]; then
        echo '- Création du dossier _utils';
        mkdir "${UTILSDIR}";
    fi;


    echo '- Déplacement des fichiers';

    mv "${MAINDIR}Gruntfile.js" "${UTILSDIR}Gruntfile.js";
    mv "${MAINDIR}config.rb" "${UTILSDIR}config.rb";
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
