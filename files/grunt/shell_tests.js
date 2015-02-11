
/* ----------------------------------------------------------
  Shell : Tests
---------------------------------------------------------- */

(function() {
    'use strict';

    var commands = ['. ./tests/bin/create_static_pages.sh',
        '. ./tests/bin/run_tests.sh',
        '. ./tests/bin/delete_static_pages.sh'
    ];
    module.exports = {
        create_static_pages: {
            command: commands[0]
        },
        delete_static_pages: {
            command: commands[2]
        },
        run_tests: {
            command: commands[1]
        },
        full_tests: {
            command: commands.join('&&')
        }
    };
}());
