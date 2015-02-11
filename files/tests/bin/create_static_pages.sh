#!/bin/bash

# Extract main files
. "$( dirname "${BASH_SOURCE[0]}" )/main_files.sh";

###################################
## Generate static files
###################################

for i in $main_files; do
    php "${i}.php" > "test-${i}.html";
done;