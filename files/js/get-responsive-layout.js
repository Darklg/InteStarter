/**
 * Get Responsive Layout
 */
function jsu_get_responsive_layout($el) {
    'use strict';
    $el = $el || document.body;
    var _layout = window.getComputedStyle($el, ':after').getPropertyValue('content');
    _layout = _layout.replace(/"/g, '');
    _layout = _layout || 'none';
    return _layout;
}
