#!/bin/bash

#################################################################
## Utiliser Grunt
#################################################################

if [[ $use_grunt != 'n' ]]; then
    # Install Grunt & default modules
    npm install --silent --save-dev grunt;
    npm install --silent --save-dev load-grunt-config;
    npm install --silent --save-dev grunt-contrib-clean;
    npm install --silent --save-dev grunt-shell;

    # Create Grunt Files
    mkdir "${MAINDIR}grunt";
    mv "${MAINDIR}files/Gruntfile.js" "${MAINDIR}Gruntfile.js";
    mv "${MAINDIR}files/grunt/clean.js" "${MAINDIR}grunt/clean.js";
    mv "${MAINDIR}files/grunt/aliases.yaml" "${MAINDIR}grunt/aliases.yaml";

    # Add deploy alias
    echo "
default:
- 'clean'" > "${MAINDIR}grunt/aliases.yaml";

    if [[ $is_static == 'y' ]];then

        npm install --silent --save-dev grunt-uncss;

        echo "
default:
- 'clean'
- 'uncss'" > "${MAINDIR}grunt/aliases.yaml";

        # Set deploy
        mv "${MAINDIR}files/grunt/uncss.js" "${MAINDIR}grunt/uncss.js";
        cat "${MAINDIR}files/grunt/shell.js" >> "${MAINDIR}grunt/shell.js";

        # Install actions
        mv "${MAINDIR}files/actions" "${MAINDIR}actions";

        echo "
deploy:
- 'clean'
- 'shell:intestarter_deploy'
- 'uncss:intestarter_export'
- 'shell:intestarter_deploy_zip'" >> "${MAINDIR}grunt/aliases.yaml";

    fi;

    if [[ $use_compass_fonticon == 'y' ]];then

        # Install fonticons modules
        npm install --silent --save-dev grunt-svgmin;
        npm install --silent --save-dev grunt-webfont;
        npm install --silent --save-dev grunt-string-replace;
        npm install --silent --save-dev grunt-contrib-compass;

        # Copy Grunt utilities
        mv "${MAINDIR}files/grunt/svgmin.js" "${MAINDIR}grunt/svgmin.js";
        mv "${MAINDIR}files/grunt/webfont.js" "${MAINDIR}grunt/webfont.js";
        mv "${MAINDIR}files/grunt/string-replace.js" "${MAINDIR}grunt/string-replace.js";
        mv "${MAINDIR}files/grunt/compass.js" "${MAINDIR}grunt/compass.js";

        intestarter_sed "s/PROJECTID/${project_id}/g" "${MAINDIR}grunt/webfont.js";

        # Add build command
        echo "
build:
- 'svgmin'
- 'webfont'
- 'string-replace'
- 'compass'
- 'clean'" >> "${MAINDIR}grunt/aliases.yaml";
    fi;

    if [[ $use_regression_tests == 'y' ]];then
        # Install accessibility tester
        npm install --silent --save-dev grunt-accessibility;
        # Install HTML Tester
        npm install --silent --save-dev grunt-html;
        # Install PhantomCSS
        npm install --silent --save-dev phantomcss;
        # Install tests
        mv "${MAINDIR}files/tests" "${MAINDIR}tests";
        # Add build command
        echo "
run_tests:
- 'shell:full_tests'

run_tests_access:
- 'shell:create_static_pages'
- 'accessibility'
- 'shell:delete_static_pages'

run_tests_only_html:
- 'shell:create_static_pages'
- 'htmllint'
- 'shell:delete_static_pages'

run_tests_html:
- 'shell:create_static_pages'
- 'htmllint'
- 'accessibility'
- 'shell:run_tests'
- 'shell:delete_static_pages'
" >> "${MAINDIR}grunt/aliases.yaml";

        if [[ $is_static == 'n' ]];then
            echo "var mod = {};" >> "${MAINDIR}grunt/shell.js";
        fi;

        # Copy test files
        cat "${MAINDIR}files/grunt/shell_tests.js" >> "${MAINDIR}grunt/shell.js";
        cat "${MAINDIR}files/grunt/htmllint.js" >> "${MAINDIR}grunt/htmllint.js";
        cat "${MAINDIR}files/grunt/accessibility.js" >> "${MAINDIR}grunt/accessibility.js";
    fi;

fi;

cd "${MAINDIR}";
