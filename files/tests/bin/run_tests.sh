#!/bin/bash

###################################
## Run PhantomCSS Tests
###################################

casperjs test tests/test-*.js --web-security=no --main_files="${main_files}"

