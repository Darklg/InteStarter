/* Set mobile nav toggle */
(function() {
    'use strict';
    var $jQbody = jQuery('body');
    $jQbody.on('click', '.nav-toggle', function(e) {
        e.preventDefault();
        $jQbody.toggleClass('has--opened-main-menu');
    });
    jQuery('.header-main__menu-inner').on('click', 'a[href*="#"]', function() {
        $jQbody.removeClass('has--opened-main-menu');
    });
}());
