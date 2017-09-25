addpath('tests')
addpath('src')
output_path = [pwd '/bin'];
cd src

try
	
	libdeflate_path_lib = ['-L' pwd '/extlib/libdeflate/x64/win'];
	pthreadsw32_path_lib = ['-L' pwd '/extlib/pthreads-win32/lib/x64'];
	pthreadsw32_path_include = ['-I' pwd '/extlib/pthreads-win32/include'];
	if(strcmp(mex.getCompilerConfigurations('C','Selected').ShortName, 'mingw64'))
		mex(libdeflate_path_lib, pthreadsw32_path_lib, '-llibdeflate','-llibpthreadGC2',...
			'-g', '-v', 'CFLAGS="$CFLAGS -std=c11 -lpthread"', '-outdir', output_path ,...
			'getmatvar_.c',...
			'extlib/mman-win32/mman.c',...
			'extlib/thpool/thpool.c',...
			'fileHelper.c',...
			'getSystemInfo.c',...
			'mapping.c',...
			'numberHelper.c',...
			'ezq.c',...
			'chunkedData.c',...
			'mexPointerSetters.c',...
			'readMessage.c')
	elseif(startsWith(mex.getCompilerConfigurations('C','Selected').ShortName, 'MSVC'))
		mex(libdeflate_path_lib, pthreadsw32_path_lib, pthreadsw32_path_include,...
			'-llibdeflate', '-lpthreadVC2', ...
			'-g', '-v', 'CFLAGS="$CFLAGS -std=c11"', '-outdir', output_path ,...
			'getmatvar_.c',...
			'extlib/mman-win32/mman.c',...
			'extlib/thpool/thpool.c',...
			'fileHelper.c',...
			'getSystemInfo.c',...
			'mapping.c',...
			'numberHelper.c',...
			'ezq.c',...
			'chunkedData.c',...
			'mexPointerSetters.c',...
			'readMessage.c')
	elseif(strcmp(mex.getCompilerConfigurations('C','Selected').ShortName, 'gcc'))
		libdeflate_path_lib = ['-L' pwd '/extlib/libdeflate/x64/unix'];
		mex(libdeflate_path_lib, ...
			'-ldeflate', '-lpthread', ...
			'-g', '-v', 'CFLAGS="$CFLAGS -std=c99"', '-outdir', output_path ,...
			'getmatvar_.c',...
			'extlib/thpool/thpool.c',...
			'fileHelper.c',...
			'getSystemInfo.c',...
			'mapping.c',...
			'numberHelper.c',...
			'ezq.c',...
			'chunkedData.c',...
			'mexPointerSetters.c',...
			'readMessage.c')
	end
	
	cd ..
	clear libdeflate_path pthreadvc2_path clear output_path
	
catch ME
	
	cd ..
	rethrow(ME)
	
end