#!/bin/bash

#################################################################
## STATIC WEBSITE
#################################################################

echo '## STATIC WEBSITE';

# Copy main file
mv "${MAINDIR}files/static/index.php" "${MAINDIR}index.php";

# Copy folder
mv "${MAINDIR}files/static/inc" "${SCSSDIR}/${project_id}/inc"
