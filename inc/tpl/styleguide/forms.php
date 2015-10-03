<h3>Forms &amp; Buttons</h3>
<form id="styleguide-forms" action="#" method="post">
    <ul class="cssc-form cssc-form--front-end">
        <li class="box">
            <label for="test_field">Test</label>
            <input name="test_field" id="test_field" type="text" placeholder="Test" />
        </li>
        <li class="box" id="special-form-items">
            <label for="fakeinputbox-me">
                <input id="fakeinputbox-me" class="fakeinputbox-me" type="checkbox" name="az" value="" />
                Fake Input
            </label>
            <label for="fake-select">Fake select</label>
            <select id="fake-select" name="fake-select" class="fake-select">
                <option value="" disabled selected style="display:none;">Select</option>
                <option value="0">First Value</option>
                <option value="1">Second Value</option>
            </select>
        </li>
        <li class="box">
            <button class="cssc-button cssc-button--front-end" type="submit">Button</button>
        </li>
    </ul>
</form>
