#!/bin/bash

#################################################################
## VIEWPORT & RESPONSIVE
#################################################################

echo '## VIEWPORT & RESPONSIVE';

content_width=1000;
content_width_wide=1200;

content_vars="\$content_width_wide:${content_width_wide}px;";
intestarter_sed "s/\$vars/\$vars${content_vars}/" "${SCSSFILE}";
content_vars="\$content_width:${content_width}px;";
intestarter_sed "s/\/\/\$vars/${content_vars}/" "${SCSSFILE}";
