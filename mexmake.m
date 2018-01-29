addpath('src')
output_path = [pwd '/bin'];
cd src

try
	
	mexflags = {'-g', '-v', '-largeArrayDims', 'CFLAGS="$CFLAGS -std=c99"', '-outdir', output_path};
	
	libdeflate_path_lib = ['-L' pwd '/extlib/libdeflate/x64/win'];
	
	sources = {'getmatvar_.c',...
		'mexSet.c',...
		'cleanup.c',...
		'createDataObjects.c',...
		'ezq.c',...
		'mtezq.c',...
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
			'extlib/libdeflate/x64/win/libdeflate.lib'}
			];
		
		mex(mexflags{:} , sources{:})
		
	elseif(startsWith(mex.getCompilerConfigurations('C','Selected').ShortName, 'MSVC'))
		
		sources = [sources,...
			{'extlib/mman-win32/mman.c',...
			'extlib/libdeflate/x64/win/libdeflate.lib'}
			];
		
		mex(mexflags{:} , sources{:})
		
	elseif(strcmp(mex.getCompilerConfigurations('C','Selected').ShortName, 'gcc'))
		
		%sources = [sources,{['-L' fullfile(pwd,'extlib','libdeflate','x64','unix')], '-ldeflate'}];
		sources = [sources, {fullfile(pwd,'extlib','libdeflate','x64','unix','libdeflate.a')}];
        mex(mexflags{:} , sources{:})
		
	end
	
	cd ..
	clear mexflags sources libdeflate_path_lib pthreadsw32_path_lib pthreadsw32_path_include output_path
	
catch ME
	
	cd ..
	rethrow(ME)
	
end