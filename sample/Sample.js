require( '../staging/dwtools/amid/file/fprovider/pNmp.ss' );

var _ = wTools

_.FileProvider.Npm({ packageName : 'wTools' })
.got(( err, provider ) =>
{
  if( err )
  throw err;

  var file = provider.fileRead( '/staging/dwtools/Base.s' );
  console.log( file )

  // var files = provider.directoryRead( '/staging/dwtools' );
  // console.log( files )

  // var files = provider.filesFindRecursive({ filePath :  '/', outputFormat : 'relative' });
  // console.log( files );

  // var stat = provider.fileStat( '/staging/dwtools/Base.s' );
  // console.log( stat )
})