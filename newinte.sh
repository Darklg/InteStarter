#!/bin/bash

# On clone le repository
git clone git@github.com:Darklg/InteStarter.git

# On renomme le dossier créé et on s'y déplace
mv InteStarter inte
cd inte/

# Suppression des fichiers inutiles & de développement
rm -rf .git
rm README.md
rm newinte.sh
