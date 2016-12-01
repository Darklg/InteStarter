module.exports = {
    inline: {
        files: {
            'assets/icons.html': 'assets/icons.html',
        },
        options: {
            replacements: [
                {
                    pattern: /\.\.\/\.\.\/fonts/ig,
                    replacement: 'fonts'
                }
            ]
        }
    }
}
