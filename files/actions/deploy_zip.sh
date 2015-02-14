#!/bin/bash

prod_folder='prod';

# Zip folder
zip -r "export-"$(date +"%Y-%m-%d")".zip" "${prod_folder}";
# Delete prod folder
rm -rf ${prod_folder}
# Open current folder
open .