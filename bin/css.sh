#!/bin/bash

#################################################################
## GESTION DU CSS
#################################################################

echo '## GESTION DU CSS';

# On initialise le fichier principal
mv "${MAINDIR}files/scss/main.scss" "${SCSSFILE}";
mv "${MAINDIR}files/scss/_vars.scss" "${SCSSDIR}/_vars.scss";
mv "${MAINDIR}files/scss/_fonts.scss" "${SCSSDIR}/${project_id}/_fonts.scss";
mv "${MAINDIR}files/scss/_base.scss" "${SCSSDIR}/${project_id}/_base.scss";
touch "${SCSSDIR}/${project_id}/_plugins.scss";

if [[ "${is_wp_theme}" == 'y' ]]; then
    mv "${MAINDIR}files/scss/admin.scss" "${SCSSDIR}/admin.scss";
    intestarter_sed "s/project_id/${project_id}/" "${SCSSDIR}/admin.scss";
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
cat "${MAINDIR}files/scss/base-csscommon.scss" >> "${SCSSFILE}";

# Integento 2
if [[ $is_magento2_skin == 'y' ]]; then
    git submodule add --force https://github.com/InteGento/InteGentoStyles2.git integento
    cat "${MAINDIR}files/magento/base-integento2.scss" >> "${SCSSFILE}";
fi;

# Project file
echo "
/* ----------------------------------------------------------
  ${project_name}
---------------------------------------------------------- */
" >> "${SCSSFILE}";

# Font icon
rsync -az "${MAINDIR}files/icons/" "${SRCDIR}/icons/";

touch "${SCSSDIR}/${project_id}/_icons.scss";
echo "@import \"${project_id}/icons\";" >> "${SCSSFILE}";
# Update Scss
intestarter_sed 's/\/\/\ fonticon\ //g' "${SCSSFILE}";
# Tweak icons
cat "${MAINDIR}files/scss/base-icons.scss" >> "${SCSSDIR}/${project_id}/_base.scss";

# Project file
echo "@import \"${project_id}/fonts\";
@import \"${project_id}/plugins\";
@import \"${project_id}/common/*\";
@import \"${project_id}/base\";
@import \"${project_id}/header\";
@import \"${project_id}/footer\";
@import \"${project_id}/pages/*\";" >> "${SCSSFILE}";

# Main files
touch "${SCSSDIR}/${project_id}/_header.scss"
touch "${SCSSDIR}/${project_id}/_footer.scss"
mkdir "${SCSSDIR}/${project_id}/common"
touch "${SCSSDIR}/${project_id}/common/_content.scss"
mv "${MAINDIR}files/scss/_titles.scss" "${SCSSDIR}/common/_titles.scss";
mkdir "${SCSSDIR}/${project_id}/pages"
touch "${SCSSDIR}/${project_id}/pages/_home.scss"

## HEADER
cat "${MAINDIR}files/scss/header.scss" >> "${SCSSDIR}/${project_id}/_header.scss";

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

# On supprime CSSCommon
rm -rf "${ASSETSDIR}/CSSCommon";

cd "${MAINDIR}";
