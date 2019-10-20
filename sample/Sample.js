require( '../proto/dwtools/amid/file/fprovider/pNmp.ss' );

var _ = wTools

_.FileProvider.Npm({ packageName : 'wTools' })
.got(( err, provider ) =>
{
  if( err )
  throw err;

  var file = provider.fileRead( '/proto/dwtools/Base.s' );
  console.log( file )

  // var files = provider.directoryRead( '/proto/dwtools' );
  // console.log( files )

  // var files = provider.filesFindRecursive({ filePath :  '/', outputFormat : 'relative' });
  // console.log( files );

  // var stat = provider.fileStat( '/proto/dwtools/Base.s' );
  // console.log( stat )
})
