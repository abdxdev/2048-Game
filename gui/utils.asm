.386
.model flat, stdcall
option casemap:none

include utils.inc

.data
    fmt db "%d", 0  ; Format for integer conversion
    hFont dd 0      ; Font handle
    tickFmt db "Tick Count: %u", 10, 0  ; For Debug

.code
PUBLIC ConvertHexColor

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

PUBLIC GetRandomIndex

GetRandomIndex proc arrSize:DWORD
    INVOKE GetTickCount     ;TickCount stored in eax
    
    push eax
    INVOKE printf, ADDR tickFmt, eax            ;This fkr modifies all gen register values, use with caution, save yourself hours of debugging
    pop eax

    xor edx, edx
    mov ebx, arrSize
    div ebx                 ;Quotient stored in eax, remainder in edx
    ret
GetRandomIndex endp



PUBLIC DrawGrid

DrawGrid proc hdc:DWORD
    LOCAL i:DWORD
    LOCAL x:DWORD
    LOCAL y:DWORD
    LOCAL cellSize:DWORD

    mov cellSize, 100  ; 

    ; Draw vertical lines (5 lines for 4 cells)
    mov i, 0
VLoop:
    cmp i, 5
    jge HLoopStart

    mov eax, i
    mul cellSize
    add eax, 50  ; Adjusted to start at 50
    mov x, eax

    invoke MoveToEx, hdc, x, 50, NULL
    invoke LineTo, hdc, x, 450

    inc i
    jmp VLoop

HLoopStart:
    mov i, 0
HLoop:
    cmp i, 5
    jge Done

    mov eax, i
    mul cellSize
    add eax, 50  ; Adjusted to start at 50
    mov y, eax

    invoke MoveToEx, hdc, 50, y, NULL
    invoke LineTo, hdc, 450, y

    inc i
    jmp HLoop

Done:
    ret
DrawGrid endp

PUBLIC DisplayNumber

DisplayNumber proc hdc:DWORD, cellNo:DWORD, number:DWORD
    LOCAL strBuffer[12]:BYTE  ; Buffer for number string (max 3 digits + null terminator)
    LOCAL cellX:DWORD
    LOCAL cellY:DWORD
    LOCAL row:DWORD
    LOCAL col:DWORD

    ; Convert number to string
    invoke wsprintfA, ADDR strBuffer, ADDR fmt, number

    ; Compute row and column
    mov eax, cellNo
    mov edx, 0
    mov ecx, 4
    div ecx   ; EAX = row, EDX = col

    mov row, eax
    mov col, edx

    ; Calculate the center of the cell
    mov eax, col
    mov ebx, 100
    mul ebx
    add eax, 50  ; Left margin
    add eax, 35  ; Adjust for better centering
    mov cellX, eax

    mov eax, row
    mov ebx, 100
    mul ebx
    add eax, 50  ; Top margin
    add eax, 35  ; Adjust for better centering
    mov cellY, eax

    ; Set text background to transparent
    invoke SetBkMode, hdc, TRANSPARENT

    ; Create a larger font if not already created
    cmp hFont, 0
    jne FontExists
    invoke CreateFontA, 40, 0, 0, 0, FW_BOLD, 0, 0, 0, ANSI_CHARSET, OUT_TT_PRECIS, CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH or FF_DONTCARE, NULL
    mov hFont, eax
FontExists:

    ; Select the font into DC
    invoke SelectObject, hdc, hFont

    ; Display the number
    invoke lstrlenA, ADDR strBuffer
    invoke TextOutA, hdc, cellX, cellY, ADDR strBuffer, eax

    ret
DisplayNumber endp

end
