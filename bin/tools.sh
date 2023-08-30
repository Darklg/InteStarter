#!/bin/bash

###################################
## Functions
###################################

## Questions
function intestarter_yn() {
    default_choice="[Y/n]";
    if [[ ${2} == 'n' ]]; then
        default_choice="[y/N]";
    fi;
    while true; do
        read -p "${1} ${default_choice} : " yn
        case $yn in
            [YyOo]* ) yn="y"; break;;
            [Nn]* ) yn="n"; break;;
            * ) yn=${2}; break;;
        esac
    done
    echo "${yn}";
}

## Create slug
function intestarter_slug() {
    # Thx to https://gist.github.com/saml/4674977
    title="$1";
    max_length="${2:-48}";
    slug="$(echo ${title} | iconv -f utf8 -t ascii//TRANSLIT)";
    slug="${slug/\'/}";
    slug="${slug/\`/}";
    slug="${slug/\ˊ/}";
    slug="$({
        tr '[A-Z]' '[a-z]' | tr -cs '[[:alnum:]]' '-'
    } <<< "$slug")";
    slug="${slug##-}";
    slug="${slug%%-}";
    slug="${slug:0:$max_length}";
    echo "${slug}";
}

## Multi-platform sed
function intestarter_sed(){
    sed -i.bak "${1}" "${2}";
    rm "${2}.bak";
}

## Advanced SED : "before" "after" "file";
function intestarter_simple_sed(){
    SED_LINEBREAK=$(echo -e '\n\r');
    SED_TAB=$(echo -e '    ');
    SED_REPREP=${2//\\n/\\${SED_LINEBREAK}};
    SED_REPREP=${SED_REPREP//\\t/\\${SED_TAB}};
    sed -i.bak "s/${1}/${SED_REPREP}/g" "${3}";
    rm "${3}.bak";
}

###################################
## Files
###################################

function intestarter__create_static_files(){
    if [[ ! -f "${MAINDIR}.nvmrc" ]];then
        echo '- Add .nvmrc';
        node -v > "${MAINDIR}.nvmrc";
    fi;
    if [[ ! -f "${MAINDIR}.jshintrc" ]];then
        echo "- Add .jshintrc";
        mv "${MAINDIR}files/base.jshintrc" "${MAINDIR}.jshintrc";
    fi;
    if [[ ! -f "${MAINDIR}.stylelintrc" ]];then
        echo "- Add .stylelintrc";
        mv "${MAINDIR}files/stylelint/stylelintrc.txt" "${MAINDIR}.stylelintrc";
    fi;
    if [[ ! -f "${MAINDIR}.stylelintignore" ]];then
        echo "- Add .stylelintignore";
        mv "${MAINDIR}files/stylelint/stylelintignore.txt" "${MAINDIR}.stylelintignore";
    fi;
}
