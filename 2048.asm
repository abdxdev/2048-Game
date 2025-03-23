.386
.model flat, stdcall
.stack 4096

include Irvine32.inc
; include SmallWin.inc

.data
    WinScore DD 2048
    Score DD 0
    HighScore DD 0
    Board DD 16 DUP(0)
    msgGameOver DB "Game Over!", 0
    msgYouWon DB "You Won!", 0

.code

init_board PROC
    LOCAL i:DWORD
    mov i, 0
    .while i < lengthof Board
        mov eax, i
        mov DWORD PTR Board[eax*4], 0
        inc i
    .endw

    mov i, 0
    .while i < 2
        mov eax, lengthof Board
        invoke RandomRange
        mov edx, eax
        mov eax, DWORD PTR Board[edx*4]
        .if eax == 0
            mov eax, 2
            invoke RandomRange
            inc eax
            shl eax, 1
            mov DWORD PTR Board[edx*4], eax
            inc i
        .endif
    .endw
    ret
init_board ENDP

display_board PROC
    LOCAL i:DWORD
    mov i, 0
    .while i < lengthof Board
        mov eax, i
        mov eax, DWORD PTR Board[eax*4]
        invoke WriteInt

        mov eax, i
        mov edx, 0
        mov ebx, 4
        div ebx  ; i / 4

        .if edx == 3
            invoke crlf
        .else
            mov eax, ' '
            invoke WriteChar
        .endif

        inc i
    .endw
    ret
display_board ENDP

is_full PROC
    LOCAL i:DWORD
    mov i, 0
    .while i < lengthof Board
        mov eax, i
        mov eax, DWORD PTR Board[eax*4]  ; Corrected the indexing to use 'eax' instead of '*'
        .if eax == 0
            mov eax, 0
            ret
        .endif
        inc i
    .endw
    mov eax, 1
    ret
is_full ENDP

can_move PROC
    LOCAL i:DWORD, j:DWORD, index:DWORD, value:DWORD

    mov i, 0
    .while i < 4
        mov j, 0
        .while j < 4

            mov eax, i
            imul eax, 4
            add eax, j
            imul eax, 4
            mov index, eax

            mov ebx, offset Board
            add ebx, index
            mov eax, DWORD PTR [ebx]
            mov value, eax

            .if value == 0
                mov eax, 1
                ret
            .endif

            .if j > 0 ; Check left
                sub ebx, 4
                mov edx, DWORD PTR [ebx]
                .if value == edx
                    mov eax, 1
                    ret
                .endif
                add ebx, 4
            .endif

            .if j < 3 ; Check right
                add ebx, 4
                mov edx, DWORD PTR [ebx]
                .if value == edx
                    mov eax, 1
                    ret
                .endif
                sub ebx, 4
            .endif

            .if i > 0 ; Check up
                sub ebx, 16
                mov edx, DWORD PTR [ebx]
                .if value == edx
                    mov eax, 1
                    ret
                .endif
                add ebx, 16
            .endif

            .if i < 3 ; Check down
                add ebx, 16
                mov edx, DWORD PTR [ebx]
                .if value == edx
                    mov eax, 1
                    ret
                .endif
                sub ebx, 16
            .endif

            inc j
        .endw
        inc i
    .endw

    mov eax, 0
    ret
can_move ENDP

is_game_over PROC
    invoke is_full
    .if eax == 1
        invoke can_move
        .if eax == 0
            mov eax, 1
            ret
        .endif
    .endif
    mov eax, 0
    ret
is_game_over ENDP

is_won PROC
    LOCAL i:DWORD
    mov i, 0
    .while i < lengthof Board
        mov eax, i
        mov eax, DWORD PTR Board[eax*4]
        .if eax == WinScore
            mov eax, 1
            ret
        .endif
        inc i
    .endw
    mov eax, 0
    ret
is_won ENDP

move PROC, direction:DWORD
    ; TODO: Implement the move logic
    ret
move ENDP

get_user_input PROC
    LOCAL key:DWORD
    mov eax, 0
    invoke ReadChar
    mov key, eax
    and key, 0FFh
    .if key == 'w'
        mov eax, 0
    .elseif key == 'a'
        mov eax, 1
    .elseif key == 's'
        mov eax, 2
    .elseif key == 'd'
        mov eax, 3
    .elseif key == 'q'
        mov eax, -2
    .else
        mov eax, -1
    .endif
    ret
get_user_input ENDP

run PROC
    invoke init_board
    invoke Clrscr
    invoke display_board
    mov eax, -2

    .while TRUE
        invoke get_user_input
        .if eax == -2
            invoke ExitProcess, 0
        .elseif eax != -1
            invoke move, eax
            invoke Clrscr
            invoke display_board
            invoke is_won
            .if eax == 1
                invoke MessageBox, NULL, addr msgYouWon, NULL, MB_OK
                invoke ExitProcess, 0
            .endif
            invoke is_game_over
            .if eax == 1
                invoke MessageBox, NULL, addr msgGameOver, NULL, MB_OK
                invoke ExitProcess, 0
            .endif
        .endif
    .endw
    
run ENDP

END run
