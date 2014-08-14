/**
 * copy_assets.js
 * Copies images and fonts to build directory
 *
 * To run:
 * $> node etc/js/copy_assets.js
 */
'use strict';

var fs = require( 'fs' )
  , _ = require( 'underscore' );

// set up paths and config
var scriptPath = __dirname
  , config = JSON.parse(
        fs.readFileSync(
            scriptPath + '/../config.json',
            'utf8'
        ) )
  , defaults = JSON.parse(
        fs.readFileSync(
            scriptPath + '/../defaults.json',
            'utf8'
        ) )
  , settings = _.extend( defaults, config )
  , buildPath = scriptPath + '/' + settings.devPaths.buildPath
  , distPath = scriptPath + '/../../dist';



// Copy build/public/js/base.js into dist/js/mox.js

console.log( 'Copy build/public/js/base.js & base.min.js into dist/js/mox.js & mox.min.js' );

fs.createReadStream( buildPath + '/js/base.js' )
    .pipe( fs.createWriteStream( distPath + '/js/mox.js' ) );

fs.createReadStream( buildPath + '/js/base.min.js' )
    .pipe( fs.createWriteStream( distPath + '/js/mox.min.js' ) );
