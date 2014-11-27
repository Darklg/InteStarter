module.exports = {
    dist: {
        options: {
            ignore: ['.current', '.active', '.fake'],
            stylesheets: ['/assets/css/main.css']
        },
        files: {
            'assets/css/main.tidy.css': ['*.php', 'inc/tpl/*.php', 'inc/tpl/*/*.php']
        }
    }
};