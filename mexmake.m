addpath('src')
output_path = [pwd '/bin'];
cd src

try
	
	mexflags = {'-O', '-v', 'CFLAGS="$CFLAGS -std=c99"', '-outdir', output_path};
	
	libdeflate_path_lib = ['-L' pwd '/extlib/libdeflate/x64/win'];
	pthreadsw32_path_lib = ['-L' pwd '/extlib/pthreads-win32/lib/x64'];
	pthreadsw32_path_include = ['-I' pwd '/extlib/pthreads-win32/include'];
	
	sources = {'getmatvar_.c',...
		'mexSet.c',...
		'cleanup.c',...
		'createDataObjects.c',...
		'ezq.c',...
		'fillDataObjects.c',...
		'getDataObjects.c',...
		'getSystemInfo.c',...
		'init.c',...
		'navigate.c',...
		'numberHelper.c',...
		'placeChunkedData.c',...
		'placeData.c',...
		'readMessage.c',...
		'superblock.c',...
		'utils.c'};
	
	if(strcmp(mex.getCompilerConfigurations('C','Selected').ShortName, 'mingw64'))
		
		sources = [sources,...
			{'extlib/mman-win32/mman.c',...
			'extlib/pthreads-win32/lib/x64/libpthreadGC2.lib',...
			'extlib/libdeflate/x64/win/libdeflate.lib'}
			];
		
		mex(pthreadsw32_path_include, mexflags{:} , sources{:})
		
	elseif(startsWith(mex.getCompilerConfigurations('C','Selected').ShortName, 'MSVC'))
		
		sources = [sources,...
			{'extlib/mman-win32/mman.c',...
			'extlib/pthreads-win32/lib/x64/pthreadVC2.lib',...
			'extlib/libdeflate/x64/win/libdeflate.lib'}
			];
		
		mex(pthreadsw32_path_include, mexflags{:} , sources{:})
		
	elseif(strcmp(mex.getCompilerConfigurations('C','Selected').ShortName, 'gcc'))
		
		sources = [sources,{'extlib/libdeflate/x64/unix/libdeflate.a'}];
		mex(pthreadsw32_path_include, mexflags{:} , sources{:})
		
	end
	
	cd ..
	clear libdeflate_path pthreadvc2_path clear output_path
	
catch ME
	
	cd ..
	rethrow(ME)
	
end