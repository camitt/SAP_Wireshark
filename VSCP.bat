call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" amd64
cd %~dp0
set WIRESHARK_BASE_DIR=%~dp0\SAP_Wireshark
set QT5_BASE_DIR=C:\Qt\5.9.1\msvc2015_64
cd %~dp0\SAP_Wireshark
mkdir wsbuild64
cd wsbuild64
"C:\Program Files\CMake\bin\cmake.exe" -G "Visual Studio 14 2015 Win64" "%~dp0\SAP_Wireshark\wireshark"
msbuild /m /p:Configuration=RelWithDebInfo "%~dp0\SAP_Wireshark\wsbuild64\Wireshark.sln"
