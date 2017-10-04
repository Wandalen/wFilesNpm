( function _Npm_ss_() {

  'use strict';

  var isBrowser = true;

  if( typeof module !== 'undefined' )
  {
    isBrowser = false;

    require( 'wFiles' );

  }

  var _ = wTools;

  //

  var Parent = _.FileProvider.Partial;
  var Self = function wFileProviderNpm( o )
  {
    if( !( this instanceof Self ) )
    if( o instanceof Self )
    return o;
    else
    return new( _.routineJoin( Self, Self, arguments ) );
    return Self.prototype.init.apply( this,arguments );
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
      self.packageInfo = JSON.parse( got );
      self.version = self.packageInfo[ 'dist-tags' ].latest;
      self.latestInfo = self.packageInfo.versions[ self.version ];
      self.packageArchiveUrl = self.latestInfo.dist.tarball;
      _.assert( _.urlIs( self.packageArchiveUrl ) )
    })
    .doThen( ( err, got ) =>
    {
      if( !self.packagePath )
      {
        var tempDir = _.pathResolve( __dirname, '../../../tmp.tmp' );
        self.packagePath = _.pathJoin( tempDir, self.packageName );
      }

      var tarballName = _.pathName({ path : self.packageArchiveUrl, withExtension : 1 });
      var tarballPath = _.pathJoin( self.packagePath,tarballName );
      var extractPath = _.pathJoin( _.pathDir( tarballPath ), _.pathName( self.packageArchiveUrl ) );

      self.versionPath = _.pathJoin( extractPath, 'package' );

      if( _.fileProvider.fileStat( self.versionPath ) )
      return;

      return self.urlProvider.fileCopyToHardDrive
      ({
        url : self.packageArchiveUrl,
        filePath : tarballPath
      })
      .doThen( ( err, path ) =>
      {
        if( !err )
        console.log( 'Donwloaded to -> ', path )

        var tar = require( 'tar' );

        _.fileProvider.directoryMake( extractPath );

        var con = wConsequence.from( tar.extract
        ({
          file : path,
          cwd : extractPath
        }));

        con.ifNoErrorThen( () => { console.log( 'extracted to ->', extractPath ) } )
        return con;
      })
    })
  }

  //

  function _functor( routineName )
  {
    function read( o )
    {
      var self = this;

      if( _.strIs( o ) )
      {
        o = { filePath : o }
      }

      o.filePath = self.pathNativize( o.filePath );

      return _.fileProvider[ routineName ] ( o )
    }

    return read;
  }

  //

  var fileReadAct = _functor( 'fileReadAct' );

  fileReadAct.defaults = {};
  fileReadAct.defaults.__proto__ = Parent.prototype.fileReadAct.defaults;

  //

  var directoryReadAct = _functor( 'directoryReadAct' );

  directoryReadAct.defaults = {};
  directoryReadAct.defaults.__proto__ = Parent.prototype.directoryReadAct.defaults;

  //

  var fileStatAct = _functor( 'fileStatAct' );

  fileStatAct.defaults = {};
  fileStatAct.defaults.__proto__ = Parent.prototype.fileStatAct.defaults;

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

  // --
  // relationship
  // --

  var Composes =
  {
    packageName : null
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

    packagePath : null,
    versionPath : null,
    packageInfo : null,
    version : null,
    packageArchiveUrl : null
  }

  // --
  // prototype
  // --

  var Proto =
  {

    init : init,

    form : form,

    //act

    fileReadAct : fileReadAct,
    directoryReadAct : directoryReadAct,
    fileStatAct : fileStatAct,

    //etc

    pathNativize : pathNativize,

    //

    constructor : Self,
    Composes : Composes,
    Aggregates : Aggregates,
    Associates : Associates,
    Restricts : Restricts,

  }

  //

  _.classMake
  ({
    cls : Self,
    parent : Parent,
    extend : Proto,
  });

  //

  _.FileProvider.Find.mixin( Self );
  _.FileProvider.Secondary.mixin( Self );
  _.FileProvider.Path.mixin( Self );

  //

  _.FileProvider.Npm = Self;

  if( typeof module !== 'undefined' )
  {
    module[ 'exports' ] = Self;
  }

  })();
