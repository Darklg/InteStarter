#!/bin/bash

# Extract main files
. "$( dirname "${BASH_SOURCE[0]}" )/main_files.sh";

###################################
## Run PhantomCSS Tests
###################################

casperjs test tests/test-*.js --web-security=no --main_files="${main_files}"

