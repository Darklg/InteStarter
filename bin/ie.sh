#!/bin/bash

#################################################################
## COMPATIBILITE IE
#################################################################

echo '## COMPATIBILITE IE';

cd assets/js/ie/;

# On recupere html5shim
echo '- Récupération de html5shim ( Tags HTML5 sur IE < 9 )';
curl -O http://html5shim.googlecode.com/svn/trunk/html5.js
if test -f html5.js; then
    echo '<!--[if lt IE 9]><script src="assets/js/ie/html5.js"></script><![endif]-->' >> $MAINDIR"inc/tpl/header/head.php";
fi

# On recupere selectivizr
echo '- Récupération de selectivizr ( Selecteurs avancés sur IE < 9 )';
mkdir selectivizr
cd selectivizr
curl -O http://selectivizr.com/downloads/selectivizr-1.0.2.zip
unzip selectivizr-1.0.2.zip
cd ..
if test -f selectivizr/selectivizr-min.js; then
    mv selectivizr/selectivizr-min.js selectivizr-min.js
    echo '<!--[if lt IE 9]><script src="assets/js/ie/selectivizr-min.js"></script><![endif]-->' >> $MAINDIR"inc/tpl/header/head.php";
fi
rm -rf selectivizr/

cd $MAINDIR;