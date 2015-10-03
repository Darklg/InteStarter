module.exports = {
    options: {
        accessibilityLevel: 'WCAG2A',
        reportLevels: {
            notice: false,
            warning: true,
            error: true
        },
    },
    test: {
        src: ["test-*.html"]
    }
};