/* ----------------------------------------------------------
  Regression tests
---------------------------------------------------------- */

var regressionTests = [{
    'page': 'index',
    'tests': [{
        'selector': '#header'
    }]
}, {
    'page': 'styleguide',
    'tests': [{
        'selector': '#styleguide-forms'
    }, ]
}];

/* ----------------------------------------------------------
  Start Testing
---------------------------------------------------------- */

var phantomCSS = require('../node_modules/phantomcss/phantomcss.js'),
    intestarter = require('lib/intestarter'),
    phantomsettings = require('lib/phantomsettings');

/* Init PhantomCSS */
phantomCSS.init(phantomsettings);

/* Start casper */
casper.start().viewport(1280, 800);

for (var i = 0, len = regressionTests.length; i < len; i++) {
    (function(i) {
        /* For each page */
        casper.test.begin("\n### PhantomCSS regression on page \"" + regressionTests[i].page + "\"", function suite(test) {
            casper.thenOpen('test-' + regressionTests[i].page + '.html', function() {});
            // Default status
            casper.then(function() {
                intestarter.run_tests(regressionTests[i], 0, 0, this);
            });
            // Hover
            casper.then(function() {
                intestarter.run_tests(regressionTests[i], 1, 0, this);
            });
            // Click
            casper.then(function() {
                intestarter.run_tests(regressionTests[i], 0, 1, this);
            });
        });
    }(i));
}

/* Generate PNG Diffs */
casper
    .then(function now_check_the_screenshots() {
        phantomCSS.compareAll();
    })
    .then(function end_it() {
        casper.test.done();
    })
    .run(function() {
        phantom.exit(phantomCSS.getExitStatus());
    });