<?php
$pages_dir = TPL_DIR . '../../';
$pages = glob($pages_dir . '*.php');
asort($pages);
if (!empty($pages)) {
    echo '<h3>Pages</h3>';
    echo '<ul>';
    foreach ($pages as $page) {
        $p = str_replace($pages_dir, '', $page);
        echo '<li><a href="' . $p . '">' . $p . '</a></li>';
    }
    echo '</ul>';
}
