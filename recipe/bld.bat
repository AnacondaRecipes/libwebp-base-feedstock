md build
cd build

:: Hack for winres.h being called winresrc.h on VS2008
if %VS_MAJOR% LEQ 9 copy %RECIPE_DIR%\winres.h .

cmake -LAH -GNinja ..                                               ^
  -DCMAKE_WINDOWS_EXPORT_ALL_SYMBOLS=ON                             ^
  -DBUILD_SHARED_LIBS=ON                                            ^
  -DCMAKE_BUILD_TYPE=Release                                        ^
  -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX%                           ^
  -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX%                              ^
  -DCMAKE_FIND_ROOT_PATH=%LIBRARY_PREFIX%;%PREFIX%;%BUILD_PREFIX%   ^
  -DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY
if errorlevel 1 exit 1

cmake --build .
if errorlevel 1 exit 1
cmake --install .
if errorlevel 1 exit 1

:: for backwards compatibility with previous make build. This will fail on non-ntfs systems.
pushd %LIBRARY_PREFIX%\lib
:: add a symlink with "lib" prefixed for each lib file
FOR /F %%G IN ('dir "*webp*lib" /B') DO (MKLINK lib%%G %%G || echo failed to link %%G )
popd
pushd %LIBRARY_PREFIX%\bin
FOR /F %%G IN ('dir "*webp*dll" /B') DO (MKLINK lib%%G %%G || echo failed to link %%G )
popd
