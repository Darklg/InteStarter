## Git Submodules

This project uses .git submodules to load and update some Sass libraries. It allows the author to update them directly from the project, or to pull any latest modification to the project.

### Ensuring submodules are correctly loaded.

After pulling or deploying the project, please use the following command to ensure submodules are loaded and set to the correct version :

`git pull && git submodule update --init --recursive`

### Deleting a submodule

Please follow the instructions available here : https://git.wiki.kernel.org/index.php/GitSubmoduleTutorial#Removal
