/* ----------------------------------------------------------
  Modules
---------------------------------------------------------- */

const gulp = require('gulp');
const sass = require('gulp-sass');
const gulpFilelist = require('gulp-filelist');
const stripCssComments = require('gulp-strip-css-comments');
const removeEmptyLines = require('gulp-remove-empty-lines');
const trimlines = require('gulp-trimlines');
const runTimestamp = Math.round(Date.now() / 1000);
const replace = require('gulp-replace');
const pug = require('gulp-pug');
const iconfont = require('gulp-iconfont');
const iconfontCss = require('gulp-iconfont-css');
const {
    series
} = require('gulp');

/* ----------------------------------------------------------
  Config
---------------------------------------------------------- */

const project_name = 'PROJECTID';
const app_folder = 'assets/';
const fonts_folder = app_folder + 'fonts';
const sass_folder = app_folder + 'scss';
const sass_folder_proj = sass_folder + '/' + project_name;
const css_folder = app_folder + 'css';
const sass_files = [sass_folder + '/**.scss', sass_folder + '/**/**.scss'];
const svg_files = app_folder + 'icons/original/*.svg';
const pug_views = 'gulp/views/';
const pug_files = [pug_views + '**.pug', pug_views + '*/**.pug'];
const fontName = 'icons';

/* ----------------------------------------------------------
  Font-Icon
---------------------------------------------------------- */

function buildiconfont() {
    return gulp.src([svg_files])
        .pipe(iconfontCss({
            cssClass: 'icon',
            fontName: fontName,
            targetPath: '../../../' + sass_folder_proj + '/_icons.scss',
            path: 'css',
            timestamp: runTimestamp,
            fontPath: '../../assets/fonts/' + fontName + '/'
        }))
        .pipe(iconfont({
            normalize: true,
            fontName: fontName,
            fontHeight: 1001,
            formats: ['ttf', 'eot', 'woff', 'woff2'],
        }))
        .pipe(gulp.dest(fonts_folder + '/' + fontName + '/'))
        .on("finish", function() {
            return gulp.src(sass_folder_proj + '/_icons.scss', {
                    base: "./"
                })
                .pipe(replace('icon-', 'icon_'))
                .pipe(gulp.dest('./'));
        });
}

exports.iconfont = buildiconfont;

/* ----------------------------------------------------------
  Compile styles
---------------------------------------------------------- */

function style() {
    return gulp.src(sass_files)
        .pipe(sass({
            outputStyle: 'compact',
            indentType: 'space',
            indentWidth: 0
        }))
        .pipe(stripCssComments({
            whitespace: false
        }))
        .pipe(removeEmptyLines())
        .pipe(trimlines())
        .pipe(gulp.dest(css_folder, {
            sourcemaps: false
        }));
}
exports.style = style;

/* ----------------------------------------------------------
  Generate styleguide
---------------------------------------------------------- */

/* Load CSS files
-------------------------- */

function pug_list_styles() {
    function formatter(filePath) {
        return '<link rel="stylesheet" type="text/css" href="' + css_folder + '/' + filePath + '.css?v=' + runTimestamp + '" />' + '\r\n';
    }

    return gulp
        .src([css_folder + '/*.css'])
        .pipe(gulpFilelist('head-css.pug', {
            flatten: true,
            removeExtensions: true,
            destRowTemplate: formatter
        }))
        .pipe(gulp.dest(pug_views + 'includes/'));
}

/* Load icons
-------------------------- */

function pug_list_icons() {
    function formatter(filePath) {
        return '<p>' +
            '<i class="icon icon_' + filePath + '"></i> - <strong>' + filePath + '</strong><br />' +
            '<span contenteditable>&lt;i class="icon icon_' + filePath + '"&gt;&lt;/i&gt;</span>' +
            '</p>' + '\r\n';
    }
    return gulp
        .src(svg_files)
        .pipe(gulpFilelist('icons.pug', {
            flatten: true,
            removeExtensions: true,
            destRowTemplate: formatter
        }))
        .pipe(gulp.dest(pug_views + 'includes/'));
}

/* Generate styleguide
-------------------------- */

function pug_generate() {
    return gulp
        .src([pug_views + '*.pug'])
        .pipe(pug({
            doctype: 'html',
            pretty: false
        }))
        .pipe(gulp.dest('./'));
}

var pug_trigger = series(pug_list_styles, pug_list_icons, pug_generate);

exports.pug = pug_trigger;

/* ----------------------------------------------------------
  Watch
---------------------------------------------------------- */

exports.watch = function watch() {
    defaultTask();
    gulp.watch(svg_files, buildiconfont);
    gulp.watch(pug_files, pug_generate);
    gulp.watch(sass_files, style);
};

/* ----------------------------------------------------------
  Default
---------------------------------------------------------- */

function defaultTask(cb) {
    /* Build icon font */
    buildiconfont();
    /* Build style */
    style();
    /* Regenerate styleguide */
    pug_trigger();
    if (cb) {
        cb();
    }
}

exports.default = defaultTask;
