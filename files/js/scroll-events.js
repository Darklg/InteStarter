document.addEventListener("DOMContentLoaded", function(event) {
    'use strict';
    var lastScroll = 0;

    function scroll_events() {
        /* Get scrolltop */
        var _scrollTop = document.documentElement.scrollTop || document.body.scrollTop;

        /* Set scroll direction */
        document.body.setAttribute('data-scrolldir', lastScroll > _scrollTop ? 'up' : 'down');

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
