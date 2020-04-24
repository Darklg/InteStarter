/* ----------------------------------------------------------
  Modules
---------------------------------------------------------- */

const gulp = require('gulp');
const sass = require('gulp-sass');
const stripCssComments = require('gulp-strip-css-comments');
const removeEmptyLines = require('gulp-remove-empty-lines');
const trimlines = require('gulp-trimlines');
const runTimestamp = Math.round(Date.now() / 1000);
const replace = require('gulp-replace');

var iconfont = require('gulp-iconfont');
var iconfontCss = require('gulp-iconfont-css');

/* ----------------------------------------------------------
  Config
---------------------------------------------------------- */

const project_name = 'PROJECTID';
const app_folder = 'assets/';
const fonts_folder = app_folder + 'fonts';
const sass_folder = app_folder + 'scss';
const sass_folder_proj = sass_folder + '/' + project_name;
const css_folder = app_folder + 'css';
const sass_files = [sass_folder + '/**.scss', sass_folder + '/*/**.scss'];
const svg_files = app_folder + 'icons/original/*.svg';
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
  Watch & Default
---------------------------------------------------------- */

exports.watch = function watch() {
    defaultTask();
    gulp.watch(svg_files, buildiconfont);
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
    if(cb){
        cb();
    }
}

exports.default = defaultTask;
