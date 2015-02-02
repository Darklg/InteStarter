var phantomCSS = require('../node_modules/phantomcss/phantomcss.js');

/* Init PhantomCSS */
phantomCSS.init({
    addLabelToFailedImage: false,
    comparisonResultRoot: './tests/results',
    failedComparisonsRoot: './tests/failures',
    libraryRoot: 'node_modules/phantomcss',
    screenshotRoot: './tests/screenshots',
    fileNameGetter: function(root, filename) {
        var name = root + '/' + filename;
        if (fs.isFile(name + '.png')) {
            return name + '.diff.png';
        }
        else {
            return name + '.png';
        }
    },
});

casper.test.begin("\n### PhantomCSS regression tests", function suite(test) {

    /* Start casper */
    casper.start().viewport(1280, 800);

    /* Test content */
    casper.thenOpen('test-index.html', function() {
        phantomCSS.screenshot('#header', 'index_header');
    });
});

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