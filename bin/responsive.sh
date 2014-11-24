#!/bin/bash

#################################################################
## VIEWPORT & RESPONSIVE
#################################################################

echo '## VIEWPORT & RESPONSIVE';

# Configuration du viewport
case "${is_responsive}" in
    y|Y|O|o )
        if [[ $use_onlyassets != 'y' ]]; then
            sed -i '' 's/width=980/width=device-width/' "${MAINDIR}inc/tpl/header/head.php";
            sed -i '' 's/<body>/<body class="cssc-is-responsive">/' "${MAINDIR}inc/tpl/header.php";
        fi;
    ;;
    * )
        if [[ $content_width == '' ]]; then
            content_width=980
        fi
        content_width_wide=$(( $content_width+40 ));
        echo 'Viewport utilisé : '$content_width_wide;
        if [[ $use_onlyassets != 'y' ]]; then
            sed -i '' 's/width=980/width='$content_width_wide'/' "${MAINDIR}inc/tpl/header/head.php";
        fi;
        # Project file
        if [[ $use_compass == 'y' ]]; then
        echo '@charset "UTF-8";

body {
    min-width: '$content_width_wide'px;
    font: 13px/1.2 $font-main;
    color: $color-main;
}

/* ----------------------------------------------------------
  Layout
---------------------------------------------------------- */

.centered-container {
    min-width: '$content_width_wide'px;
}

.centered-container > * {
    max-width: '$content_width'px;
}
' >> "${MAINDIR}assets/scss/${project_id}/_base.scss";
        fi

    ;;
esac