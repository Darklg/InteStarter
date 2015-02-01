#!/bin/bash

###################################
## Clean up
###################################

for i in $main_files; do
    rm "test-${i}.html";
done;
