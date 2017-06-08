function result = check_install_vigra_c()
    try
        if(~libisloaded('libvigra_c'))
            loadlibrary(dylib_path());
            unloadlibrary('libvigra_c');
        end
    catch
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
        flags = '-DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS=-m32 -DCMAKE_C_FLAGS=-m32';
    else
        flags = '-DCMAKE_BUILD_TYPE=Release';
    end
end

function path = vigra_c_path()
    path = [vigramatlab_path() ,'vigra_c/'];
end

function version = vigra_version()
    [status, version_string] = system('vigra-config --version');
    disp(version_string);
    if (status == 0)
        version = str2double(strsplit(version_string, '.'));
    else
        version = [];
    end
end

function installed = vigra_installed()
    display('Searching for vigra >= 1.11.0 using <vigra-config --version>')
    version = vigra_version();
    
    if(length(version) == 3)
        if( ((version(1) == 1) && (version(2) >= 11)) || (version(1) > 1))
            installed = 1;
        else
            installed = 0;
        end
    else
        installed = 0;
    end
end

function create_header_file()
    headers = {'vigra_convert_c.h';'vigra_filters_c.h';...
               'vigra_imgproc_c.h';'vigra_impex_c.h';'vigra_morphology_c.h';...
               'vigra_segmentation_c.h';'vigra_splineimageview_c.h';...
               'vigra_tensors_c.h'};
    
    ignore_patterns = {'#include';'#ifndef VIGRA';'#define VIGRA';'#endif'};
    
    result_file = 'libvigra_c.h';
    
    out_file = fopen(result_file, 'w');
    
    for i=1:size(headers,1)
        filename = [vigra_c_path(), 'src/', headers(i)];
        in_file = fopen(strjoin(filename,''), 'r');
        
        tline = fgets(in_file);
        while ischar(tline)
            ignore=0;
            for j=1:size(ignore_patterns,1)
                pattern=strjoin(ignore_patterns(j));
                lenline = size(tline,2);
                lenpat  = size(pattern,2);
                if(lenline >= lenpat)
                    if(strcmp(tline(1:lenpat),pattern))
                        ignore=1;
                    end
                end
            end
            if(ignore == 0)
                tline = strrep(tline, 'PixelType','float');
                tline = strrep(tline, 'LIBEXPORT','');
                fwrite(out_file,tline);
            end
            tline = fgets(in_file);
        end
        fclose(in_file);
    end
    fclose(out_file);
end


function result = build_vigra_c()
    create_header_file();
    if( isunix() )
        % Add MacPorts path for Mac OS X, if not already there
        if( ismac() && isempty(strfind(getenv('PATH'), '/opt/local/bin:')) )
            setenv('PATH', ['/opt/local/bin:' getenv('PATH') ]);
        end
        if( vigra_installed() == 1)
            display ('-------------- BUILDING VIGRA-C-WRAPPER FOR COMPUTER VISION AND IMAGE PROCESSING TASKS --------------')
            if( system(['cd ' , vigra_c_path() , '&& mkdir -p build && cd build && cmake ' , cmake_flags(), ' .. && make && cd .. && rm -rf ./build']) == 0)
                copyfile([vigra_c_path() , 'bin/' , dylib_file()], dylib_path(), 'f');
            else
                error('making the vigra_c lib failed, although vigra seems to be installed')
            end     
        else
            error('Vigra is not found. Please check if the prefix path is set correctly in ~/.profile environment file!')
        end
    elseif( ispc() )
        bindir = [vigra_c_path() , 'bin/' , 'win' , matlab_bits() , '/'];
        copyfile( [bindir , '*.dll '] , vigramatlab_path());
    else
        error('Only Mac OS X, Unix and Windows are supported for auto build of vigra_c!')
    end
    result = 1;
end
