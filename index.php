<?php
include dirname(__FILE__) . '/inc/control.php';
include dirname(__FILE__) . '/inc/tpl/header.php';
?>
<div id="main-container" class="centered-container main-container">
    <div>
        <h2><?php echo PROJECT_DESCRIPTION; ?></h2>
        <?php include TPL_DIR . 'styleguide/forms.php'; ?>
        <?php include TPL_DIR . 'styleguide/icons.php'; ?>
        <?php include TPL_DIR . 'styleguide/text.php'; ?>
    </div>
</div>
<?php
include dirname(__FILE__) . '/inc/tpl/footer.php';
