/* ----------------------------------------------------------
  Local storage
---------------------------------------------------------- */

document.addEventListener("DOMContentLoaded", function() {
    'use strict';
    Array.prototype.forEach.call(document.querySelectorAll('[data-jsu-local-storage]'), function(el) {
        var el_key = 'data_jsu_' + el.getAttribute('name');

        /* Initial value */
        set_value(el, localStorage.getItem(el_key));

        /* Watch changes */
        el.addEventListener('change', function() {
            localStorage.setItem(el_key, el.value);
        });
    });

    function set_value(el, initial_value) {
        if (!initial_value) {
            return;
        }
        if (el.tagName == 'SELECT' && !option_exists(el, initial_value)) {
            return;
        }
        el.value = initial_value;
    }

    function option_exists($select, value) {
        for (var i = 0; i < $select.options.length; i++) {
            if ($select.options[i].value == value) {
                return true;
            }
        }
        return false;
    }
});
