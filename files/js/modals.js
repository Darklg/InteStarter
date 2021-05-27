jQuery(document).ready(function($) {
    var $jQbody = jQuery('body');

    /* Move modal wrapper */
    jQuery('.modal-wrapper').each(function() {
        $jQbody.append(jQuery(this));
    });

    /* Open modal on click */
    $jQbody.on('click', '[data-modal]', function(e) {
        e.preventDefault();
        var $this = jQuery(this),
            $modal = jQuery('#' + $this.attr('data-modal'));
        if (!$modal.length) {
            return;
        }
        /* Load iframe */
        var $iframe = $modal.find('iframe[data-src]');
        if ($iframe.length) {
            $iframe.attr('src', $iframe.attr('data-src'));
        }
        /* Open modal */
        $modal.addClass('is-open');
    });

    /* Close modal */
    $jQbody.on('click', '.modal-overlay,.modal-close', function(e) {
        e.preventDefault();
        jQuery(this).closest('.modal-wrapper').removeClass('is-open');
    });

    /* Close modal on escape */
    jQuery(document).keyup(function(e) {
        if (e.key === "Escape") {
            jQuery('.modal-wrapper').removeClass('is-open');
        }
    });

    $jQbody.trigger('modaldomready');

});

jQuery('body').on('modaldomready', function() {

    /* Build all modals */
    jQuery('[data-build-modal]').each(function() {
        build_modal(jQuery(this));
    });

    /* Open autoloaded modals */
    jQuery('.modal-wrapper[data-init-modal="1"]').each(function() {
        jQuery(this)
            .addClass('is-open')
            .removeAttr('data-init-modal');
    });
});

function build_modal($item) {

    /* Create elements */
    var $wrapper = jQuery('<div class="modal-wrapper" id="' + $item.attr('data-build-modal') + '"></div>');
    var $overlay = jQuery('<div class="modal-overlay"></div>');
    var $inner = jQuery('<div class="modal-inner"></div>');
    var $close = jQuery('<a href="#" class="modal-close"><span>&times;</span></a>');

    /* Set attributes */
    $item.removeAttr('data-build-modal');
    if ($item.attr('data-init-modal') == '1') {
        $item.removeAttr('data-init-modal');
        $wrapper.attr('data-init-modal', '1');
    }

    /* Build modal */
    $inner.append($close);
    $inner.append($item);
    $wrapper.append($overlay);
    $wrapper.append($inner);

    /* Insert at body end */
    jQuery('body').append($wrapper);
}
