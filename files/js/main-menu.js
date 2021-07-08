/* Set mobile nav toggle */
(function() {
    var $jQbody = jQuery('body');
    $jQbody.on('click', '.nav-toggle', function(e) {
        e.preventDefault();
        $jQbody.toggleClass('has--opened-main-menu');
    });
}());
