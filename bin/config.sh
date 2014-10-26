#!/bin/bash

#################################################################
## CONFIGURATION INITIALE
#################################################################

echo '## CONFIGURATION INITIALE';

# Choix du dossier
read -p "- Utiliser un sous-dossier (y/n) ? " use_subfolder
case "$use_subfolder" in
    y|Y|O|o )
        # On renomme le dossier créé et on s'y déplace
        mv InteStarter inte
        cd inte/
        MAINDIR=${PWD}"/";
    ;;
    * )
        # On récupère le contenu du dossier créé
        mv $MAINDIR"InteStarter/"* $MAINDIR
        rm -rf $MAINDIR"InteStarter/"
    ;;
esac

# On recupere le nom du projet
read -p "- Comment s'appelle ce projet ? (Front-End) " project_name
if [[ $project_name == '' ]]; then
    project_name='Front-End';
fi;
echo "define('PROJECT_NAME','"${project_name/\'/’}"');" >> $MAINDIR"inc/config.php";

# On recupere l'ID du projet
read -p "- Quel est l'ID de ce projet ? (default) " project_id
if [[ $project_id == '' ]]; then
    project_id='default';
fi;
echo "define('PROJECT_ID','"${project_id/\'/’}"');" >> $MAINDIR"inc/config.php";

# On recupere l'URL du projet
read -p "- Quelle est l'URL du projet ? " project_url
echo "define('PROJECT_URL','"${project_url/\'/’}"');" >> $MAINDIR"inc/config.php";

# On recupere la description du projet
read -p "- Quel est la description rapide du projet ? " project_description
echo "define('PROJECT_DESCRIPTION','"${project_description/\'/’}"');" >> $MAINDIR"inc/config.php";

cd $MAINDIR;