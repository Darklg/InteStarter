## Font Icons

Grunt is used only to generate an icon font. This icon font allows us to insert a vectorized graphic anywhere in the project, with customizations like color, shadows, size or transitions, with a good front-end performance impact.

### Install Grunt Fonticons

Go to the folder containing the package.json file, and launch the following command :

`npm install && grunt build`

### Adding a new icon to the fonticon :

Please add a SVG file in the folder icons/original/. The filename will be used as the icon name. Then launch the following command :

`grunt build`

### Checking icons

After the fonticon is generated, you can open the icon control file : `fonts/icons/icons.html`.

### Inserting an icon in the project

You can put anywhere you want the following HTML ( for an icon named test.svg ) :

`<i class="icon icon_test"></i>`

You can also insert it directly in CSS :

```
.my-selector:before {
    @extend .icon;
    @extend .icon_test;
}
 ```
