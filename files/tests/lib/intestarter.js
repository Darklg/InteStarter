module.exports = {
    set_name: function(testPage, i) {
        var page = testPage['page'],
            selector = testPage['tests'][i]['selector'];
        selector = selector.toLowerCase().replace(/ /g, '-').replace(/[^\w-]+/g, '');
        return page + '__' + selector;
    },
    run_tests: function(testPage, hover, click, self) {
        var name, i, len, tmpTest, tmpSel;
        for (i = 0, len = testPage['tests'].length; i < len; i++) {
            name = this.set_name(testPage, i);
            tmpTest = testPage['tests'][i];
            tmpSel = tmpTest['selector'];

            // Set hovered block if true;
            if (hover && tmpTest.hover) {
                if (tmpTest.hover.length > 1) {
                    tmpSel = tmpTest.hover;
                }
                self.mouse.move(tmpSel);
                name += '--hover';
            }

            // Set clicked block if true;
            if (click && tmpTest.click) {
                if (tmpTest.click.length > 1) {
                    tmpSel = tmpTest.click;
                }
                self.mouse.click(tmpSel);
                name += '--click';
            }

            if ((!hover && !click) || (hover && tmpTest.hover) || (click && tmpTest.click)) {
                phantomCSS.screenshot(tmpTest['selector'], name);
            }
        }
    }
};