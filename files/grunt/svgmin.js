module.exports = {
    options: {
        plugins: [{
            removeViewBox: false
        }, {
            removeUselessStrokeAndFill: true
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