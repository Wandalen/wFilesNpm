require( '../staging/dwtools/amid/file/fprovider/pNmp.ss' );

var _ = wTools

_.FileProvider.Npm({ packageName : 'wPath' })
.got(( err, provider ) =>
{
  if( err )
  throw err;

  // var file = provider.fileRead( 'staging/dwtools/Base.s' );
  // console.log( file );

  // var files = provider.directoryRead( 'staging' );
  // console.log( file )

  var files = provider.packageFilesGet();
  console.log( files )
})