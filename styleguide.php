<?php
include dirname(__FILE__) . '/inc/control.php';
include TPL_DIR . 'header.php';
?>
<div class="centered-container main-container">
    <div>
        <h2><?php echo PROJECT_DESCRIPTION; ?></h2>
        <?php include TPL_DIR . 'styleguide/pages.php'; ?>
        <?php include TPL_DIR . 'styleguide/forms.php'; ?>
        <?php include TPL_DIR . 'styleguide/icons.php'; ?>
        <?php include TPL_DIR . 'styleguide/colors.php'; ?>
        <?php include TPL_DIR . 'styleguide/text.php'; ?>
    </div>
</div>
<?php
include TPL_DIR . 'footer.php';
