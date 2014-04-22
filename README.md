# Mishra

Mishra is a front-end project template for building applications
with Browserify and Node modules. It is an opinionated structure
that allows great flexibility and easy compilation. 

## Dependencies

The following node modules are required globally:

```bash
npm install -g bower browserify watchify less gulp path gulp-less
```

## Installation

Get the node and bower packages:

```bash
npm install
bower install
```

Run the init scripts to set up your environment:

```bash
# ./etc/bin/configure.sh <environment>
./etc/bin/configure.sh local
./etc/bin/init.sh
```

Finally, routing is handled through server rewrites and those
need to be copied to your nginx/apache config. Both nginx and
Apache are supported. The configuration is specified in
`etc/nginx.conf` or `etc/htaccess` respectively, and the `root`
should point to the `build/` directory of this application. If
you're using Apache, put the `.htaccess` file in `build/`.

## Building

To build the javascript/stylesheets for a specific module:

```bash
# ./etc/bin/build.sh <module>
./etc/bin/build.sh home
```

To build the base bundles:

```bash
./etc/bin/build.sh base
```

To compile the CSS/JS for all modules

```bash
./etc/bin/build.sh all
```

## CSS Compilation

CSS is compiled using `lessc`. All of your module stylesheets
should exist in `app/modules/<module>/styles/` and you should
`@import` all of your module stylesheets in an `index.less` within
that directory.

## Watching

`watchify` is used as the manager. Watching is done on a per
module basis and it's invoked the same way as building. This
will watch for JS changes in the specified module:

```bash
# ./etc/bin/watch.sh <module>
./etc/bin/watch.sh home
```

Currently, CSS watching isn't set up. The plan is to set up
a gulpfile for css watching that you would run separately.
