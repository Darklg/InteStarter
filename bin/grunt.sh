#!/bin/bash

#################################################################
## Utiliser Grunt
#################################################################

if [[ $use_grunt != 'n' ]]; then
    # Create package.json
    echo "{\"name\": \"${project_id}\",\"version\": \"0.0.0\",\"description\": \"\"}" > "${MAINDIR}package.json";

    # Install Grunt & default modules
    npm install --save-dev grunt;
    npm install --save-dev load-grunt-config;
    npm install --save-dev grunt-contrib-clean;

    # Create Grunt File
    mv "${MAINDIR}files/Gruntfile.js" "${MAINDIR}Gruntfile.js";
    mv "${MAINDIR}files/grunt" "${MAINDIR}grunt";
fi;

cd "${MAINDIR}";