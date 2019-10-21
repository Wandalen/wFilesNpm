( function _Path_test_ss_( ) {

'use strict';


if( typeof module !== 'undefined' )
{

	require( '../file/fprovider/pNpm.ss' );

	var _ = wTools;

	_.include( 'wTesting' );

}

//

var _ = wTools;
var Parent = wTools.Tester;

//

var adjustStat = ( stat ) =>
{
	if( !stat )
	return stat;

	stat.atime = stat.atime.getTime();
	stat.mtime = stat.mtime.getTime();
	stat.ctime = stat.ctime.getTime();
	stat.birthtime = stat.birthtime.getTime();
}

//

function fileRead( t )
{
	t.description = 'fileRead';

	var provider;

	var npm = _.FileProvider.Npm({ packageName : 'wTools' })
	.doThen( ( err, got ) =>
	{
		provider = got
	})
	.doThen( () =>
	{
		t.shouldThrowError( () => provider.fileRead( '/' ) );
		t.shouldThrowError( () => provider.fileRead( '/a.xxx' ) );

		var filePath = '/LICENSE';
		var file = provider.fileRead( filePath );
		var stat = provider.fileStat( filePath );
		t.shouldBe( file.length === stat.size );
	})

	return npm;
}

//

function directoryRead( t )
{
	t.description = 'directoryRead';

	var provider;

	var npm = _.FileProvider.Npm({ packageName : 'wTools' })
	.doThen( ( err, got ) =>
	{
		provider = got
	})
	.doThen( () =>
	{
		var filePath = '/a.xxx';
		var files = provider.directoryRead( filePath );
		var expected = _.fileProvider.directoryRead( _.pathReroot( provider.versionPath, filePath ) )
		t.identical( files, expected );

		var filePath = '/LICENSE';
		var files = provider.directoryRead( filePath );
		var expected = _.fileProvider.directoryRead( _.pathReroot( provider.versionPath, filePath ) )
		t.identical( files, expected )

		var filePath = '/';
		var files = provider.directoryRead( filePath );
		var expected = _.fileProvider.directoryRead( _.pathReroot( provider.versionPath, filePath ) )
		t.identical( files, expected )
	})

	return npm;
}

//

function fileStat( t )
{
	t.description = 'fileStat';

	var provider;

	var npm = _.FileProvider.Npm({ packageName : 'wTools' })
	.doThen( ( err, got ) =>
	{
		provider = got
	})
	.doThen( () =>
	{
		var filePath = '/a.xxx';
		var stat = provider.fileStat( filePath );
		var expected = _.fileProvider.fileStat( _.pathReroot( provider.versionPath, filePath ) )
		t.identical( adjustStat( stat ), adjustStat( expected  ) );

		var filePath = '/LICENSE';
		var stat = provider.fileStat( filePath );
		var expected = _.fileProvider.fileStat( _.pathReroot( provider.versionPath, filePath ) )
		t.identical( adjustStat( stat ), adjustStat( expected  ) );

		var filePath = '/';
		var stat = provider.fileStat( filePath );
		var expected = _.fileProvider.fileStat( _.pathReroot( provider.versionPath, filePath ) )
		t.identical( adjustStat( stat ), adjustStat( expected  ) );
	})

	return npm;
}

//

function fileRecord( t )
{
	t.description = 'fileRecord';

	var provider;

	var npm = _.FileProvider.Npm({ packageName : 'wTools' })
	.doThen( ( err, got ) =>
	{
		provider = got
	})
	.doThen( () =>
	{
		var filePath = '/a.xxx';
		var record = provider.fileRecord( filePath );
		var expected = _.fileProvider.fileRecord( _.pathReroot( provider.versionPath, filePath ) )
		t.identical( record.fileProvider, provider );
		record.fileProvider = null;
		expected.fileProvider = null;
		t.identical( record, expected );

		//

		var filePath = '/LICENSE';
		var record = provider.fileRecord( filePath );
		var expected = _.fileProvider.fileRecord( _.pathReroot( provider.versionPath, filePath ) )
		adjustStat( record.stat );
		adjustStat( expected.stat );
		t.identical( record.fileProvider, provider );
		record.fileProvider = null;
		expected.fileProvider = null;
		t.identical( record, expected );

		//

		var filePath = '/';
		var record = provider.fileRecord( filePath );
		var expected = _.fileProvider.fileRecord( _.pathReroot( provider.versionPath, filePath ) )
		adjustStat( record.stat );
		adjustStat( expected.stat );
		t.identical( record.fileProvider, provider );
		record.fileProvider = null;
		expected.fileProvider = null;
		t.identical( record, expected );
	})

	return npm;
}

//

function filesFindRecursive( t )
{
	t.description = 'fileRecord';

	var provider;

	var npm = _.FileProvider.Npm({ packageName : 'wTools' })
	.doThen( ( err, got ) =>
	{
		provider = got
	})
	.doThen( () =>
	{
		var filePath = '/';
		var files = provider.filesFindRecursive({ filePath : filePath, outputFormat : 'relative' });
		var filePath = _.pathReroot( provider.versionPath, filePath );
		var expected = _.fileProvider.filesFindRecursive({ filePath : filePath, outputFormat : 'relative' });
		t.identical( files, expected );
	})

	return npm;
}


// --
// proto
// --

var Self =
{

	name : 'FileProvider.Npm test',
	silencing : 1,

	tests :
	{
		fileRead : fileRead,
		directoryRead : directoryRead,
		fileStat : fileStat,
		fileRecord : fileRecord,
		filesFindRecursive : filesFindRecursive
	},

}

// createTestsDirectory( testRootDirectory, true );

Self = wTestSuite( Self )
if( typeof module !== 'undefined' && !module.parent )
_.Tester.test( Self.name );

} )( );
