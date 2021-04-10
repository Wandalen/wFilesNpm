( function _Npm_ss_() {

'use strict';

var isBrowser = true;

if( typeof module !== 'undefined' )
{
  isBrowser = false;

  require( 'wFiles' );

}

let _ = wTools;

//

let Parent = _.FileProvider.Partial;
let Self = function wFileProviderNpm( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

//

function init( o )
{
  var self = this;
  Parent.prototype.init.call( self,o );

  _.assert( _.definedIs( o.packageName ) );
  _.assert( _.strIs( o.packageName ) );

  return self.form()
  .ifNoErrorThen( () => self );
}

//

function form()
{
  var self = this;
  if( !self.urlProvider )
  self.urlProvider = _.FileProvider.BackUrl();

  return self.urlProvider.fileRead
  ({
    filePath : 'https://registry.npmjs.org/' + self.packageName,
    sync : 0,
  })
  .doThen( ( err, got ) =>
  {
    debugger
    self[ packageInfo ] = JSON.parse( got );
    self[ version ] = self.packageInfo[ 'dist-tags' ].latest;
    self[ latestInfo ] = self.packageInfo.versions[ self.version ];
    self[ packageArchiveUrl ] = self.latestInfo.dist.tarball;
    _.assert( _.urlIs( self.packageArchiveUrl ) )
  })
  .doThen( ( err, got ) =>
  {
    if( !self.packagePath )
    {
      var tempDir = _.pathResolve( __dirname, '../../../tmp.tmp' );
      self[ packagePath ] = _.pathJoin( tempDir, self.packageName );
    }

    var tarballName = _.pathName({ path : self.packageArchiveUrl , withExtension : 1 });
    var tarballPath = _.pathJoin( self.packagePath,tarballName );
    var extractPath = _.pathJoin( _.pathDir( tarballPath ), _.pathName( self.packageArchiveUrl ) );

    self[ versionPath ] = _.pathJoin( extractPath, 'package' );

    if( _.fileProvider.fileStat( self.versionPath  ) )
    return;

    return self.urlProvider.fileCopyToHardDrive
    ({
      url : self.packageArchiveUrl,
      filePath : tarballPath
    })
    .doThen( ( err, path ) =>
    {
      if( !err )
      self.logger.log( 'Donwloaded to -> ', path )

      var tar = require( 'tar' );

      _.fileProvider.directoryMake( extractPath );

      var extracted = tar.extract
      ({
        file : path,
        cwd : extractPath
      });

      return wConsequence.from( extracted )
      .ifNoErrorThen( () =>
      {
        self.logger.log( 'Extracted to ->', extractPath )
      })
    })
  })
}

//

function _functor( routineName, having )
{
  function read( o )
  {
    var self = this;

    if( _.strIs( o ) )
    {
      o = { filePath : o }
    }

    o.filePath = self.pathNativize( o.filePath );

    return _.fileProvider[ routineName ].call( self, o );
  }

  //

  function record( filePath, recordOptions )
  {
    var self = this;

    var pathWasString = false;

    if( _.strIs( filePath ) )
    {
      filePath = _.arrayAs(  filePath )
      pathWasString = true;
    }

    if( _.arrayLike( filePath ) )
    {
      for( var i = 0; i < filePath.length; i++ )
      {
        if( !_.pathIsAbsolute( filePath[ i ] ) )
        filePath[ i ] = _.pathJoin( recordOptions.dir, filePath[ i ] );
        filePath[ i ] = self.pathNativize( filePath[ i ] );
      }
    }

    if( pathWasString )
    filePath = filePath[ 0 ];

    return _.fileProvider[ routineName ].call( self, filePath, recordOptions );
  }

  if( having.reading )
  {
    if( !having.record )
    return read;
    else
    return record;
  }
}

//etc

function pathNativize( filePath )
{
  var self = this;

  _.assert( _.pathIsAbsolute( filePath ) );

  var common = _.pathCommon([ self.versionPath, filePath ] )

  if( common !== self.versionPath )
  return _.pathReroot( self.versionPath, filePath );

  return filePath;
}

//

var packagePath = Symbol.for( 'packagePath' );
var versionPath = Symbol.for( 'versionPath' );
var packageInfo = Symbol.for( 'packageInfo' );
var latestInfo = Symbol.for( 'latestInfo' );
var version = Symbol.for( 'version' );
var packageArchiveUrl = Symbol.for( 'packageArchiveUrl' );

// --
// relationship
// --

var Composes =
{
  packageName : null,
}

var Aggregates =
{
}

var Associates =
{
}

var Restricts =
{
  urlProvider : null,
}

var Accessors =
{
  packagePath : 'packagePath',
  versionPath : 'versionPath',
  packageInfo : 'packageInfo',
  latestInfo : 'latestInfo',
  version : 'version',
  packageArchiveUrl : 'packageArchiveUrl'
}

// --
// prototype
// --

var Proto =
{

  init : init,

  form : form,

  //etc

  pathNativize : pathNativize,

  //

  constructor : Self,
  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,
  Restricts : Restricts,

}

for( var k in Parent.prototype )
{
  var r = Parent.prototype[ k ];

  if( r.having )
  {
    var isBareReading = r.having.bare && r.having.reading;
    var isRecordReading = !r.having.bare && r.having.record;
    if( isBareReading || isRecordReading )
    {
      Proto[ k ] = _functor( k, r.having );
      Proto[ k ].defaults = {};
      Proto[ k ].defaults.__proto__ = r.defaults;
    }

  }
}

//

_.classMake
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

_.accessorReadOnly( Self.prototype, Accessors);

//

_.FileProvider.Find.mixin( Self );
_.FileProvider.Secondary.mixin( Self );
_.FileProvider.Path.mixin( Self );

//



//

_.FileProvider.Npm = Self;

if( typeof module !== 'undefined' )
{
  module[ 'exports' ] = Self;
}

  })();
