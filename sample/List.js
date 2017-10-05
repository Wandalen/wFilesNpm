require( '../staging/dwtools/amid/file/fprovider/pNmp.ss' );

var _ = wTools;

_.FileProvider.Npm({ packageName : 'wTools' })
.got(( err, provider ) =>
{

  if( err )
  throw err;

  var files = provider.filesFindRecursive({ filePath :  '/', outputFormat : 'relative' });
  console.log( files );

})
