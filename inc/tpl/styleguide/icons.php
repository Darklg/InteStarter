<?php

// Icons - SVG / Iconfont
$ico_svg_dir = ASSETS_DIR . 'icons/';
$ico_svg = glob($ico_svg_dir . '*.svg');
if (!empty($ico_svg)) {
    echo '<h3>Icons - SVG / Iconfont</h3>';
    echo '<p>';
    foreach ($ico_svg as $svg) {
        $svg_id = str_replace(array(
            $ico_svg_dir,
            '.svg'
        ) , '', $svg);
        $html = '<i class="icon icon_' . $svg_id . '"></i>';
        echo '<span style="cursor:pointer;" onclick="prompt(\'HTML\',\'' . htmlentities($html) . '\');">' . $html . '</span> ';
    }
    echo '</p>';
}

