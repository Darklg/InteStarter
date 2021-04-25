jQuery(document).ready(function($) {
    function set_textarea_autoheight() {
        var $this = $(this);
        if ($this.outerHeight() > $this.prop('scrollHeight')) {
            $this.outerHeight(5);
        }
        $this.outerHeight($this.prop('scrollHeight'));
    }
    jQuery('body').on('keyup blur', 'textarea', set_textarea_autoheight);
    jQuery('textarea').each(set_textarea_autoheight);
});
