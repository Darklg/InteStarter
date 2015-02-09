<?php

// Icons - Sprite PNG retina
$ico_img_dir = ASSETS_DIR . 'images/css-sprite/';
$ico_img = glob($ico_img_dir . '*.png');
if (!empty($ico_img)) {
    echo '<h3>Icons - Sprite PNG retina</h3>';
    echo '<p>';
    foreach ($ico_img as $img) {
        $img_id = str_replace(array(
            $ico_img_dir,
            '.png'
        ) , '', $img);
        $html = '<i class="ir icn ' . $img_id . '"></i>';
        echo '<span style="cursor:pointer;" onclick="prompt(\'HTML\',\'' . htmlentities($html) . '\');">' . $html . '</span> ';
    }
    echo '</p>';
}

// Icons - SVG / Iconfont
$ico_svg_dir = ASSETS_DIR . 'icons/original/';
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

