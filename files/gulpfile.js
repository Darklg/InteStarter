/* ----------------------------------------------------------
  Modules
---------------------------------------------------------- */

const p = require('./package.json');

/* Tools */
const gulp = require('gulp');
const {series} = gulp;
const glob = require('glob');

/* Reload */
const bs = require('browser-sync').create();

/* Sass */
const sass = require('gulp-sass')(require('sass'));
const sassGlob = require('gulp-sass-glob');
const autoprefixer = require('gulp-autoprefixer');
const stripCssComments = require('gulp-strip-css-comments');
const removeEmptyLines = require('gulp-remove-empty-lines');
const trimlines = require('gulp-trimlines');
const gulpStylelint = require('gulp-stylelint');

/* Icon font */
const runTimestamp = function() {
    return Math.round(Date.now() / 1000);
};
const replace = require('gulp-replace');
const iconfont = require('gulp-iconfont');
const iconfontCss = require('gulp-iconfont-css');
const svgmin = require('gulp-svgmin');

/* Styleguide */
const pug = require('gulp-pug');

/* JS */
const concat = require('gulp-concat');
const minify = require("gulp-minify");
const jshint = require('gulp-jshint');

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
const pug_files = [pug_views + '**.pug', pug_views + '**/**.{pug,html}'];
const svg_files = src_folder + 'icons/*.svg';
const fontName = 'icons';
const js_src_folder = src_folder + 'js';
const js_folder = app_folder + 'js';
const js_src_files = [js_src_folder + '/**.js', js_src_folder + '/**/**.js'];

/* ----------------------------------------------------------
  Font-Icon
---------------------------------------------------------- */

function buildiconfont() {
    var _ts = runTimestamp();
    return gulp.src([svg_files])
        .pipe(svgmin())
        .pipe(iconfontCss({
            cssClass: 'icon',
            fontName: fontName,
            targetPath: '../../../' + sass_folder_proj + '/_icons.scss',
            path: 'css',
            cacheBuster: _ts,
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
  lint
---------------------------------------------------------- */

function lintjs() {
    return gulp.src(js_src_files)
        .pipe(jshint())
        .pipe(jshint.reporter('default'));
}

exports.lintjs = lintjs;

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
            indentType: 'space',
            indentWidth: 0
        }).on('error', sass.logError))
        .pipe(autoprefixer({
            cascade: false
        }))
        .pipe(stripCssComments({
            whitespace: false
        }))
        .pipe(removeEmptyLines())
        .pipe(trimlines())
        .pipe(replace(/( ?)([\,\:\{\}\;\>])( ?)/g, '$2'))
        .pipe(replace(';}', '}'))
        .pipe(gulp.dest(css_folder, {
            sourcemaps: false
        }))
        .pipe(bs.stream())
        .pipe(gulpStylelint({
            failAfterError: false,
            reporters: [{
                formatter: 'string',
                console: true
            }],
            debug: false
        }));
}
exports.style = style;

/* ----------------------------------------------------------
  Generate styleguide
---------------------------------------------------------- */

function pug_generate() {

    /* List icons */
    var _icons = glob.sync(svg_files).map(function(item) {
        return item.split('/').reverse()[0].replace('.svg', '');
    });

    return gulp
        .src([pug_views + '*.pug'])
        .pipe(pug({
            locals: {
                icons: _icons,
                jsFiles: glob.sync(js_folder + '/*.js'),
                cssFiles: glob.sync(css_folder + '/*.css'),
                package: p
            },
            doctype: 'html',
            pretty: false
        }))
        .pipe(gulp.dest('./'));
}

exports.pug = pug_generate;

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
        open: true
    });
    style();
    gulp.watch(svg_files, series(buildiconfont, pug_generate));
    gulp.watch(js_src_files, series(lintjs, minifyjs));
    gulp.watch(pug_files, series(pug_generate, function bs_reload(done) {
        bs.reload();
        done();
    }));
    return gulp.watch(sass_files, style);
};

/* ----------------------------------------------------------
  Default
---------------------------------------------------------- */

const defaultTask = series(buildiconfont, style, lintjs, minifyjs, pug_generate);

exports.default = defaultTask;
