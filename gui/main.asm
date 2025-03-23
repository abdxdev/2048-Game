.386
.model flat, stdcall
option casemap:none

include utils.inc

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
include \masm32\include\gdi32.inc

includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib
includelib \masm32\lib\gdi32.lib

.data
    ClassName   db "MyWinClass", 0
    AppTitle    db "2048 Game", 0
    hInstance   dd ?
    msg         MSG <>
    wc          WNDCLASS <>
    hwndMain    dd ?
    hexColor    dd  00ffd0c7h

.code
start:
    invoke GetModuleHandle, NULL
    mov hInstance, eax

    ; Setup Window Class
    mov wc.style, CS_HREDRAW or CS_VREDRAW
    mov wc.lpfnWndProc, offset WndProc
    mov wc.cbClsExtra, 0
    mov wc.cbWndExtra, 0
    mov wc.hInstance, hInstance
    invoke LoadIcon, NULL, IDI_APPLICATION
    mov wc.hIcon, eax
    invoke LoadCursor, NULL, IDC_ARROW
    mov wc.hCursor, eax

    ; Background color
    invoke ConvertHexColor, hexColor 
    invoke CreateSolidBrush, eax               
    mov wc.hbrBackground, eax
    
    mov wc.lpszMenuName, NULL
    lea eax, ClassName
    mov wc.lpszClassName, eax

    ; Register Window Class
    invoke RegisterClass, addr wc
    .if eax == 0
        jmp Exit  ; If RegisterClass fails, exit
    .endif

    invoke CreateWindowEx, 0, addr ClassName, addr AppTitle, \
                          WS_OVERLAPPEDWINDOW, CW_USEDEFAULT, CW_USEDEFAULT, \
                          800, 600, NULL, NULL, hInstance, NULL
    mov hwndMain, eax
    .if eax == 0
        jmp Exit  ; If CreateWindowEx fails, exit
    .endif

    ; Show and update the window
    invoke ShowWindow, hwndMain, SW_SHOWNORMAL
    invoke UpdateWindow, hwndMain

    ; Message Loop
    .while TRUE
        invoke GetMessage, addr msg, NULL, 0, 0
        .break .if eax == 0
        invoke TranslateMessage, addr msg
        invoke DispatchMessage, addr msg
    .endw

Exit:
    invoke ExitProcess, 0

; Window Procedure
WndProc proc hWnd:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
    .if uMsg == WM_DESTROY
        invoke PostQuitMessage, 0
    .else
        invoke DefWindowProc, hWnd, uMsg, wParam, lParam
        ret
    .endif
    xor eax, eax
    ret
WndProc endp

end start
