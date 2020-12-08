#!/bin/bash

#################################################################
## VIEWPORT & RESPONSIVE
#################################################################

echo '## VIEWPORT & RESPONSIVE';

content_width=1000;
content_width_wide=1200;
if [[ $use_onlyassets != 'y' ]]; then
    intestarter_sed 's/width=980/width=device-width/' "${MAINDIR}inc/tpl/header/head.php";
    intestarter_sed 's/<body>/<body class="cssc-is-responsive">/' "${MAINDIR}inc/tpl/header.php";
fi;

content_vars="\$content_width_wide:${content_width_wide}px;";
intestarter_sed "s/\$vars/\$vars${content_vars}/" "${SCSSFILE}";
content_vars="\$content_width:${content_width}px;";
intestarter_sed "s/\/\/\$vars/${content_vars}/" "${SCSSFILE}";
