#!/bin/bash

#################################################################
## GESTION DU CSS
#################################################################

echo '## GESTION DU CSS';

cd "${ASSETSDIR}/";

# On y clone CSSCommon
echo '- Recuperation de CSSCommon';
git clone --depth=1 https://github.com/Darklg/CSSCommon.git


# On installe les feuilles de style
if [[ $use_compass == 'y' ]]; then

    # On cree les répertoires contenant le Scss
    for i in $compass_folders
    do
        if ! [ -d "${i}" ]; then
          echo "- Creation de ${i}";
          mkdir "${ASSETSDIR}/${i}";
        fi;
    done;

    # On cree le fichier de config compass
    if [[ "${use_gulp}" != 'y' ]];then
        mv "${MAINDIR}files/config.rb" "${MAINDIR}config.rb";
    fi

    # On initialise le fichier principal
    mv "${MAINDIR}files/main.scss" "${SCSSFILE}";
    touch "${SCSSDIR}/${project_id}/_fonts.scss";
    touch "${SCSSDIR}/${project_id}/_plugins.scss";
    mv "${MAINDIR}files/_base.scss" "${SCSSDIR}/${project_id}/_base.scss";

    if [[ $use_onlyassets == 'n' ]]; then
        echo '<link rel="stylesheet" type="text/css" href="assets/css/main.css?v=<?php echo time(); ?>" />' >> "${MAINDIR}inc/tpl/header/head.php";
    fi;

    cd "${SCSSDIR}/";

    # CSS Common
    if [ $(git rev-parse --is-inside-work-tree) ] || [ $is_wp_theme == 'y' ] || [ $is_magento2_skin == 'y' ]; then
        echo "-- add SassCSSCommon submodule";
        git submodule add --force https://github.com/Darklg/SassCSSCommon.git csscommon;
    else
        echo "-- clone SassCSSCommon";
        git clone --depth=1 https://github.com/Darklg/SassCSSCommon.git csscommon;
        rm -rf "${SCSSDIR}/csscommon/.git";
    fi;
    cat "${MAINDIR}files/base-csscommon.scss" >> "${SCSSFILE}";

    # Integento 2
    if [[ $is_magento2_skin == 'y' ]]; then
        git submodule add --force https://github.com/InteGento/InteGentoStyles2.git integento
        cat "${MAINDIR}files/base-integento2.scss" >> "${SCSSFILE}";
    fi;

else

    for i in $csscommon_default_modules
    do
        cp "CSSCommon/css/cssc-${i}.css" "css/cssc-${i}.css";
        if [[ $use_onlyassets != 'y' ]]; then
            echo "<link rel=\"stylesheet\" type=\"text/css\" href=\"assets/css/cssc-${i}.css\" />" >> "${MAINDIR}inc/tpl/header/head.php";
        fi;
    done;

fi;

# Installation de modules CSS au choix
if [[ $use_csscommon == 'y' ]]; then
    for i in $csscommon_additional_modules
    do
        read -p "-- Installer le module CSS ${i} (y/n)? " choice
        case "$choice" in
            y|Y|O )
                echo "-- Installation de ${i}";
                cp "CSSCommon/css/cssc-${i}.css" "css/cssc-${i}.css";
                if [[ $use_onlyassets != 'y' ]]; then
                    echo "<link rel=\"stylesheet\" type=\"text/css\" href=\"assets/css/cssc-${i}.css\" />" >> "${MAINDIR}inc/tpl/header/head.php";
                fi;
            ;;
            * );;
        esac;
    done;
fi;


if [[ $use_compass == 'y' ]]; then
# Project file
echo "
/* ----------------------------------------------------------
  ${project_name}
---------------------------------------------------------- */
" >> "${SCSSFILE}";
fi;

# Font icon
if [[ $use_compass_fonticon == 'y' ]];then
    if [[ "${use_gulp}" == 'y' ]];then
        rsync -az "${MAINDIR}files/icons/" "${ASSETSDIR}/icons/";
    else
        rsync -az "${MAINDIR}files/icons/" "${ASSETSDIR}/icons/original/";
    fi
    touch "${SCSSDIR}/${project_id}/_icons.scss";
    echo "@import \"${project_id}/icons\";" >> "${SCSSFILE}";
    # Update Scss
    intestarter_sed 's/\/\/\ fonticon\ //g' "${SCSSFILE}";
    # Tweak icons
    cat "${MAINDIR}files/base-icons.scss" >> "${SCSSDIR}/${project_id}/_base.scss";
fi;

if [[ $use_compass == 'y' ]]; then
# Project file
echo "@import \"${project_id}/fonts\";
@import \"${project_id}/plugins\";
@import \"${project_id}/common/buttons\";
@import \"${project_id}/common/forms\";
@import \"${project_id}/common/content\";
@import \"${project_id}/base\";
@import \"${project_id}/header\";
@import \"${project_id}/footer\";
@import \"${project_id}/pages/home\";" >> "${SCSSFILE}";

# Main files
touch "${SCSSDIR}/${project_id}/_header.scss"
touch "${SCSSDIR}/${project_id}/_footer.scss"
mkdir "${SCSSDIR}/${project_id}/common"
touch "${SCSSDIR}/${project_id}/common/_content.scss"
mkdir "${SCSSDIR}/${project_id}/pages"
touch "${SCSSDIR}/${project_id}/pages/_home.scss"

## CONTENT
cat "${MAINDIR}files/scss/content.scss" >> "${SCSSDIR}/${project_id}/common/_content.scss";

## FORMS

### Buttons
cat "${MAINDIR}files/scss/buttons.scss" >> "${SCSSDIR}/${project_id}/common/_buttons.scss";
if [[ $is_magento2_skin == 'y' ]]; then
    cat "${MAINDIR}files/magento/buttons-magento2.scss" >> "${SCSSDIR}/${project_id}/common/_buttons.scss";
fi;

### Mixins & base
cat "${MAINDIR}files/scss/forms.scss" >> "${SCSSDIR}/${project_id}/common/_forms.scss";

### Selectors
if [[ $is_magento2_skin == 'y' ]]; then
    cat "${MAINDIR}files/magento/forms-magento2.scss" >> "${SCSSDIR}/${project_id}/common/_forms.scss";
else
    cat "${MAINDIR}files/scss/forms-selectors.scss" >> "${SCSSDIR}/${project_id}/common/_forms.scss";
fi;

# Add project ID
intestarter_sed "s/project_id/${project_id}/" "${SCSSDIR}/${project_id}/common/_buttons.scss";
intestarter_sed "s/project_id/${project_id}/" "${SCSSDIR}/${project_id}/common/_forms.scss";
intestarter_sed "s/project_id/${project_id}/" "${SCSSDIR}/${project_id}/common/_content.scss";

fi;

# On supprime CSSCommon
rm -rf "${ASSETSDIR}/CSSCommon";

cd "${MAINDIR}";
