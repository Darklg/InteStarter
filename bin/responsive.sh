#!/bin/bash

#################################################################
## VIEWPORT & RESPONSIVE
#################################################################

echo '## VIEWPORT & RESPONSIVE';

# Configuration du viewport
case "${is_responsive}" in
    y|Y|O|o )
        sed -i '' 's/width=980/width=device-width/' "${MAINDIR}inc/tpl/header/head.php";
        sed -i '' 's/<body>/<body class="cssc-is-responsive">/' "${MAINDIR}inc/tpl/header.php";
    ;;
    * )
        read -p "- Quelle est la largeur du contenu sans marges (Default:980) ? " content_width
        if [[ $content_width == '' ]]; then
            content_width=980
        fi
        content_width_wide=$(( $content_width+40 ));
        echo 'Viewport utilisé : '$content_width_wide;
        sed -i '' 's/width=980/width='$content_width_wide'/' "${MAINDIR}inc/tpl/header/head.php";
        # Project file
        if [[ $use_compass == 'y' ]]; then
        echo '@charset "UTF-8";

body {
    width: '$content_width_wide'px;
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