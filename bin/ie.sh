#!/bin/bash

#################################################################
## COMPATIBILITE IE
#################################################################

echo '## COMPATIBILITE IE';

# On recupere html5shim & selectivizr
echo '- Mise en place de html5shim & selectivizr';
cp "${MAINDIR}files/ie/html5.js" "${MAINDIR}assets/js/ie/html5.js";
cp "${MAINDIR}files/ie/selectivizr-min.js" "${MAINDIR}assets/js/ie/selectivizr-min.js";
if [[ $use_onlyassets != 'y' ]]; then
    echo '<!--[if lt IE 9]><script src="assets/js/ie/html5.js"></script><script src="assets/js/ie/selectivizr-min.js"></script><![endif]-->' >> "${MAINDIR}inc/tpl/header/head.php";
fi;

# Classes HTML
echo '- Ajout de classes de compatibilité sur la balise HTML';
html_before='<html lang="fr-FR">';
html_after='<!--[if lt IE 9 ]><html lang="fr-FR" class="is_ie8 lt_ie9 lt_ie10"><![endif]-->\\
<!--[if IE 9 ]><html lang="fr-FR" class="is_ie9 lt_ie10"><![endif]-->\\
<!--[if gt IE 9]><html lang="fr-FR" class="is_ie10"><![endif]-->\\
<!--[if !IE]><!--><html lang="fr-FR"><!--<![endif]-->';
sed -i '' "s/${html_before}/${html_after}/" "${MAINDIR}inc/tpl/header.php";