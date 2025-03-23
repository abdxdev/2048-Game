.386
.model flat, stdcall
.stack 4096

include Irvine32.inc

.data
    
    WinScore DD 2048

    Score DD 0
    HighScore DD 0
    Board DD 16 DUP(0)

.code

init_board PROC
    pushad
    mov ecx, 0
    .while ecx < lengthof Board
        mov Board[ecx*4], 0
        inc ecx
    .endw

    xor ecx, ecx

    .while ecx < 2
        mov eax, lengthof Board
        invoke RandomRange
        mov edx, eax
        mov ebx, Board[edx*type Board]
        .if ebx == 0
            mov eax, 2
            invoke RandomRange
            inc eax
            shl eax, 1
            mov Board[edx*type Board], eax
            inc ecx
        .endif
    .endw

    popad
    ret

init_board ENDP

display_board PROC
    pushad
    mov ecx, 0
    .while ecx < lengthof Board
        mov eax, Board[ecx*4]
        call WriteInt

        mov eax, ecx
        mov edx, 0
        mov ebx, 4
        div ebx

        .if edx == 3
            call crlf
        .else
            mov eax, ' '
            call WriteChar
        .endif

        inc ecx
    .endw
    popad
    ret

display_board ENDP

main PROC
    call init_board

    call display_board
    invoke ExitProcess, 0
main ENDP
END main
