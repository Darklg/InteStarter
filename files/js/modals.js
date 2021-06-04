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
        modal_open($modal);
    });

    /* Close modal */
    $jQbody.on('click', '.modal-overlay,.modal-close', function(e) {
        e.preventDefault();
        modal_close();
    });

    /* Next modal */
    $jQbody.on('click', '.modal-next', function(e) {
        e.preventDefault();
        modal_goto('next');
    });

    /* Prev modal */
    $jQbody.on('click', '.modal-prev', function(e) {
        e.preventDefault();
        modal_goto('prev');
    });

    /* Keyboard events */
    jQuery(document).keyup(function(e) {
        if (e.key === "Escape") {
            modal_close();
        }
        if (e.key == 'ArrowLeft') {
            modal_goto('prev');
        }
        if (e.key == 'ArrowRight') {
            modal_goto('next');
        }
    });

    /* Trigger modaldomready to handle an ajax refresh */
    $jQbody.trigger('modaldomready');

});

function modal_open($modal) {
    if (!$modal) {
        return;
    }
    $modal.removeAttr('data-init-modal');

    /* Open iframe */
    var $iframe = $modal.find('iframe[data-src]');
    if ($iframe.length) {
        $iframe.attr('src', $iframe.attr('data-src'));
    }

    jQuery('body').attr('data-modal-open', 1);

    /* Open modal */
    $modal.addClass('is-open');
    $modal.attr('aria-hidden', 'false');

    /* Event */
    $modal.trigger('modal-open');
}

function modal_close($modal) {
    if (!$modal) {
        $modal = jQuery('.modal-wrapper.is-open');
    }

    /* Close modal */
    $modal.removeClass('is-open');
    $modal.attr('aria-hidden', 'true');

    /* Close iframe */
    var $iframe = $modal.find('iframe');
    if ($iframe.length) {
        $iframe.attr('src', $iframe.attr('src'));
    }

    jQuery('body').attr('data-modal-open', 0);

    /* Event */
    $modal.trigger('modal-close');
}

function modal_goto(dir) {
    var $activeModal = jQuery('.modal-wrapper.is-open'),
        _group = $activeModal.attr('data-modal-group');
    if (!_group) {
        return;
    }
    var $groupModals = jQuery('.modal-wrapper[data-modal-group="' + _group + '"]'),
        $elModal = $activeModal.get(0),
        nbI = $groupModals.length - 1,
        newI = false,
        currentI = false;
    $groupModals.each(function(i) {
        if (this == $elModal) {
            currentI = i;
        }
    });

    if (dir == 'next') {
        newI = currentI + 1;
    }
    if (dir == 'prev') {
        newI = currentI - 1;
    }
    /* Handle loops */
    if (newI > nbI) {
        newI = 0;
    }
    if (newI < 0) {
        newI = nbI;
    }
    modal_close($activeModal);
    modal_open($groupModals.eq(newI));
}

jQuery('body').on('ajaxdomready', function() {

    /* Build all modals */
    jQuery('[data-build-modal]').each(function() {
        build_modal(jQuery(this));
    });

    /* Open autoloaded modals */
    jQuery('.modal-wrapper[data-init-modal="1"]').each(function() {
        modal_open(jQuery(this));
    });
});

function build_modal($item) {

    /* Create elements */
    var $wrapper = jQuery('<div aria-hidden="true" class="modal-wrapper" role="dialog" aria-modal="true" id="' + $item.attr('data-build-modal') + '"></div>');
    var $overlay = jQuery('<div class="modal-overlay"></div>');
    var $inner = jQuery('<div class="modal-inner"></div>');
    var $close = jQuery('<a href="#" class="modal-close"><span>&times;</span></a>');

    /* Set attributes */
    $item.removeAttr('data-build-modal');

    /* Transfer attributes to modal */
    var _attributes = [
        'data-init-modal',
        'data-modal-group',
    ];
    for (var i = 0, len = _attributes.length; i < len; i++) {
        if ($item.attr(_attributes[i])) {
            $wrapper.attr(_attributes[i], $item.attr(_attributes[i]));
            $item.removeAttr(_attributes[i]);
        }
    }

    /* Build modal */
    $inner.append($close);
    $inner.append($item);
    $wrapper.append($overlay);
    $wrapper.append($inner);

    /* Insert at body end */
    jQuery('body').append($wrapper);

    return $wrapper;
}
