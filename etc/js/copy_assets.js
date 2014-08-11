/**
 * copy_assets.js
 * Copies images and fonts to build directory
 *
 * To run:
 * $> node etc/js/copy_assets.js
 */
'use strict';

var fs = require( 'fs' )
  , _ = require( 'underscore' )
  , mkdirp = require( 'mkdirp' )
  , ncp = require( 'ncp' ).ncp
  , async = require( 'async' )
  , colors = require( 'colors' );

// set up paths and config
var scriptPath = __dirname
  , config = JSON.parse(
        fs.readFileSync(
            scriptPath + '/../config.json',
            'utf8'
        ))
  , defaults = JSON.parse(
        fs.readFileSync(
            scriptPath + '/../defaults.json',
            'utf8'
        ))
  , settings = _.extend( defaults, config )
  , appPath = scriptPath + '/' + settings.devPaths.appPath
  , vendorPath = scriptPath + '/' + settings.devPaths.vendorPath
  , buildPath = scriptPath + '/' + settings.devPaths.buildPath
  , modules = _.keys( settings.modules );

// Create buildpath if it doesn't exist
mkdirp( buildPath + 'img' );
mkdirp( buildPath + 'fonts' );

// Remove base from list
modules.unshift( 'base' );

// Run these sequentially
async.series([
    copyVendorImages//,
    //copyModuleImages,
    //copyVendorFonts
],
function ( err, results ) {
    if ( err ) {
        console.log( err );
    }
});

// Copy images specified in the config settings. These are
// images pulled into the vendor folder.
function copyVendorImages ( callback ) {
    if ( ! settings.base.img.value.length ) {
        console.log( ('No vendor images to copy, skipping.').grey );
    }
    else {
        _.keys( settings.base.img.value ).forEach( function ( directory ) {
            if ( _.has( settings.base.img.value, directory ) ) {
                mkdirp( buildPath + 'img/' + directory, function ( err ) {
                    if ( err ) {
                        console.error( ('ERROR: ' + err).blackBG.red.bold );
                    }
                    else {
                        console.log( 'Copying vendor images from ' + directory );
                        copyAssets(
                            vendorPath + settings.base.img.value[ directory ],
                            buildPath + 'img/' + directory + '/',
                            directory );
                    }
                });
            }
        });
    }
    callback( null, 'Vendor images copied' );
}

function copyModuleImages ( callback ) {
    _.each( modules, function ( module ) {

        copyAssets( appPath + module + '/images/',
                    buildPath + 'img/',
                    module );
    } );
    callback( null, 'Base images copied' );
}

// Copy vendor-specific  images into build/public/img/[vendor] folders
function copyModuleImages ( callback ) {

    _.keys( settings.base.img.value ).forEach( function ( directory ) {

        if ( settings.base.img.value.hasOwnProperty( directory ) ) {
            mkdirp( buildPath + 'img/' + directory, function ( err ) {
                if ( err ) { console.error( err ); }
                else {
                    console.log( 'Copying ' + directory + ' assets' );
                    copyAssets( vendorPath + settings.base.img.value[directory],
                        buildPath + 'img/' + directory + '/',
                        directory
                    );
                }
            } );
        }
    } );
    callback( null, 'Vendor images copied' );
}

// Copy vendor fonts into build/public/fonts
function copyFonts ( callback ) {

    _.each( settings.base.fonts.value, function ( fontFile ) {
        // fonts all reside at top level of /fonts
        var outFile = fontFile.split( '/' ).pop( );

        // TODO: Add check to see if file exists first?
        fs.createReadStream( vendorPath + fontFile )
            .pipe( fs.createWriteStream( buildPath + 'fonts/' + outFile ) );
    } );
    callback( null, 'Fonts copied' );
}


// Copy directories, checking if files exist first
function copyAssets( readDir, writeDir, module ) {

    fs.readdir( readDir, function ( err, assets ) {
            if ( err ) {
                console.log( module + ' asset directory not found' );
            }
            else if ( assets.length > 0 ) {
                ncp( readDir, writeDir, function ( err ) {
                    if ( err ) { return console.error( err ); }
                         console.log( 'Copied ' + module + ' assets' );
                        } );
            }
            else  {
                console.log( 'no image files found in ' +
                    module + ', skipping' );
            }
    } );
}
