@echo off

echo nasm -g -fwin32 charity.asm | %userprofile%\AppData\Local\NASM\nasmpath.bat

echo cl /Zi charity.obj msvcrt.lib legacy_stdio_definitions.lib | %comspec% /k ""C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat"" x86

REM return to prompt so we can run the program
REM cmd