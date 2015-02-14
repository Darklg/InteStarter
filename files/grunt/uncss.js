(function(){
    var ignore = ['.current', '.active', '.fake'];
    module.exports = {
        dist: {
            options: {
                ignore: ignore,
                stylesheets: ['/assets/css/main.css']
            },
            files: {
                'assets/css/main.tidy.css': ['*.php', 'inc/tpl/*.php', 'inc/tpl/*/*.php']
            }
        },
        intestarter_export: {
            options: {
                ignore: ignore,
                stylesheets: ['assets/css/main.css']
            },
            files: {
                'prod/assets/css/main.tidy.css': ['prod/*.html']
            }
        }
    };
}());