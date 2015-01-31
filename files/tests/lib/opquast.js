/**
* Name : 81 best practices Accessibility first step
* Version : 0.1
* Author : Darklg
*
* Original Checklist Author : Opquast
* Original Checklist URL : https://checklists.opquast.com/en/accessibility-first-step
* Original Checklist License : This checklist is published under the Creative Commons BY-SA license.
*/

module.exports = {
    not_empty_items: [
        'button',
        'caption',
        'h1',
        'h2',
        'h3',
        'h4',
        'h5',
        'h6',
        'legend',
        'li',
        'p',
        'title',
    ],
    unwanted_attributes: [
        'align',
        'alink',
        'background',
        'bgcolor',
        'border',
        'link',
        'text',
        'vlink',
    ],
    unwanted_elements: [
        'basefont',
        'bgsound',
        'blink',
        'center',
        'font',
        'listing',
        'marquee',
        'plaintext',
        'strike',
        'tt',
        'xmp',
    ],
    has_alt: [
        'img',
        'area',
        'applet',
        'input[type=image]',
    ],
    run_accessibility_first_step: function(test) {
        var i, len;

        test.assertExists('head title', "Use a title element as a child of the head element.");
        test.assertDoesntExist('html:not([lang])', "Use the lang attribute for the html element.");
        test.assertDoesntExist('iframe:not([title])', "Use the title attribute for every frame element.");
        test.assertDoesntExist('iframe[title=""]', "When you provide a title attribute for a frame element, do not leave it empty.");
        test.assertExists('body h1', "Use at least one h1 element as a descendant of body element.");
        test.assertDoesntExist('a[content=""]:not([id])', "When you provide an a element, do not leave it empty except if it is used as an anchor.");
        test.assertDoesntExist('input[type=image][alt=""]', "When you provide an alt attribute for an input type=image element, do not leave it empty.");
        test.assertDoesntExist('area[alt=""]', "When you provide an alt attribute for an area element, do not leave it empty.");
        test.assertDoesntExist('label:not([for])', "Use the for attribute for every label element.");
        test.assertDoesntExist('label[for=""]', "When you provide a for attribute for a label element, do not leave it empty.");
        test.assertDoesntExist('optgroup:not([label])', "Use the label attribute for every optgroup element.");
        test.assertDoesntExist('optgroup[label=""]', "When you provide a for attribute for a label element, do not leave it empty.");

        /* Test empty items */
        for (i = 0, len = this.not_empty_items.length; i < len; i++) {
            test.assertDoesntExist(this.not_empty_items[i] + '[content=""]', 'When you provide a ' + this.not_empty_items[i] + ' element, do not leave it empty.');
        }

        /* Test unwanted attributes */
        for (i = 0, len = this.unwanted_attributes.length; i < len; i++) {
            test.assertDoesntExist('[' + this.unwanted_attributes[i] + ']', 'Don\'t use an ' + this.unwanted_attributes[i] + ' attribute.');
        }

        /* Test unwanted element */
        for (i = 0, len = this.unwanted_attributes.length; i < len; i++) {
            test.assertDoesntExist('[' + this.unwanted_attributes[i] + ']', 'Don\'t use an ' + this.unwanted_attributes[i] + ' element.');
        }

        /* Test elements with alt */
        for (i = 0, len = this.has_alt.length; i < len; i++) {
            test.assertDoesntExist(this.has_alt[i] + ':not([alt])', 'Use the alt attribute for every ' + this.has_alt[i] + ' element.');
        }
    }
};