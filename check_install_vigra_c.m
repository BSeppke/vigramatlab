function result = check_install_vigra_c()
  
    if( not(exist( dylib_path() ,'file')) )
        result = build_vigra_c();
    end
    if (ispc())
        path(path, vigramatlab_path())
    end
end

function path = vigramatlab_path()
    path = [pwd, '/'];
end

function bits = matlab_bits()
  arch = computer('arch');
  bits = arch(length(arch)-1:end);  
end

function file = dylib_file()
    if( ismac() )
        file = 'libvigra_c.dylib';
    elseif ( isunix() )
        file = 'libvigra_c.so';
    elseif (ispc() )
        file = 'vigra_c.dll';
    else
        error('Error: Only macosx, windows and unix are supported')
    end
end

function path = dylib_path()
  path = [vigramatlab_path() , dylib_file()];
end

function flags = cmake_flags()

    if( matlab_bits() == 32)
        flags = '-DCMAKE_CXX_FLAGS=-m32 -DCMAKE_C_FLAGS=-m32';
    else
        flags = '';
    end
end

function script_filename = base_login_script()
    script_filename =  '~/.profile';
end

function path = vigra_c_path()
    path = [vigramatlab_path() ,'vigra_c/'];
end

function script_filename = login_script()

    if ( exist( base_login_script(), 'file') )
        script_filename = base_login_script();
    else
        script_filename = [vigra_c_path() , 'fallback.profile'];
    end
end

function cmd = login_cmd()
    cmd = ['source ' , login_script()];
end

function result = system_env( arg )
    result = system([login_cmd() , ' && ' , arg]);
end

function installed = vigra_installed()
    display('Searching for vigra using <vigra-config --version>')
    installed = system_env('vigra-config --version');
end

function result = build_vigra_c()
    system_env(['cat ' , vigra_c_path() , 'src/vigra_*.h | grep -v ^#include | sed -e "s/LIBEXPORT//"> libvigra_c.h'])
    if( isunix() )
        if( vigra_installed() == 0)
            display ('-------------- BUILDING VIGRA-C-WRAPPER FOR COMPUTER VISION AND IMAGE PROCESSING TASKS --------------')
            if( system_env(['cd ' , vigra_c_path() , '&& mkdir -p build && cd build && cmake ' , cmake_flags(), ' .. && make && cd .. && rm -rf ./build']) == 0)
                result = copyfile([vigra_c_path() , 'bin/' , dylib_file()], dylib_path(), 'f');
            else
                error('making the vigra_c lib failed, although vigra seems to be installed')
            end     
        else
            error('Vigra is not found. Please check if the prefix path is set correctly in ~/.profile environment file!')
        end
    elseif( ispc() )
        bindir = [vigra_c_path() , 'bin/' , 'win' , idl_bits() , '/'];
        result = system(['copy ' , bindir , '*.dll ' , vigraidl_path()]);
        result = system(['copy ' , vigraidl_path() , 'zlib.dll ' , vigraidl_path() , '/zlibwapi.dll']);
    else
        error('Only Mac OS X, Unix and Windows are supported for auto build of vigra_c!')
    end
    result = 1;
end
