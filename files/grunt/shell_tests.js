/* ----------------------------------------------------------
  Shell : Tests
---------------------------------------------------------- */

(function() {
    'use strict';
    var commands = ['. ./tests/bin/create_static_pages.sh',
        '. ./tests/bin/run_tests.sh',
        '. ./tests/bin/delete_static_pages.sh'
    ];
    mod.create_static_pages = {
        command: commands[0]
    };
    mod.delete_static_pages = {
        command: commands[2]
    };
    mod.run_tests = {
        command: commands[1]
    };
    mod.full_tests = {
        command: commands.join('&&')
    };
}());

module.exports = mod;