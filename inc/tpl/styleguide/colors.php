<?php
$colors = array();
$colors[] = array(
    'name' => 'Main',
    'value' => '#336699'
);
$colors[] = array(
    'name' => 'Secondary',
    'value' => '#6699cc'
);
?><h3>Colors</h3>
<p class="colors">
    <?php foreach($colors as $color): ?>
    <span style="display:inline-block;text-align:center;border:1px solid #f0f0f0;cursor: pointer;" title="<?php echo $color['value']; ?>" onclick="prompt('Color value','<?php echo $color['value']; ?>');">
        <span style="display:block;width:120px;height:50px;background:<?php echo $color['value']; ?>;"></span>
        <span style="display:block;font:12px/2 sans-serif;"><?php echo $color['name']; ?></span>
    </span>
    <?php endforeach; ?>
</p>