<?php
echo '<!DOCTYPE html>';
echo '<html lang="' . PAGE_LANG . '">';
echo '<head>';
echo '<title>' . $page_title . '</title>';
echo '<meta charset="utf-8"/>';
echo '<link rel="alternate" href="' . $base_domain . (PAGE_LANG == 'fr' ? '' : 'fr/') . '" hreflang="' . (PAGE_LANG == 'fr' ? 'en' : 'fr') . '" />';
echo '<meta name="viewport" content="width=device-width, initial-scale=1"/>';
echo '<link rel="stylesheet" type="text/css" href="' . $base_domain . 'assets/css/main.css?v=' . $version . '" />';
echo '<script src="' . $base_domain . 'assets/js/jquery/jquery.min.js?v=3.6.0"></script>';
echo '<meta property="og:title" content="' . $page_title . '">';
echo '<meta property="og:site_name" content="' . $page_title . '">';
echo '<meta property="og:url" content="' . $current_url . '">';
echo '<meta property="og:description" content="' . $page_description . '">';
echo '<meta property="og:type" content="website">';
echo '</head>';
echo '<body>';
