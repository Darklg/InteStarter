module.exports = function(grunt) {
    // Load modules
    grunt.loadNpmTasks('grunt-shell');
    grunt.loadNpmTasks('grunt-contrib-clean');

    // Project configuration.
    grunt.initConfig({
        clean: ['**/.DS_Store', '**/thumbs.db']
    });

    // Load tasks
    grunt.registerTask('default', []);
};