.386
.model flat, stdcall
option casemap:none

include utils.inc


.data
    ClassName   db "MainWinClass", 0
    AppTitle    db "2048 Game", 0
    msg         MSG <>

    wc          WNDCLASS <>

    hexColor    dd  00FFD0C7h   ; Background color (Light Peach)
    gridCellNo  dd 16 dup(0)
    num         dd 2, 4, 8, 16, 32, 64, 128, 256, 428

    JetBrainsFont db "JetBrains Mono", 0
    hwndMain    dd 0   ; Store main window handle

.code
start:
    ; Get Module Handle
    invoke GetModuleHandle, NULL
    mov wc.hInstance, eax

    ; Configure Window Class
    mov wc.style, CS_HREDRAW or CS_VREDRAW
    mov wc.lpfnWndProc, offset WndProc
    mov wc.lpszClassName, offset ClassName
    invoke LoadIcon, NULL, IDI_APPLICATION
    mov wc.hIcon, eax
    invoke LoadCursor, NULL, IDC_ARROW
    mov wc.hCursor, eax

    ; Set Background Color
    invoke ConvertHexColor, hexColor
    invoke CreateSolidBrush, eax
    mov wc.hbrBackground, eax

    ; Register Class
    invoke RegisterClass, addr wc
    .if eax == 0
        invoke MessageBox, NULL, addr ClassName, addr AppTitle, MB_OK
        invoke ExitProcess, 0
    .endif

    ; Create Window
    invoke CreateWindowEx, 0, addr ClassName, addr AppTitle, WS_OVERLAPPEDWINDOW, 
                           CW_USEDEFAULT, CW_USEDEFAULT, 800, 600, NULL, NULL, 
                           wc.hInstance, NULL
    mov hwndMain, eax
    .if hwndMain == NULL
        invoke MessageBox, NULL, addr AppTitle, addr ClassName, MB_OK
        invoke ExitProcess, 0
    .endif

    ; Show & Update Window
    invoke ShowWindow, hwndMain, SW_SHOWNORMAL
    invoke UpdateWindow, hwndMain

    ; Message Loop
    .while TRUE
        invoke GetMessage, addr msg, NULL, 0, 0
        .break .if eax == 0
        invoke TranslateMessage, addr msg
        invoke DispatchMessage, addr msg
    .endw

    invoke ExitProcess, 0

;------------------------------------------------------
; Main Window Procedure
;------------------------------------------------------
WndProc proc hWnd:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
    LOCAL ps:PAINTSTRUCT
    LOCAL hdc:DWORD
    LOCAL hFont:DWORD

    .if uMsg == WM_DESTROY
        invoke PostQuitMessage, 0
        ret

    .elseif uMsg == WM_PAINT
        invoke BeginPaint, hWnd, addr ps
        mov hdc, eax

        ; Create JetBrains Mono Font
        invoke CreateFont, 24, 0, 0, 0, FW_BOLD, FALSE, FALSE, FALSE,
                          DEFAULT_CHARSET, OUT_TT_PRECIS, CLIP_DEFAULT_PRECIS,
                          CLEARTYPE_QUALITY, FF_DONTCARE, addr JetBrainsFont
        mov hFont, eax

        ; Check if the font was created successfully
        .if hFont == NULL
            invoke MessageBox, hWnd, addr JetBrainsFont, addr AppTitle, MB_OK
            invoke EndPaint, hWnd, addr ps
            ret
        .endif

        invoke SelectObject, hdc, hFont

        ; Set Text Color
        invoke SetTextColor, hdc, 000000FFh   ; Blue color

        ; Set Background Mode Transparent
        invoke SetBkMode, hdc, TRANSPARENT

        ; Display Sample Text
        invoke TextOut, hdc, 50, 50, addr AppTitle, 10     ; "2048 Game"
        invoke TextOut, hdc, 100, 100, addr JetBrainsFont, 16  ; Debug Font Name

        ; Restore Old Font & Delete Created Font
        invoke SelectObject, hdc, ps.hdc
        invoke DeleteObject, hFont

        invoke EndPaint, hWnd, addr ps
        ret

    .endif

    ; Call Default Window Procedure for unhandled messages
    invoke DefWindowProc, hWnd, uMsg, wParam, lParam
    ret
WndProc endp

end start
