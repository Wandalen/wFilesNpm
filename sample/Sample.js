require( '../proto/wtools/amid/file/fprovider/pNmp.ss' );

let _ = wTools

_.FileProvider.Npm({ packageName : 'wTools' })
.got(( err, provider ) =>
{
  if( err )
  throw err;

  var file = provider.fileRead( '/proto/wtools/Base.s' );
  console.log( file )

  // var files = provider.directoryRead( '/proto/wtools' );
  // console.log( files )

  // var files = provider.filesFindRecursive({ filePath :  '/', outputFormat : 'relative' });
  // console.log( files );

  // console.log( stat )
})
