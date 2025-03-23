.386
.model flat,stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD

.data
    ; Define any required data variables here

.code

; Existing ConvertHexColor function
ConvertHexColor PROC
    shl eax, 16      
    and edx, 0FF00h  
    or eax, edx      
    shr edx, 8       
    and ecx, 0FF0000h
    mov ecx, color   
    and ecx, 0FF0000h 
    shr ecx, 16      
    or eax, ecx      ; final format: 0xBBGGRR
    or eax, ecx      ; Combine BBGGRR
    ret
ConvertHexColor ENDP

; -------------------------------
; New Function: Capture Key Input
; -------------------------------
CaptureKeyInput PROC
    LOCAL msg:MSG
    ; Message loop to capture key inputs
KeyLoop:
    invoke GetMessage, ADDR msg, 0, 0, 0
    cmp eax, 0
    je ExitKeyLoop

    cmp msg.message, WM_KEYDOWN
    jne KeyLoop

    mov eax, msg.wParam

    cmp eax, 'W'
    je MoveUp
    cmp eax, 'A'
    je MoveLeft
    cmp eax, 'S'
    je MoveDown
    cmp eax, 'D'
    je MoveRight
    cmp eax, 'Q'
    je QuitGame
    cmp eax, 'R'
    je ResetGame

    jmp KeyLoop

MoveUp:
    ; Handle moving up
    ; Add the required logic here
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

QuitGame:
    ; Handle quitting the game
    invoke ExitProcess, 0

ResetGame:
    ; Handle resetting the game
    jmp KeyLoop

ExitKeyLoop:
    ret
CaptureKeyInput ENDP

end
