vigramatlab
===========

Use the power of the computer vision library VIGRA by means of the MATLAB programming language

MatLab bindings using the vigra_c wrapper library to connect two famous toolsets: The vigra Computer Vision libraray and the scientific MATLAB environment. This binding was tested using Mac OS X 10.10 and MatLab 2015b, but should be working at other OS and newer MatLab versions, too.

1. Prerequisites
-----------------------------------
Before getting things to work for Mac OS X 10.10, you need to have XCode (>= 7.0) to be installed. Unfortunately, this is not sufficient - you need to patch MatLab 2015b to get the c-library calls working at OS X 10.10. The steps for this patch as well as the patch itself can be retrieved from:
http://de.mathworks.com/matlabcentral/answers/246507-why-can-t-mex-find-a-supported-compiler-in-matlab-r2015b-after-i-upgraded-to-xcode-7-0#answer_194526

2. Auto-build of the c-wrapper
-----------------------------------
Each time you enter "load_vigra_c" to load the shared library of the c-wrapper, the existence of that library is checked. If it is not present, it will be build from source (mac os x and linux) or binaries will be copied (for windows).

If you encounter error messages, like:

> Error using loadlibrary
> There was an error loading the library
> "/Users/seppke/development/vigramatlab/libvigra_c.dylib"
> dlopen(/Users/seppke/development/vigramatlab/libvigra_c.dylib, 6): Library not loaded:
>   /opt/local/lib/libtiff.5.dylib
> Referenced from: /Users/seppke/development/vigramatlab/libvigra_c.dylib
> Reason: Incompatible library version: libvigra_c.dylib requires version 8.0.0 or later, but
>   libtiff.5.dylib provides version 6.0.0

this is due to the fact, that MatLab brings with its own type of (older) libtiff library and puts this one into the DYLD_LIBRARY_PARTH. Inside the folder 
> /Applications/MATLAB_R2015b.app/bin/maci64 
MatLab keeps its own libtiff.5.dylib and is not willing to use other libs. However, you may convince MatLab by exchanging the libtiff with the newer one. This worked for me:
> cd /Applications/MATLAB_R2015b.app/bin/maci64 
> mv libtiff.5.dylib libtiff.5.orig.dylib
> cp /opt/local/lib/libtiff.5.dylib .


3. Look at the examples
-----------------------------------
Open MatLab and change the current directory to the vigramatlab directory.
Double-click on the examples.m script and look how it calls the vigramatlab functions.