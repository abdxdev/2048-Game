.386
.model flat,stdcall
.stack 4096

.data
    ; Define any required data variables here

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
end

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

end