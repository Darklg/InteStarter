/* ----------------------------------------------------------
  Modules
---------------------------------------------------------- */

const p = require('./package.json');

/* Tools */
const gulp = require('gulp');
const {
    series
} = require('gulp');

/* Reload */
const bs = require('browser-sync').create();

/* Sass */
const sass = require('gulp-sass');
const sassGlob = require('gulp-sass-glob');
const autoprefixer = require('gulp-autoprefixer');
const stripCssComments = require('gulp-strip-css-comments');
const removeEmptyLines = require('gulp-remove-empty-lines');
const trimlines = require('gulp-trimlines');

/* Icon font */
const runTimestamp = Math.round(Date.now() / 1000);
const replace = require('gulp-replace');
const iconfont = require('gulp-iconfont');
const iconfontCss = require('gulp-iconfont-css');
const svgmin = require('gulp-svgmin');

/* Styleguide */
const gulpFilelist = require('gulp-filelist');
const pug = require('gulp-pug');

/* JS */
const concat = require('gulp-concat');
const minify = require("gulp-minify");

/* ----------------------------------------------------------
  Config
---------------------------------------------------------- */

const project_name = p.name;
const project_host = p.project_hostname;
const app_folder = 'assets/';
const src_folder = 'src/';
const fonts_folder = app_folder + 'fonts';
const sass_folder = src_folder + 'scss';
const sass_folder_proj = sass_folder + '/' + project_name;
const css_folder = app_folder + 'css';
const sass_files = [sass_folder + '/**.scss', sass_folder + '/**/**.scss'];
const pug_views = src_folder + 'pug/';
const pug_files = [pug_views + '**.pug', pug_views + '*/**.html'];
const svg_files = src_folder + 'icons/*.svg';
const fontName = 'icons';
const js_src_folder = src_folder + 'js';
const js_folder = app_folder + 'js';
const js_src_files = [js_src_folder + '/**.js', js_src_folder + '/**/**.js'];

/* ----------------------------------------------------------
  Font-Icon
---------------------------------------------------------- */

function buildiconfont() {
    return gulp.src([svg_files])
        .pipe(svgmin())
        .pipe(iconfontCss({
            cssClass: 'icon',
            fontName: fontName,
            targetPath: '../../../' + sass_folder_proj + '/_icons.scss',
            path: 'css',
            cacheBuster: runTimestamp,
            fontPath: '../../' + fonts_folder + '/' + fontName + '/'
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
  JS Minify
---------------------------------------------------------- */

function minifyjs() {
    return gulp.src(js_src_files, {
            allowEmpty: true
        })
        .pipe(minify({
            noSource: true
        }))
        .pipe(concat('app.js', {
            newLine: ";\n"
        }))
        .pipe(replace(';;', ';'))
        .pipe(gulp.dest(js_folder));
}

exports.minifyjs = minifyjs;

/* ----------------------------------------------------------
  Compile styles
---------------------------------------------------------- */

function style() {
    return gulp.src(sass_files)
        .pipe(sassGlob())
        .pipe(sass({
            outputStyle: 'compact',
            indentType: 'space',
            indentWidth: 0
        }))
        .pipe(autoprefixer({
            cascade: false
        }))
        .pipe(stripCssComments({
            whitespace: false
        }))
        .pipe(removeEmptyLines())
        .pipe(trimlines())
        .pipe(gulp.dest(css_folder, {
            sourcemaps: false
        }))
        .pipe(bs.stream());
}
exports.style = style;

/* ----------------------------------------------------------
  Generate styleguide
---------------------------------------------------------- */

/* Load JS files
-------------------------- */

function pug_list_scripts() {
    function formatter(filePath) {
        return '<script src="' + js_folder + '/' + filePath + '.js?v=' + runTimestamp + '"></script>' + '\r\n';
    }

    return gulp
        .src([js_folder + '/*.js'])
        .pipe(gulpFilelist('foot-js.html', {
            flatten: true,
            removeExtensions: true,
            destRowTemplate: formatter
        }))
        .pipe(gulp.dest(pug_views + 'includes/'));
}

/* Load CSS files
-------------------------- */

function pug_list_styles() {
    function formatter(filePath) {
        return '<link rel="stylesheet" type="text/css" href="' + css_folder + '/' + filePath + '.css?v=' + runTimestamp + '" />' + '\r\n';
    }

    return gulp
        .src([css_folder + '/*.css'])
        .pipe(gulpFilelist('head-css.html', {
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
        .pipe(gulpFilelist('icons.html', {
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

const pug_trigger = series(pug_list_styles, pug_list_scripts, pug_list_icons, pug_generate);

exports.pug = pug_trigger;

/* ----------------------------------------------------------
  Watch
---------------------------------------------------------- */

exports.watch = function watch() {
    bs.init({
        /* 1/ Local */
        // #server: "./",
        /* 2/ Proxy */
        // #proxy: project_host,
        /* Common */
        ghostMode: false,
        notify: false,
        open: false
    });
    style();
    gulp.watch(svg_files, series(buildiconfont, pug_list_icons, pug_generate));
    gulp.watch(js_src_files, minifyjs);
    gulp.watch(pug_files, series(pug_generate, function bs_reload(done) {
        bs.reload();
        done();
    }));
    return gulp.watch(sass_files, style);
};

/* ----------------------------------------------------------
  Default
---------------------------------------------------------- */

const defaultTask = series(buildiconfont, style, minifyjs, pug_trigger);

exports.default = defaultTask;
