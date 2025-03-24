.386
.model flat, stdcall
option casemap:none

include utils.inc


.data
    ClassName   db "MainWinClass", 0
    AppTitle    db "2048 Game", 0
    msg         MSG <>
    wc          WNDCLASS <>
    hexColor    dd  00ffd0c7h
    gridCellNo dd 16 dup(0)
    num dd 2, 4, 8, 16, 2, 4, 8, 16, 2, 4, 8, 16, 2, 4, 8, 16

.code
start:
    ; Configure Window Class
    mov wc.style, CS_HREDRAW or CS_VREDRAW
    mov wc.lpfnWndProc, offset WndProc
    mov wc.lpszClassName, offset ClassName
    invoke GetModuleHandle, NULL
    mov wc.hInstance, eax
    invoke LoadIcon, NULL, IDI_APPLICATION
    mov wc.hIcon, eax
    invoke LoadCursor, NULL, IDC_ARROW
    mov wc.hCursor, eax

    ; Background color
    invoke ConvertHexColor, hexColor
    invoke CreateSolidBrush, eax
    mov wc.hbrBackground, eax

    ; Register Class
    invoke RegisterClass, addr wc
    .if eax == 0
        invoke ExitProcess, 0
    .endif

    ; Create Window
    invoke CreateWindowEx, 0, addr ClassName, addr AppTitle, WS_OVERLAPPEDWINDOW, CW_USEDEFAULT, CW_USEDEFAULT, 800, 600, NULL, NULL, wc.hInstance, NULL
    .if eax == NULL
        invoke ExitProcess, 0
    .endif

    ; Show & Update Window
    invoke ShowWindow, eax, SW_SHOWNORMAL
    invoke UpdateWindow, eax

    ; Message Loop
    .while TRUE
        invoke GetMessage, addr msg, NULL, 0, 0
        .break .if eax == 0
        invoke TranslateMessage, addr msg
        invoke DispatchMessage, addr msg
    .endw

    invoke ExitProcess, 0

; Main Window Procedure
WndProc proc hWnd:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
    LOCAL ps:PAINTSTRUCT
    LOCAL hdc:DWORD
    LOCAL counter:DWORD

    .if uMsg == WM_DESTROY
        invoke PostQuitMessage, 0
    .elseif uMsg == WM_PAINT

        ; Draw Grid
        invoke BeginPaint, hWnd, addr ps
        mov hdc, eax        
        invoke DrawGrid, hdc
        mov counter, 0

        .repeat
            invoke Sleep, 10
            mov eax, counter
            mov eax, [num + eax * 4]
            invoke DisplayNumber, hdc, counter, eax
            inc counter
        .until counter >= 16
        
        invoke EndPaint, hWnd, addr ps

    .else
        invoke DefWindowProc, hWnd, uMsg, wParam, lParam
    .endif
    ret

WndProc endp

end start
