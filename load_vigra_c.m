function load_vigra_c()
  
    check_install_vigra_c()

    addpath(fullfile(matlabroot,'extern','include'))

    if( libisloaded('libvigra_c') == 0 )
        if( ismac() )
            loadlibrary('libvigra_c.dylib');
        elseif ( isunix() )
            loadlibrary('libvigra_c.so');
        elseif (ispc() )
            error('Error: Due to hdf5 conflicts, windows is temporary not supported!')
            %loadlibrary('vigra_c.dll', 'libvigra_c.h');
        else
            error('Error: Only macosx, windows and unix are supported!')
        end
    end
end