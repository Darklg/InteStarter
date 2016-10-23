module.exports = {
    options: {
        plugins: [{
            removeViewBox: false
        }, {
            removeUselessStrokeAndFill: true
        }, {
            removeAttrs: {
                attrs: ['width', 'height']
            }
        }]
    },
    multiple: {
        files: [{
            expand: true,
            cwd: 'assets/icons/original/',
            src: ['**/*.svg'],
            dest: 'assets/icons/minified/',
        }]
    }
};
