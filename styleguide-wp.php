<?php
/* Template Name: Styleguide */
define('ASSETS_DIR', dirname(__FILE__) . '/assets/');
define('TPL_DIR', dirname(__FILE__) . '/tpl/');
get_header();
?>
<div class="centered-container main-container">
    <div>
        <h2><?php echo get_bloginfo('name'); ?></h2>
        <?php include TPL_DIR . 'styleguide/forms.php'; ?>
        <?php include TPL_DIR . 'styleguide/icons.php'; ?>
        <?php include TPL_DIR . 'styleguide/colors.php'; ?>
        <?php include TPL_DIR . 'styleguide/text.php'; ?>
    </div>
</div>
<?php
get_footer();
