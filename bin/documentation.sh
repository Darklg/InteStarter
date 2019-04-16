#!/bin/bash

DOCUMENTATION_CONTENT="${MAINDIR}README-FrontEnd.md";

touch "${DOCUMENTATION_CONTENT}";

echo "# ${project_name} - Front-End Documentation" >> "${DOCUMENTATION_CONTENT}";
echo "" >> "${DOCUMENTATION_CONTENT}";
echo "This is the Front-End documentation for the project “${project_name}.”" >> "${DOCUMENTATION_CONTENT}";
echo "" >> "${DOCUMENTATION_CONTENT}";

###################################
## Format
###################################

cat "${MAINDIR}files/doc/cssformat.md" >> "${DOCUMENTATION_CONTENT}";
echo "" >> "${DOCUMENTATION_CONTENT}";

###################################
## CSS
###################################

## CSSCommon

cat "${MAINDIR}files/doc/csscommon.md" >> "${DOCUMENTATION_CONTENT}";
echo "" >> "${DOCUMENTATION_CONTENT}";

## Integento

if [[ $is_magento_skin == 'y' ]] || [[ $is_magento2_skin == 'y' ]]; then
    cat "${MAINDIR}files/doc/integento.md" >> "${DOCUMENTATION_CONTENT}";
    echo "" >> "${DOCUMENTATION_CONTENT}";
fi;

## Compass
if [[ $use_compass == 'y' ]]; then
    cat "${MAINDIR}files/doc/compass.md" >> "${DOCUMENTATION_CONTENT}";
    echo "" >> "${DOCUMENTATION_CONTENT}";
fi;

###################################
## Grunt
###################################

## Icon Fonts
if [[ $use_compass_fonticon == 'y' ]]; then
    cat "${MAINDIR}files/doc/fonticons.md" >> "${DOCUMENTATION_CONTENT}";
    echo "" >> "${DOCUMENTATION_CONTENT}";
fi;

###################################
## Submodules
###################################

if [ -f "${MAINDIR}assets/scss/csscommon/.git" ]; then
    cat "${MAINDIR}files/doc/submodules.md" >> "${DOCUMENTATION_CONTENT}";
    echo "" >> "${DOCUMENTATION_CONTENT}";
fi;

###################################
## Variables
###################################

scss_filename=$(basename -- "${SCSSFILE}")
intestarter_sed "s~__SCSSFILE__~${scss_filename}~" "${DOCUMENTATION_CONTENT}";
