(function() {
    /* Scroll percent */
    function setScrollPercent() {
        /* Update max top when scrolling to account for element changing height */
        var _maxTop = document.documentElement.offsetHeight - window.innerHeight,
            _percentScroll = window.scrollY / _maxTop;
        document.documentElement.style.setProperty('--scroll-percent', _percentScroll);
    }
    window.addEventListener('scroll', setScrollPercent);
    window.addEventListener('DOMContentLoaded', setScrollPercent);
    window.addEventListener('load', setScrollPercent);
    setScrollPercent();
}());