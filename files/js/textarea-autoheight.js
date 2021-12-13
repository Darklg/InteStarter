document.addEventListener("DOMContentLoaded", function() {
    'use strict';

    function set_textarea_autoheight($item) {
        $item.setAttribute('rows', 1);
        $item.style.height = 'auto';
        $item.style.overflow = 'hidden';
        $item.style.height = $item.scrollHeight + 'px';
    }

    ['keyup', 'paste', 'blur', 'input', 'textInput'].forEach(function(ev) {
        document.body.addEventListener(ev, function(e) {
            if (e.target.tagName == 'TEXTAREA') {
                set_textarea_autoheight(e.target);
            }
        }, 1);
    });

    document.querySelectorAll("textarea").forEach(set_textarea_autoheight);
});
