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
    num dd 2, 4, 8, 16, 32, 64, 128, 256, 428
    counter dd 0

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

; Window Procedure
WndProc proc hWnd:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
    LOCAL ps:PAINTSTRUCT
    LOCAL hdc:DWORD

    .if uMsg == WM_PAINT
        Invoke BeginPaint, hWnd, addr ps
        
        mov hdc, eax                   
        INVOKE DrawGrid, hdc

        LOOP1:
        ; Get random index (0-8) from num array
        INVOKE GetRandomIndex, 9        ; Returns in edx
        push edx
        INVOKE Sleep, 10   
        mov ecx, OFFSET num             ; Base address of num array
        pop edx
        mov eax, [ecx + edx * 4]        ; Get the number from the array
        
        ; Display the number in the selected cell
        INVOKE DisplayNumber, hdc, counter, eax
        
        inc counter
        cmp counter, 16
        jl LOOP1

        INVOKE EndPaint, hWnd, addr ps
        xor eax, eax
        ret
    .elseif uMsg == WM_DESTROY
        invoke PostQuitMessage, 0
    .else
        invoke DefWindowProc, hWnd, uMsg, wParam, lParam
        ret
    .endif
    xor eax, eax
    ret
WndProc endp

end start
