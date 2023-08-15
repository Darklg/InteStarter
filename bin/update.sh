#!/bin/bash

echo '## UPDATE';

###################################
## JS Hint
###################################

if [[ ! -f "${MAINDIR}.jshintrc" ]];then
    echo '- Add missing jshintrc';
    mv "${MAINDIR}files/base.jshintrc" "${MAINDIR}.jshintrc";
fi;
