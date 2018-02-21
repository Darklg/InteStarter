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
    slug="$({
        tr '[A-Z]' '[a-z]' | tr -cs '[[:alnum:]]' '-'
    } <<< "$title")";
    slug="${slug##-}";
    slug="${slug%%-}";
    slug="${slug:0:$max_length}";
    echo "${slug}";
}

## Multi-platform sed
function intestarter_sed(){
    sed -i.bak ${1} ${2};
    rm "${2}.bak";
}
