<?php

/* ----------------------------------------------------------
  PATHS
---------------------------------------------------------- */

define('ABS_PATH', dirname(__FILE__) . '/../');
define('TPL_PATH', ABS_PATH . '/inc/templates/');
define('PARTIALS_PATH', ABS_PATH . '/inc/partials/');

/* ----------------------------------------------------------
  Vars
---------------------------------------------------------- */

define('PAGE_LANG', isset($_GET['lang']) && $_GET['lang'] == 'fr' ? 'fr' : 'en');
if (!isset($base_domain)) {
    $base_domain = '';
}

if (substr($base_domain, -1) != '/') {
    $base_domain .= '/';
}

$current_url = $base_domain . (PAGE_LANG == 'fr' ? 'fr/' : '');

/* ----------------------------------------------------------
  Assets
---------------------------------------------------------- */

$version = time();
$css_file = dirname(__FILE__) . '/../assets/css/main.css';
if (file_exists($css_file)) {
    $version = filemtime($css_file);
}

/* ----------------------------------------------------------
  Content
---------------------------------------------------------- */

$page_title = 'My Website';
$page_description = 'My Description';
