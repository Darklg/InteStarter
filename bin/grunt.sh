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
    npm install --save-dev grunt-uncss;

    # Create Grunt Files
    mkdir "${MAINDIR}grunt";
    mv "${MAINDIR}files/Gruntfile.js" "${MAINDIR}Gruntfile.js";
    mv "${MAINDIR}files/grunt/clean.js" "${MAINDIR}grunt/clean.js";
    mv "${MAINDIR}files/grunt/uncss.js" "${MAINDIR}grunt/uncss.js";
    mv "${MAINDIR}files/grunt/aliases.yaml" "${MAINDIR}grunt/aliases.yaml";

    if [[ $use_compass_fonticon == 'y' ]];then

        # Install fonticons modules
        npm install --save-dev grunt-svgmin;
        npm install --save-dev grunt-webfont;
        npm install --save-dev grunt-contrib-compass;

        # Copy Grunt utilities
        mv "${MAINDIR}files/grunt/compass.js" "${MAINDIR}grunt/compass.js";
        mv "${MAINDIR}files/grunt/svgmin.js" "${MAINDIR}grunt/svgmin.js";
        mv "${MAINDIR}files/grunt/webfont.js" "${MAINDIR}grunt/webfont.js";

        sed -i '' "s/PROJECTID/${project_id}/g" "${MAINDIR}grunt/webfont.js";

        # Add build command
        echo "
build:
- 'svgmin'
- 'webfont'
- 'compass'
- 'clean'" >> "${MAINDIR}grunt/aliases.yaml";
    fi;

fi;

cd "${MAINDIR}";