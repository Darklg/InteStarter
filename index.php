<?php
include dirname(__FILE__).'/inc/control.php';
include dirname(__FILE__).'/inc/tpl/header.php';
?>
<div id="main-container" class="centered-container main-container">
    <div>
        <h2>
            <?php echo PROJECT_DESCRIPTION; ?>
        </h2>
        <h3>Forms &amp; Buttons</h3>
        <form action="" method="post">
            <ul class="cssc-form cssc-form--default">
                <li class="box">
                    <label for="test_field">Test</label>
                    <input name="test_field" id="test_field" type="text" placeholder="Test" />
                </li>
                <li class="box">
                    <button class="cssc-button cssc-button--default" type="button">Button</button>
                </li>
            </ul>
        </form>
        <h3>Text</h3>
        <h4>Other cool quotes</h4>
        <p>
            A hundredth of a second here, a hundredth of a second there - even if you put them end to end, they still only add up to one, two, perhaps three seconds, snatched from eternity.
            <a href="#">Robert Doisneau.</a>
            All I know is what the words know, and dead things, and that makes a handsome little sum, with a beginning and a middle and an end, as in the well-built phrase and the long sonata of the dead.
            <strong>Samuel Beckett.</strong>
        </p>
        <p>
            And this, our life, exempt from public haunt, finds tongues in trees, books in the running brooks, sermons in stones, and good in everything.
            <a href="#">
                <strong>William Shakespeare.</strong>
            </a>
        </p>
    </div>
</div>
<?php include dirname(__FILE__).'/inc/tpl/footer.php';