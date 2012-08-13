#!/bin/bash

# On clone le repository
git clone git@github.com:Darklg/InteStarter.git

# On renomme le dossier créé et on s'y déplace
mv InteStarter inte
cd inte/

# On y clone CSSNormalize
git clone git@github.com:Darklg/CSSNormalize.git

# On installe les feuilles de style
cp CSSNormalize/css/reset.css css/reset.css
cp CSSNormalize/css/normalize.css css/normalize.css
cp CSSNormalize/css/normalize-common.css css/normalize-common.css
cp CSSNormalize/css/normalize-base.css css/normalize-base.css

echo "
@import 'reset.css';
@import 'normalize.css';
@import 'normalize-common.css';
@import 'normalize-base.css';" >> css/zz-all.css

# On supprime CSSNormalize
rm -rf CSSNormalize

# Suppression des fichiers inutiles & de développement
rm -rf .git
rm README.md
rm newinte.sh
