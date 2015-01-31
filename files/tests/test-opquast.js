var opquast = require('lib/opquast');

/* ----------------------------------------------------------
  Run tests
---------------------------------------------------------- */

casper.test.begin("\n### Opquast accessibility tests", function suite(test) {
    /* Start casper */
    casper.start();

    /* Get pages */
    var main_files = casper.cli.get("main_files").split(' ');
    for (var i = 0, len = main_files.length; i < len; i++) {
        console.log('# TESTING PAGE "' + main_files[i] + '"');
        casper.thenOpen('test-' + main_files[i] + '.html', function() {
            /* Test page */
            opquast.run_accessibility_first_step(test);
        });
    }

    casper.run(function() {
        test.done();
    });
});

