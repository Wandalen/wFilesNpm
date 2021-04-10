require( '../proto/wtools/amid/file/fprovider/pNmp.ss' );

let _ = wTools;

_.FileProvider.Npm({ packageName : 'wTools' })
.got(( err, provider ) =>
{

  if( err )
  throw err;

  var files = provider.filesFindRecursive({ filePath :  '/', outputFormat : 'relative' });
  console.log( files );

})
