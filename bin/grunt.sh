#!/bin/bash

#################################################################
## Utiliser Grunt
#################################################################

if [[ $use_grunt == 'y' ]]; then
    # Create package.json
    echo "{\"name\": \"${project_id}\",\"version\": \"0.0.0\",\"description\": \"\"}" > "${MAINDIR}package.json";
    # Install Grunt & default modules
    npm install --save-dev grunt;
    npm install --save-dev grunt-contrib-clean;
    npm install --save-dev grunt-shell;

    # Create Grunt File
    mv "${MAINDIR}files/Gruntfile.js" "${MAINDIR}Gruntfile.js";
fi;

cd "${MAINDIR}";