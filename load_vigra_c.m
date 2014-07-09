function load_vigra_c()
  
    check_install_vigra_c()

    if( libisloaded('libvigra_c') == 0 )
        loadlibrary('libvigra_c.dylib', 'vigra_c/src/vigra_all_c.h')
    end
end