vigramatlab
===========

Use the power of the computer vision library VIGRA by means of the MATLAB programming language

MatLab bindings using the vigra_c wrapper library to connect two famous toolsets: The vigra Computer Vision libraray and the scientific MATLAB environment. This binding was tested using Mac OS X 10.9 and MatLab 2013a, but should be working at other OS and newer MatLab versions, too.

1. Prerequisites
-----------------------------------
Before getting things to work for Mac OS X 10.9, you need to have XCode (>= 5.0) to be installed. Unfortunately, this is not sufficient - you need to patch MatLab to get the c-library calls working at OS X 10.9:

Go into the /Applications/MatLabXXXX.app folder (yes, that really is a folder, use the Terminal to get inside it).

a. Locate and edit "bin/mexopts.sh": Replace every occurence of "10.7" -> "10.8":
   Replace line 128 with: CC='xcrun  -sdk macosx10.8  clang'
   Replace line 134 with: MACOSX_DEPLOYMENT_TARGET='10.8' 
   Replace line 149 with :CXX='xcrun  -sdk macosx10.8  clang++'
   Although you are using OS X 10.9, this is sufficient.
   
b. Locate and edit " extern/include/tmwtypes.h": 
   Replace line 819 with: typedef UINT16_T CHAR16_T;
   
Now, your MEX is readily set up to work with OS X 10.9!

2. Auto-build of the c-wrapper
-----------------------------------
Each time you enter "load_vigra_c" to load the shared library of the c-wrapper, the existence of that library is checked. If it is not present, it will be build from source (mac os x and linux) or binaries will be copied (for windows).

3. Look at the examples
-----------------------------------
Open MatLab and change the current directory to the vigramatlab directory.
Double-click on the examples.m script and look how it calls the vigramatlab functions.