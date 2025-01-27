document.addEventListener("DOMContentLoaded", function() {
    'use strict';
    var lastScroll = 0,
        newDir = 'down',
        currentDir = 'down',
        posScrollChange = 0,
        offsetScrollChangeDir = 0,
        offsetScrollChangeDirUp = 100,
        offsetScrollChangeDirDown = 25;

    function scroll_events() {
        /* Get scrolltop */
        var _scrollTop = document.documentElement.scrollTop || document.body.scrollTop;

        /* Get scroll direction */
        newDir = _scrollTop > lastScroll ? 'down' : 'up';

        /* Direction has changed : wait for a scroll amount > offset */
        if (newDir != currentDir) {
            currentDir = newDir;
            posScrollChange = _scrollTop;
        }
        offsetScrollChangeDir = (newDir == 'up' ? offsetScrollChangeDirUp : offsetScrollChangeDirDown);
        if (Math.abs(posScrollChange - _scrollTop) > offsetScrollChangeDir) {
            document.body.setAttribute('data-scrolldir', newDir);
        }

        /* Prepare : Add fixed behavior & hidden status  */
        document.body.setAttribute('data-prepare-sticky-header', _scrollTop >= 150 ? '1' : '0');

        /* Before : Add animation */
        document.body.setAttribute('data-before-sticky-header', _scrollTop >= 200 ? '1' : '0');

        /* Sticky : Switch to visible status */
        document.body.setAttribute('data-has-sticky-header', _scrollTop >= 300 ? '1' : '0');

        /* Save last scroll position */
        lastScroll = _scrollTop;
    }

    window.addEventListener('scroll', scroll_events);
    scroll_events();
});
