/* ----------------------------------------------------------
  Modules
---------------------------------------------------------- */

/* Tools */
const gulp = require('gulp');
const {series} = gulp;

/* Reload */
const bs = require('browser-sync').create();

/* ----------------------------------------------------------
  Config
---------------------------------------------------------- */

const p = require('./package.json');
const project_name = p.name;
const project_host = p.project_hostname;

/* Files & Folders
-------------------------- */

const app_folder = 'assets/';
const src_folder = 'src/';
const sass_folder = src_folder + 'scss';
const sass_folder_proj = sass_folder + '/' + project_name;
const svg_files = src_folder + 'icons/*.svg';
const js_folder = app_folder + 'js';
const css_folder = app_folder + 'css';
const sass_files = [sass_folder + '/**.scss', sass_folder + '/**/**.scss'];
const js_src_folder = src_folder + 'js';
const js_src_files = [js_src_folder + '/**.js', js_src_folder + '/**/**.js'];

/* ----------------------------------------------------------
  Font-Icon
---------------------------------------------------------- */

const fonts_folder = app_folder + 'fonts';
const fontName = 'icons';

iconfont = require("./src/gulp/intestarter_gulpfile/tasks/iconfont")(svg_files, sass_folder_proj, fonts_folder, fontName);
exports.iconfont = iconfont;

/* ----------------------------------------------------------
  Compile styles
---------------------------------------------------------- */

style = require("./src/gulp/intestarter_gulpfile/tasks/style")(sass_files, css_folder, bs);
exports.style = style;

/* ----------------------------------------------------------
  JS Minify & lint
---------------------------------------------------------- */

/* Minify
-------------------------- */

minifyjs = require("./src/gulp/intestarter_gulpfile/tasks/minifyjs")(js_src_files, js_folder);
exports.minifyjs = minifyjs;

/* Lint
-------------------------- */

lintjs = require("./src/gulp/intestarter_gulpfile/tasks/lintjs")(js_src_files);
exports.lintjs = lintjs;

/* ----------------------------------------------------------
  Generate styleguide
---------------------------------------------------------- */

const pug_views = src_folder + 'pug/';
const pug_files = [pug_views + '**.pug', pug_views + '**/**.{pug,html}'];

pug_generate = require("./src/gulp/intestarter_gulpfile/tasks/pug")(p, pug_views, pug_files, svg_files, js_folder, css_folder);
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
    gulp.watch(svg_files, series(iconfont, pug_generate));
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

const defaultTask = series(iconfont, style, lintjs, minifyjs, pug_generate);

exports.default = defaultTask;
