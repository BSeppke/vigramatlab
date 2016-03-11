function load_vigra_c()
  
    check_install_vigra_c()

    if( libisloaded('libvigra_c') == 0 )
        loadlibrary('libvigra_c.dylib')
    end
end