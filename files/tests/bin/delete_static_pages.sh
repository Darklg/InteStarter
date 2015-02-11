#!/bin/bash

# Extract main files
. "$( dirname "${BASH_SOURCE[0]}" )/main_files.sh";

###################################
## Clean up
###################################

for i in $main_files; do
    rm "test-${i}.html";
done;
