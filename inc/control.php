<?php
include dirname(__FILE__) . '/config.php';

if (!defined('PROJECT_NAME')) {
    define('PROJECT_NAME', 'Inte Starter');
}

if (!defined('PROJECT_DESCRIPTION')) {
    define('PROJECT_DESCRIPTION', 'A faster start for front-end development !');
}

if (!defined('PROJECT_URL')) {
    define('PROJECT_URL', '');
}

if (!defined('TPL_DIR')) {
    define('TPL_DIR', dirname(__FILE__) . '/tpl/');
}

if (!defined('ASSETS_DIR')) {
    define('ASSETS_DIR', dirname(__FILE__) . '/../assets/');
}

/* ----------------------------------------------------------
  Current page
---------------------------------------------------------- */

$current_page = 'index';
$current_url = '';
if (isset($_SERVER['REQUEST_URI'])) {
    $current_url = $_SERVER['REQUEST_URI'];
    $pathinfo = pathinfo($current_url);
    if (isset($pathinfo['extension']) && $pathinfo['extension'] == 'php') {
        $current_page = $pathinfo['filename'];
    }
}

define('CURRENT_PAGE', $current_page);
