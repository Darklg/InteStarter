#!/bin/bash

#################################################################
## VIEWPORT & RESPONSIVE
#################################################################

echo '## VIEWPORT & RESPONSIVE';

content_width=0;
content_width_wide=1200;
if [[ $use_onlyassets != 'y' ]]; then
    sed -i '' 's/width=980/width=device-width/' "${MAINDIR}inc/tpl/header/head.php";
    sed -i '' 's/<body>/<body class="cssc-is-responsive">/' "${MAINDIR}inc/tpl/header.php";
fi;

if [[ $use_compass == 'y' ]]; then
    content_vars="\$content_width_wide: ${content_width_wide}px;\\
\$content_width: ${content_width}px;";
    sed -i '' "s/\/\/\$vars/${content_vars}/" "${MAINDIR}assets/scss/main.scss";
fi;
