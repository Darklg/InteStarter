(function() {
    var set_scrollbar_width = function() {
        document.documentElement.style.setProperty('--scrollbar-width', (window.innerWidth - document.documentElement.clientWidth) + "px");
    };
    window.addEventListener('resize', set_scrollbar_width);
    window.addEventListener('DOMContentLoaded', set_scrollbar_width);
    set_scrollbar_width();
}());
