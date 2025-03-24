.386
.model flat,stdcall
.stack 4096
option casemap:none

include utils.inc

.data
    fmt db "%d", 0  ; Format for integer conversion
    hFont dd 0      ; Font handle
    tickFmt db "Tick Count: %u", 10, 0  ; For Debug
    FontName db "JetBrains Mono", 0

.code

; Existing ConvertHexColor function
ConvertHexColor proc color:DWORD
    mov eax, color   ; EAX = 0x00RRGGBB
    mov edx, eax     
    and eax, 0FFh    
    shl eax, 16      
    and edx, 0FF00h  
    or eax, edx      
    mov ecx, color   
    and ecx, 0FF0000h 
    shr ecx, 16      
    or eax, ecx      ; Combine BBGGRR
    
    ret
ConvertHexColor endp

; Capture key input
CaptureKeyInput proc
    LOCAL msg:MSG
KeyLoop:
    invoke GetMessage, ADDR msg, 0, 0, 0
    test eax, eax
    jz ExitKeyLoop

    cmp msg.message, WM_KEYDOWN
    jne KeyLoop

    mov eax, msg.wParam
    .if eax == 'W'
        jmp MoveUp
    .elseif eax == 'A'
        jmp MoveLeft
    .elseif eax == 'S'
        jmp MoveDown
    .elseif eax == 'D'
        jmp MoveRight
    .elseif eax == 'Q'
        invoke ExitProcess, 0
    .elseif eax == 'R'
        jmp ResetGame
    .endif

    jmp KeyLoop

MoveUp:
    ; Handle moving up
    jmp KeyLoop

MoveLeft:
    ; Handle moving left
    jmp KeyLoop

MoveDown:
    ; Handle moving down
    jmp KeyLoop

MoveRight:
    ; Handle moving right
    jmp KeyLoop

ResetGame:
    ; Handle resetting the game
    jmp KeyLoop

ExitKeyLoop:
    ret
CaptureKeyInput endp

; Get random index
GetRandomIndex proc arrSize:DWORD
    invoke GetTickCount                 ;TickCount stored in eax

    push eax
    invoke printf, ADDR tickFmt, eax    ;This fkr modifies all gen register values, use with caution, save yourself hours of debugging
    pop eax

    xor edx, edx
    mov ebx, arrSize
    div ebx                             ;Quotient stored in eax, remainder in edx
    ret
GetRandomIndex endp

; Draw grid
DrawGrid proc hdc:DWORD
    LOCAL i:DWORD, x:DWORD, y:DWORD, cellSize:DWORD

    mov cellSize, 95  ; Cell size

    ; Draw vertical lines (5 lines for 4 cells)
    mov i, 0
    .while i < 5
        mov eax, i
        mul cellSize
        add eax, 200
        mov x, eax

        invoke MoveToEx, hdc, x, 70, NULL
        invoke LineTo, hdc, x, 450

        inc i
    .endw

    ; Draw horizontal lines (5 lines for 4 cells)
    mov i, 0
    .while i < 5
        mov eax, i
        mul cellSize
        add eax, 70
        mov y, eax

        invoke MoveToEx, hdc, 200, y, NULL
        invoke LineTo, hdc, 580, y

        inc i
    .endw

    ret
DrawGrid endp

DisplayNumber proc hdc:DWORD, cellNo:DWORD, number:DWORD
    LOCAL strBuffer[12]:BYTE  ; (max 3 digits + null terminator)
    LOCAL cellX:DWORD, cellY:DWORD
    LOCAL row:DWORD, col:DWORD

    ; Convert number to string
    invoke wsprintfA, ADDR strBuffer, ADDR fmt, number

    ; Compute row and column
    mov eax, cellNo
    mov ecx, 4
    xor edx, edx
    div ecx   ; EAX = row, EDX = col

    mov row, eax
    mov col, edx

    ; Calculate the center of the cell
    mov eax, col
    mov ecx, 95
    mul ecx
    add eax, 235  ; Adjust for better centering
    mov cellX, eax

    mov eax, row
    mul ecx
    add eax, 98  ; Adjust for better centering
    mov cellY, eax

    ; Set text background to transparent
    invoke SetBkMode, hdc, TRANSPARENT

    ; Create a larger font if it does not exist
    .if hFont == 0
        invoke CreateFontA, 40, 0, 0, 0, FW_BOLD, 0, 0, 0, ANSI_CHARSET, OUT_TT_PRECIS, CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH or FF_DONTCARE, OFFSET FontName
        mov hFont, eax
    .endif

    ; Select the font into DC
    invoke SelectObject, hdc, hFont

    ; Display the number
    invoke lstrlenA, ADDR strBuffer
    invoke TextOutA, hdc, cellX, cellY, ADDR strBuffer, eax

    ret
DisplayNumber endp

end