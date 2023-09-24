/* ----------------------------------------------------------
  Local storage
---------------------------------------------------------- */

document.addEventListener("DOMContentLoaded", function() {
    'use strict';
    Array.prototype.forEach.call(document.querySelectorAll('[data-jsu-local-storage]'), function(el) {
        var el_key = 'data_jsu_' + el.getAttribute('name');

        /* Initial value */
        var initial_value = localStorage.getItem(el_key);
        if(initial_value){
            el.value = initial_value;
        }

        /* Watch changes */
        el.addEventListener('change', function() {
            localStorage.setItem(el_key, el.value);
        });
    });
});
