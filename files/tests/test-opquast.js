var opquast = require('lib/opquast');

/* ----------------------------------------------------------
  Run tests
---------------------------------------------------------- */

/* Get pages */
var main_files = casper.cli.get("main_files").split(' ');
for (var i = 0, len = main_files.length; i < len; i++) {
    casper.test.begin("\n### Opquast accessibility tests on page : " + main_files[i], function suite(test) {
        /* Start casper */
        casper.start();

        /* Test page */
        casper.thenOpen('test-' + main_files[i] + '.html', function() {
            opquast.run_accessibility_first_step(test);
        });

        casper.run(function() {
            test.done();
        });
    });
}

