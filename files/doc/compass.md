## Compass

This project uses Compass to compile and preprocess CSS Files with Sass, and to have a handy library available.
You can probably only use Sass to compile these assets if you wont use any additional Compass features.

### How to Install Compass :

If you already have ruby installed :

`gem update --system && gem install compass`

You can also go to http://compass-style.org/install/ and follow the instructions.

### How to launch compass.

In this folder, you can find the config.rb file used by this project.
In your terminal, please navigate to the folder containing the config.rb file and launch the following command :

`compass compile`

The following command will automatically regenerate your .css Files every time you update your .scss files.

`compass watch`

