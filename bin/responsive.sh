#!/bin/bash

#################################################################
## VIEWPORT & RESPONSIVE
#################################################################

echo '## VIEWPORT & RESPONSIVE';

# Configuration du viewport
case "${is_responsive}" in
    y|Y|O|o )
        content_width=0;
        content_width_wide=1200;
        if [[ $use_onlyassets != 'y' ]]; then
            sed -i '' 's/width=980/width=device-width/' "${MAINDIR}inc/tpl/header/head.php";
            sed -i '' 's/<body>/<body class="cssc-is-responsive">/' "${MAINDIR}inc/tpl/header.php";
        fi;
    ;;
    * )
        if [[ $content_width == '' ]]; then
            content_width=980;
        fi
        content_width_wide=$(( $content_width+40 ));
        echo 'Viewport utilisé : '$content_width_wide;
        if [[ $use_onlyassets != 'y' ]]; then
            sed -i '' 's/width=980/width='$content_width_wide'/' "${MAINDIR}inc/tpl/header/head.php";
        fi;
    ;;
esac

if [[ $use_compass == 'y' ]]; then
    content_vars="\$content_width_wide: ${content_width_wide}px;\\
\$content_width: ${content_width}px;";
    sed -i '' "s/\/\/\$vars/${content_vars}/" "${MAINDIR}assets/scss/main.scss";
fi;
