#!/bin/bash

main_files="index";

###################################
## Generate static files
###################################

for i in $main_files
do
    php "${i}.php" > "test-${i}.html";
done;

###################################
## Run PhantomCSS Tests
###################################

casperjs test tests/tests.js

###################################
## Clean up
###################################

for i in $main_files
do
    rm "test-${i}.html";
done;
