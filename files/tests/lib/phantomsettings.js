module.exports = {
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
};