jQuery(document).ready(function($) {
    var $jQbody = jQuery('body');

    /* Move modal wrapper */
    jQuery('.modal-wrapper').each(function() {
        $jQbody.append(jQuery(this));
    });

    /* Open iframe on click */
    jQuery('[data-modal]').on('click', function(e) {
        e.preventDefault();
        var $this = jQuery(this),
            $modal = jQuery('#' + $this.attr('data-modal'));
        if ($modal.length) {
            var $iframe = $modal.find('iframe');
            if ($iframe) {
                $iframe.attr('src', $iframe.attr('data-src'));
            }
            $modal.addClass('is-open');
        }
    });

    /* Close iframe */
    $jQbody.on('click', '.modal-overlay,.modal-close', function(e) {
        e.preventDefault();
        jQuery(this).closest('.modal-wrapper').removeClass('is-open');
    });
    jQuery(document).keyup(function(e) {
        if (e.key === "Escape") {
            jQuery('.modal-wrapper').removeClass('is-open');
        }
    });

});
