.386
.model flat, stdcall
.stack 4096

include c:/Irvine/Irvine32.inc

.data
    WinScore DD 2048
    IsWon DD 0
    IsInfiniteMode DD 0
    CurrentScore DD 0
    HighScore DD 0

    BoardSize EQU 4
    Board DD BoardSize*BoardSize DUP(0)
    TempBoard DD BoardSize*BoardSize DUP(0)
    
    msgGameOver DB "Game Over!", 0
    msgYouWon DB "You Won Congrats!", 0

.code

init_board PROC
    LOCAL i:DWORD
    mov i, 0
    .while i < lengthof Board
        mov eax, i
        mov DWORD PTR Board[eax*Type Board], 0
        inc i
    .endw

    mov i, 0
    .while i < 2
        mov eax, lengthof Board
        invoke RandomRange
        mov edx, eax
        mov eax, DWORD PTR Board[edx*Type Board]
        .if eax == 0
            mov eax, 2
            invoke RandomRange
            inc eax
            shl eax, 1
            mov DWORD PTR Board[edx*Type Board], eax
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
        mov eax, DWORD PTR Board[eax*Type Board]
        invoke WriteInt

        mov eax, i
        mov edx, 0
        mov ebx, BoardSize
        div ebx  ; i / BoardSize

        .if edx == BoardSize - 1
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
        mov eax, DWORD PTR Board[eax*Type Board]
        .if eax == 0
            mov eax, 0
            ret
        .endif
        inc i
    .endw
    mov eax, 1
    ret
is_full ENDP

get_index PROC, i:DWORD, j:DWORD
    ; return (i * BoardSize + j) * Type Board
    mov eax, i
    imul eax, BoardSize
    add eax, j
    imul eax, Type Board
    ret
get_index ENDP

get_value PROC, i:DWORD, j:DWORD
    ; return Board[(i * BoardSize + j) * Type Board]
    LOCAL index:DWORD
    invoke get_index, i, j
    mov eax, DWORD PTR Board[eax]
    ret
get_value ENDP

set_value PROC, i:DWORD, j:DWORD, value:DWORD
    ; Board[(i * BoardSize + j) * Type Board] = value
    invoke get_index, i, j
    mov ebx, value
    mov DWORD PTR [Board + eax], ebx
    ret
set_value ENDP

can_move PROC
    LOCAL i:DWORD, j:DWORD, index:DWORD, value:DWORD

    mov i, 0
    .while i < BoardSize
        mov j, 0
        .while j < BoardSize

            invoke get_value, i, j
            mov value, eax

            .if value == 0
                mov eax, 1
                ret
            .endif

            ; Check right
            .if j < BoardSize - 1
                mov edx, j
                inc edx
                invoke get_value, i, edx
                .if value == eax
                    mov eax, 1
                    ret
                .endif
            .endif

            ; Check down
            .if i < BoardSize - 1
                mov edx, i
                inc edx
                invoke get_value, edx, j
                .if value == eax
                    mov eax, 1
                    ret
                .endif
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
        mov eax, DWORD PTR Board[eax*Type Board]
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
    LOCAL i:DWORD, j:DWORD, index:DWORD, value:DWORD, k:DWORD, l:DWORD, moved:DWORD
    mov moved, 0
    
    .if direction == 0 ; Up
        mov j, 0
        .while j < BoardSize
            mov i, 1
            .while i < BoardSize

                invoke get_value, i, j
                .if eax == 0
                    inc i
                    .continue
                .endif
            
                mov eax, i
                mov k, eax 
                .while k > 0
                    mov edx, k
                    dec edx
                    invoke get_value, edx, j
                    .break .if eax != 0
                    invoke get_value, k, j
                    invoke set_value, edx, j, eax
                    invoke set_value, k, j, 0
                    mov moved, 1
                    dec k
                .endw
            
                invoke get_value, k, j
                mov ebx, eax
                mov edx, k
                dec edx
                invoke get_value, edx, j
                .if k > 0 && ebx == eax
                    shl eax, 1
                    invoke set_value, edx, j, eax
                    add CurrentScore, eax
                    invoke set_value, k, j, 0
                    mov moved, 1
                .endif
            
                inc i
            .endw
            inc j
        .endw
    .elseif direction == 1 ; Left
        mov i, 0
        .while i < BoardSize
            mov j, 1
            .while j < BoardSize

                invoke get_value, i, j
                .if eax == 0
                    inc j
                    .continue
                .endif
            
                mov eax, j
                mov k, eax
                .while k > 0
                    mov edx, k
                    dec edx
                    invoke get_value, i, edx
                    .break .if eax != 0
                    invoke get_value, i, k
                    invoke set_value, i, edx, eax
                    invoke set_value, i, k, 0
                    mov moved, 1
                    dec k
                .endw
            
                invoke get_value, i, k
                mov ebx, eax
                mov edx, k
                dec edx
                invoke get_value, i, edx
                .if k > 0 && ebx == eax
                    shl eax, 1
                    invoke set_value, i, edx, eax
                    add CurrentScore, eax
                    invoke set_value, i, k, 0
                    mov moved, 1
                .endif
            
                inc j
            .endw
            inc i
        .endw
    .elseif direction == 2 ; Down
        mov j, 0
        .while j < BoardSize
            mov ecx, BoardSize
            sub ecx, 2
            mov i, ecx
            .while i >= 0
                
                invoke get_value, i, j
                .if eax == 0
                    .if i == 0
                        .break
                    .endif
                    dec i
                    .continue
                .endif
                
                mov eax, i
                mov k, eax
                .while k < BoardSize - 1
                    mov edx, k
                    inc edx
                    invoke get_value, edx, j
                    .break .if eax != 0
                    invoke get_value, k, j
                    invoke set_value, edx, j, eax
                    invoke set_value, k, j, 0
                    mov moved, 1
                    inc k
                .endw
                
                invoke get_value, k, j
                mov ebx, eax
                mov edx, k
                inc edx
                invoke get_value, edx, j
                .if k < BoardSize - 1 && ebx == eax
                    shl eax, 1
                    invoke set_value, edx, j, eax
                    add CurrentScore, eax
                    invoke set_value, k, j, 0
                    mov moved, 1
                .endif
                
                .if i == 0
                    .break
                .endif
                dec i
            .endw
            inc j
        .endw
    .elseif direction == 3 ; Right
        mov i, 0
        .while i < BoardSize
            mov ecx, BoardSize
            sub ecx, 2
            mov j, ecx
            .while j >= 0
                
                invoke get_value, i, j
                .if eax == 0
                    .if j == 0
                        .break
                    .endif
                    dec j
                    .continue
                .endif
                
                mov eax, j
                mov k, eax
                .while k < BoardSize - 1
                    mov edx, k
                    inc edx
                    invoke get_value, i, edx
                    .break .if eax != 0
                    invoke get_value, i, k
                    invoke set_value, i, edx, eax
                    invoke set_value, i, k, 0
                    mov moved, 1
                    inc k
                .endw
                
                invoke get_value, i, k
                mov ebx, eax
                mov edx, k
                inc edx
                invoke get_value, i, edx
                .if k < BoardSize - 1 && ebx == eax
                    shl eax, 1
                    invoke set_value, i, edx, eax
                    add CurrentScore, eax
                    invoke set_value, i, k, 0
                    mov moved, 1
                .endif
                .if j == 0
                    .break
                .endif
                dec j
            .endw
            inc i
        .endw
    .endif

    .if moved == 1
        mov eax, lengthof Board
        invoke RandomRange
        .while Board[eax*Type Board] != 0
            mov eax, lengthof Board
            invoke RandomRange
        .endw
        mov edx, eax
        mov eax, 2
        invoke RandomRange
        inc eax
        shl eax, 1
        mov DWORD PTR Board[edx*Type Board], eax
        mov eax, 1
    .else
        mov eax, 0
    .endif
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
        .elseif eax == -1
            .continue
        .endif
        
        invoke move, eax
        .continue .if eax != 1

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
    .endw
    
run ENDP

END run
