.386
.model flat, stdcall
option casemap:none

include utils.inc

.data
    ClassName   db "MyWinClass", 0
    AppTitle    db "2048-The Game", 0
    hInstance   dd ?
    msg         MSG <>
    wc          WNDCLASS <>
    hwndMain    dd ?
    hexColor    dd  00ffd0c7h
    arr dd 16 dup(0)
    selectedIndex dd 16 dup(?) 
    num dd 2, 4, 8, 16, 32, 64, 128, 256, 428
    counter dd 0 

.code
start:
    invoke GetModuleHandle, NULL
    mov hInstance, eax

    ; Setup Window Class
    mov wc.style, CS_HREDRAW or CS_VREDRAW
    mov wc.lpfnWndProc, offset WndProc
    mov wc.cbClsExtra, 0
    mov wc.cbWndExtra, 0
    mov eax, hInstance
    mov wc.hInstance, eax
    invoke LoadIcon, NULL, IDI_APPLICATION
    mov wc.hIcon, eax
    invoke LoadCursor, NULL, IDC_ARROW
    mov wc.hCursor, eax

    ;backgroundColor
    INVOKE ConvertHexColor, hexColor 
    INVOKE CreateSolidBrush, eax               
    mov wc.hbrBackground, eax
    
    mov wc.lpszMenuName, NULL
    lea eax, ClassName  ; Use LEA for string addresses
    mov wc.lpszClassName, eax

    ; Register Window Class
    invoke RegisterClass, addr wc
    test eax, eax
    jz Exit  ; If RegisterClass fails, exit

    invoke CreateWindowEx, 0, addr ClassName, addr AppTitle, \
                          WS_OVERLAPPEDWINDOW, CW_USEDEFAULT, CW_USEDEFAULT, \
                          520, 600, NULL, NULL, hInstance, NULL
    mov hwndMain, eax
    test eax, eax
    jz Exit  ; If CreateWindowEx fails, exit

    ; Show and update the window
    invoke ShowWindow, hwndMain, SW_SHOWNORMAL
    invoke UpdateWindow, hwndMain

MessageLoop:
    invoke GetMessage, addr msg, NULL, 0, 0
    cmp eax, 0
    je Exit
    invoke TranslateMessage, addr msg
    invoke DispatchMessage, addr msg
    jmp MessageLoop

Exit:
    invoke ExitProcess, 0

; Window Procedure - a function that recieves msg from windows like redraw, keyinput etc
WndProc proc hWnd:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
    LOCAL ps:PAINTSTRUCT
    LOCAL hdc:DWORD

    .if uMsg == WM_PAINT
        Invoke BeginPaint, hWnd, addr ps
        mov hdc, eax                   ; Store device context

        INVOKE DrawGrid, hdc

        LOOP1:
        
        ; Get second random index (0-8) - selecting number
        INVOKE GetRandomIndex, 9        ; Returns in edx
        push edx
        INVOKE Sleep, 10   
        mov ecx, OFFSET num             ; Base address of num array
        pop edx
        mov eax, [ecx + edx * 4]        ; Get the random number from num array
        
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
