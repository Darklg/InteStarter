
function build_password_eye($input) {
    'use strict';
    var $wrapper = document.createElement('DIV'),
        $eye = document.createElement('button');

    /* Build elements */
    $wrapper.classList.add('wrapper-password');
    $wrapper.setAttribute('data-password-type','password');
    $eye.setAttribute('type', 'button');

    /* Append elements */
    $input.insertAdjacentElement('afterend', $wrapper);
    $wrapper.appendChild($input);
    $wrapper.appendChild($eye);

    /* Create action */
    $eye.addEventListener('click', function(e) {
        e.preventDefault();
        var _mode = 'text';
        if ($input.getAttribute('type') == 'text') {
            _mode = 'password';
        }
        $input.setAttribute('type', _mode);
        $wrapper.setAttribute('data-password-type', _mode);

    }, 1);
}

document.addEventListener("DOMContentLoaded", function() {
    'use strict';
    Array.prototype.forEach.call(document.querySelectorAll('input[type="password"]'), build_password_eye);
});
