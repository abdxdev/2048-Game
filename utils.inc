include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
include \masm32\include\gdi32.inc

includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib
includelib \masm32\lib\gdi32.lib
includelib \masm32\lib\msvcrt.lib


ConvertHexColor PROTO :DWORD
GetRandomIndex PROTO :DWORD
DrawGrid PROTO :DWORD
printf PROTO C :PTR SBYTE, :VARARG   
DisplayNumber PROTO :DWORD, :DWORD, :DWORD
CaptureKeyInput PROTO          ; New prototype for capturing key inputs