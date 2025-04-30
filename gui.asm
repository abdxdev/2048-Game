.386
.model flat, stdcall
option casemap:none

include C:\masm32\include\windows.inc
include C:\masm32\include\kernel32.inc
include C:\masm32\include\user32.inc
include C:\masm32\include\gdi32.inc

includelib C:\masm32\lib\kernel32.lib
includelib C:\masm32\lib\user32.lib
includelib C:\masm32\lib\gdi32.lib

printf PROTO C :dword, :vararg

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>> Data Movement 
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
.data

;Variables
hInstance dd ?
hWinMain dd ?

;Number Format
szNumFormat byte "%d", 0

randomSeed dd 0
score dd 0
bestScore dd 0
reached2048 dd 0
infiniteMode dd 0
gameEnd dd 0

movedUp dd 0
movedDown dd 0
movedLeft dd 0
movedRight dd 0

numMat dd 16 dup(?)
numMatCopy dd 16 dup(?)
flag dd 4 dup(?)

isUpPressed db 0
isDownPressed db 0
isLeftPressed db 0
isRightPressed db 0

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>> Formatting 
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
FONT_CELL_NUM dd ?
FONT_TITLE dd ?
FONT_SCORE_TXT dd ?
FONT_SCORE_NUM dd ?
FONT_RESTART dd ?
FONT_INTRO_TITLE dd ?
FONT_INTRO_TXT dd ?
FONT_CELL_NUM_10 dd ?
FONT_CELL_NUM_100 dd ?
FONT_CELL_NUM_1000 dd ?
FONT_CELL_NUM_10000 dd ?

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>> Redraw Mode of Separator 
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
BRUSH_CELL_0 dd ?
BRUSH_CELL_2 dd ?
BRUSH_CELL_4 dd ?
BRUSH_CELL_8 dd ?
BRUSH_CELL_16 dd ?
BRUSH_CELL_32 dd ?
BRUSH_CELL_64 dd ?
BRUSH_CELL_128 dd ?
BRUSH_CELL_256 dd ?
BRUSH_CELL_512 dd ?
BRUSH_CELL_1024 dd ?
BRUSH_CELL_2048 dd ?

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>> Color Settings 
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
COLOR_WINDOW_BG equ 0faf8efh
COLOR_MATRIX_BG equ 0bbada0h

COLOR_TITLE_TXT equ 0776e65h
COLOR_SCORE_TXT equ 0ffffffh
COLOR_SCORE_BG equ 0bbada0h
COLOR_SCORE_NUM equ 0ffffffh

COLOR_BUTTON_TXT equ 0ffffffh

COLOR_INTRO_TITLE equ 0ffffffh
COLOR_INTRO_TXT equ 0ffffffh

COLOR_NUM0_BG equ 0cdc1b4h
COLOR_NUM2_BG equ 0eee4dah
COLOR_NUM4_BG equ 0ede0c8h
COLOR_NUM8_BG equ 0f2b179h
COLOR_NUM16_BG equ 0f59563h
COLOR_NUM32_BG equ 0f67c5fh
COLOR_NUM64_BG equ 0f65e3bh
COLOR_NUM128_BG equ 0edcf72h
COLOR_NUM256_BG equ 0edcc61h
COLOR_NUM512_BG equ 0edc850h
COLOR_NUM1024_BG equ 0edc53fh
COLOR_NUM2048_BG equ 0edc22eh

COLOR_NUM_DARK equ 0656e77h
COLOR_NUM_LIGHT equ 0f2f6f9h

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>> Control Size and Position 
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Size information
; Window size
WINDOW_WIDTH equ 1000
WINDOW_HEIGHT equ 660
; Block size
WIDGET_MARGIN_SMALL equ 20
WIDGET_MARGIN_LARGE equ 40
; Number matrix size
WIDGET_MAT_EDGE equ 580
; Character size
WIDGET_CELL_EDGE equ 107
; Border width
WIDGET_TEXT_WIDTH equ 320
; Spacing width
WIDGET_SCORE_WIDTH equ 150
; Height
WIDGET_TITLE_HEIGHT equ 100
WIDGET_SCORE_HEIGHT equ 75
WIDGET_RESTART_HEIGHT equ 50
WIDGET_INTRO_HEIGHT equ 235

; Widget position information
; Number matrix position
WIDGET_MAT_START_XY equ 20
WIDGET_MAT_END_XY equ 600
; Score position
WIDGET_TITLE_START_X equ 640
WIDGET_TITLE_START_Y equ 20
WIDGET_TITLE_END_X equ 960
WIDGET_TITLE_END_Y equ 120
; Button position
WIDGET_SCORE_START_Y equ 160
WIDGET_SCORE_END_Y equ 235
WIDGET_CURRENT_SCORE_END_X equ 790
WIDGET_MAX_SCORE_START_X equ 810
; Restart button
WIDGET_RE_START_Y equ 275
WIDGET_RE_END_Y equ 325
; Game instructions
WIDGET_INTRO_START_Y equ 365
WIDGET_INTRO_END_Y equ 600

; Text position information
; Text position
TXT_TITLE_START_X equ 720
TXT_TITLE_START_Y equ 30
; Button text position
TXT_CURRENT_SCORE_TXT_START_X equ 643
TXT_MAX_SCORE_TXT_START_X equ 813
TXT_SCORE_TXT_START_Y equ 162
TXT_CURRENT_SCORE_NUM_START_X equ 700
TXT_MAX_SCORE_NUM_START_X equ 870
TXT_SCORE_NUM_START_Y equ 202
; Restart button text position
TXT_RE_START_X equ 640
TXT_RE_START_Y equ 280
; Game instructions
TXT_INTRO_TITLE_START_X equ 740
TXT_INTRO_TITLE_START_Y equ 370
TXT_INTRO_INFO_START_X equ 745
TXT_INTRO_INFO_START_Yw equ 425
TXT_INTRO_INFO_START_Ya equ 465
TXT_INTRO_INFO_START_Ys equ 505
TXT_INTRO_INFO_START_Yd equ 545
; Text offset
OFFSET_CELL_10_X equ 37
OFFSET_CELL_10_Y equ 18
OFFSET_CELL_100_X equ 21
OFFSET_CELL_100_Y equ 18
OFFSET_CELL_1000_X equ 13
OFFSET_CELL_1000_Y equ 24
OFFSET_CELL_10000_X equ 12
OFFSET_CELL_10000_Y equ 31
; Text size
SIZE_CELL_10 equ 100
SIZE_CELL_100 equ 72
SIZE_CELL_1000 equ 58
SIZE_CELL_10000 equ 48



;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>> Display Text 
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
szClassName db "MainWindowClass", 0
szTitleMain db "Game 2048", 0
szFontName byte "JetBrains Mono", 0

TXT_TITLE byte "2048", 0
TXT_CURRENT_SCORE byte "Score", 0
TXT_BEST_SCORE byte "Best", 0
TXT_INTRO_TITLE byte "Instructions", 0
TXT_INTRO_TXTw byte "W: Move Up", 0
TXT_INTRO_TXTa byte "A: Move Left", 0
TXT_INTRO_TXTs byte "S: Move Down", 0
TXT_INTRO_TXTd byte "D: Move Right", 0

MSG_WIN_TITLE byte "Game Won", 0
MSG_WIN byte "You have reached 2048!", 0
MSG_CONTINUE byte "Do you want to continue? (Switching to infinite mode)", 0
MSG_GAME_OVER_TITLE byte "Game Over", 0
MSG_GAME_OVER_TXT byte "No more moves available. Game over.", 0

TXT_BUTTON_RESTART byte "Restart", 0

BITMAP1 EQU 101
BITMAP2 EQU 104
lcgMaxNum EQU 16

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>> Memory Allocation 
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
.code

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>> Merge Adjacent Blocks 
;>> Synchronize Data and Position Values 
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
randomLCG proc
    local lcg_a, lcg_c, randNum, randPos

    pusha ; Save registers
    mov eax, randomSeed ; Initialize seed

    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ;>> LCG Random Number Generation 
    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    mov lcg_a, 0343fdh
    mov lcg_c, 269ec3h

    lcg:
        ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        ;>> Random Position Generation 
        ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        mul lcg_a
        add eax, lcg_c
        xor edx, edx
        mov ebx, lcgMaxNum
        div ebx
        mov eax, edx
        mov randPos, eax ; Random position

        ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        ;>> Check if Position is Empty 
        ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        mov eax, randPos
        .if numMat[eax * 4] != 0
            jmp lcg
        .endif

        ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        ;>> Generate Value 2 or 4 
        ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        mul lcg_a ; Another iteration of random generation
        add eax, lcg_c
        xor edx, edx
        mov ebx, lcgMaxNum
        div ebx
        mov eax, edx
        xor edx, edx
        mov ebx, 2
        div ebx
        .if edx
            mov randNum, 2
        .else 
            mov randNum, 4
        .endif

        ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        ;>> Generate Random Flag 
        ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        mov eax, randPos
        mov edx, randNum
        mov numMat[eax * 4], edx
        mov randomSeed, eax

    popa ; Restore registers
    ret
randomLCG Endp

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>> Move According to Current Position 
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
updateBestScore proc
    pushad
    mov eax, score
    .if bestScore < eax
        mov bestScore, eax
    .endif
    popad
    ret
updateBestScore endp

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>> Update and Calculate Score
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
updateScore proc
    pushad
    mov eax, 0
    mov score, 0
    mov edi, 0

    ;Calculate the maximum value in the game grid
    mov ecx, 0
    .while ecx < 16
        mov esi, numMat[ecx*4]
        .if esi > edi
            mov edi, esi
        .endif
        inc ecx
    .endw

    ;Determine if victory condition is reached
    .if edi == 2048
        mov reached2048, 1
    .endif
    mov score, edi

    popad
    ret
updateScore endp

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>> Move Up 
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
moveUp proc
    local col, row, changed, r
    local currentNum, tmpNum, targetRow
    pushad ; Save registers
    mov changed, 0
    mov movedUp, 0
    mov col, 0
    .while col < 4
        ;Initialize flag array
        xor eax, eax
        mov flag[0], eax
        mov flag[4], eax
        mov flag[8], eax
        mov flag[12], eax
        mov row, 1
        .while row < 4
            ;Get current position value
            mov eax, row
            mov ebx, col
            shl eax, 2
            add eax, ebx
            mov edi, numMat[eax*4]
            mov currentNum, edi
            ;Set targetRow to current row
            mov edi, row
            mov targetRow, edi
            ;r = row - 1
            dec edi
            mov r, edi
            .while r >= 0 && currentNum != 0
                ;tmpNum = numMat[r][col]
                mov eax, r
                mov ebx, col
                shl eax, 2
                add eax, ebx
                mov edi, numMat[eax*4]
                mov tmpNum, edi
                mov ecx, currentNum
                mov edi, r
                .if tmpNum == 0
                    ;numMat[r][col] = currentNum;
                    mov eax, r
                    mov ebx, col
                    shl eax, 2
                    add eax, ebx
                    mov ecx, currentNum
                    mov numMat[eax*4], ecx
                    ;numMat[targetRow][col] = 0;
                    mov eax, targetRow
                    mov ebx, col
                    shl eax, 2
                    add eax, ebx
                    mov ecx, 0
                    mov numMat[eax*4], ecx
                    ;targetRow = r;
                    mov ecx, r
                    mov targetRow, ecx
                    ;changed = 1;
                    mov changed, 1
                .elseif tmpNum == ecx && flag[edi*4] == 0
                    ;numMat[r][col] = currentNum * 2;
                    mov eax, r
                    mov ebx, col
                    shl eax, 2
                    add eax, ebx
                    mov ecx, currentNum
                    shl ecx, 1
                    mov numMat[eax*4], ecx
                    ;numMat[targetRow][col] = 0;
                    mov eax, targetRow
                    mov ebx, col
                    shl eax, 2
                    add eax, ebx
                    mov ecx, 0
                    mov numMat[eax*4], ecx
                    ;flag[r] = 1;
                    mov edi, r
                    mov flag[edi*4], 1
                    ;changed = 1;
                    mov changed, 1
                .break
                .else
                .break
                .endif
                .if r == 0
                .break
                .endif
                dec r
            .endw
            inc row
        .endw
        inc col
    .endw
    .if changed == 1
        mov movedUp, 1
    .endif
    popad ; Restore registers
    ret
moveUp endp

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>> Move Down 
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
moveDown proc
    local col, row, changed, r
    local currentNum, tmpNum, targetRow
    pushad ; Save registers

    mov changed, 0
    mov movedDown, 0
    mov col, 0
    .while col < 4
        ;Initialize flag array
        xor eax, eax
        mov flag[0], eax
        mov flag[4], eax
        mov flag[8], eax
        mov flag[12], eax
        
        mov row, 2
        .while row >= 0
            ;Get current position value
            mov eax, row
            mov ebx, col
            shl eax, 2
            add eax, ebx
            mov edi, numMat[eax*4]
            mov currentNum, edi
            
            ;Set targetRow to current row
            mov edi, row
            mov targetRow, edi
            
            ;r = row + 1
            inc edi
            mov r, edi
            
            .while r < 4 && currentNum != 0
                ;Get value at position r,col
                mov eax, r
                mov ebx, col
                shl eax, 2
                add eax, ebx
                mov edi, numMat[eax*4]
                mov tmpNum, edi
                mov ecx, currentNum
                mov edi, r
                
                .if tmpNum == 0
                    ;Move number down to empty cell
                    mov eax, r
                    mov ebx, col
                    shl eax, 2
                    add eax, ebx
                    mov ecx, currentNum
                    mov numMat[eax*4], ecx
                    
                    ;Clear original cell
                    mov eax, targetRow
                    mov ebx, col
                    shl eax, 2
                    add eax, ebx
                    mov ecx, 0
                    mov numMat[eax*4], ecx
                    
                    ;Update target row
                    mov ecx, r
                    mov targetRow, ecx
                    
                    ;Mark as changed
                    mov changed, 1
                .elseif tmpNum == ecx && flag[edi*4] == 0
                    ;Merge identical numbers
                    mov eax, r
                    mov ebx, col
                    shl eax, 2
                    add eax, ebx
                    mov ecx, currentNum
                    shl ecx, 1
                    mov numMat[eax*4], ecx
                    
                    ;Clear original cell
                    mov eax, targetRow
                    mov ebx, col
                    shl eax, 2
                    add eax, ebx
                    mov ecx, 0
                    mov numMat[eax*4], ecx
                    
                    ;Mark cell as merged
                    mov edi, r
                    mov flag[edi*4], 1
                    
                    ;Mark as changed
                    mov changed, 1
                .break
                .else
                .break
                .endif
                inc r
            .endw
            .if row == 0
            .break
            .endif
            dec row
        .endw
        inc col
    .endw

    .if changed == 1
        mov movedDown, 1
    .endif

    popad ; Restore registers
    ret
moveDown endp

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>> Move Left 
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
moveLeft proc
    local col, row, changed, co
    local currentNum, tmpNum, targetCol
    pushad ;Save registers
    mov changed, 0
    mov movedLeft, 0
    mov row, 0
    .while row < 4
        ;Initialize flag array
        xor eax, eax
        mov flag[0], eax
        mov flag[4], eax
        mov flag[8], eax
        mov flag[12], eax
        mov col, 1
        .while col < 4
            ;Get current position value
            mov eax, row
            mov ebx, col
            shl eax, 2
            add eax, ebx
            mov edi, numMat[eax*4]
            mov currentNum, edi
            ;Set targetCol to current col
            mov edi, col
            mov targetCol, edi
            ;co = col - 1
            dec edi
            mov co, edi
            .while co >= 0 && currentNum != 0
                ;tmpNum = numMat[row][co]
                mov eax, row
                mov ebx, co
                shl eax, 2
                add eax, ebx
                mov edi, numMat[eax*4]
                mov tmpNum, edi
                mov ecx, currentNum
                mov edi, co
                .if tmpNum == 0
                    ;numMat[row][co] = currentNum;
                    mov eax, row
                    mov ebx, co
                    shl eax, 2
                    add eax, ebx
                    mov ecx, currentNum
                    mov numMat[eax*4], ecx
                    ;numMat[row][targetCol] = 0;
                    mov eax, row
                    mov ebx, targetCol
                    shl eax, 2
                    add eax, ebx
                    mov ecx, 0
                    mov numMat[eax*4], ecx
                    ;targetCol = co;
                    mov ecx, co
                    mov targetCol, ecx
                    ;changed = 1;
                    mov changed, 1
                .elseif tmpNum == ecx && flag[edi*4] == 0
                    ;numMat[row][co] = currentNum* 2;
                    mov eax, row
                    mov ebx, co
                    shl eax, 2
                    add eax, ebx
                    mov ecx, currentNum
                    shl ecx, 1
                    mov numMat[eax*4], ecx
                    ;numMat[row][targetCol] = 0;
                    mov eax, row
                    mov ebx, targetCol
                    shl eax, 2
                    add eax, ebx
                    mov ecx, 0
                    mov numMat[eax*4], ecx
                    ;flag[co] = 1;
                    mov edi, co
                    mov flag[edi*4], 1
                    ;changed = 1;
                    mov changed, 1
                .break
                .else
                .break
                .endif
                .if co == 0
                .break
                .endif
                dec co
            .endw
            inc col
        .endw
        inc row
    .endw
    .if changed == 1
        mov movedLeft, 1
    .endif
    popad ;Restore registers
    ret
moveLeft endp

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>> Move Right 
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
moveRight proc
    local col, row, changed, co
    local currentNum, tmpNum, targetCol
    pushad ;Save registers
    mov changed, 0
    mov movedRight, 0
    mov row, 0
    .while row < 4
        ;Initialize flag array
        xor eax, eax
        mov flag[0], eax
        mov flag[4], eax
        mov flag[8], eax
        mov flag[12], eax
        mov col, 2
        .while col >= 0
            ;Get current position value
            mov eax, row
            mov ebx, col
            shl eax, 2
            add eax, ebx
            mov edi, numMat[eax*4]
            mov currentNum, edi
            ;Set targetCol to current col
            mov edi, col
            mov targetCol, edi
            ;co = col + 1
            inc edi
            mov co, edi
            .while co < 4 && currentNum != 0
                ;tmpNum = numMat[row][co]
                mov eax, row
                mov ebx, co
                shl eax, 2
                add eax, ebx
                mov edi, numMat[eax*4]
                mov tmpNum, edi
                mov ecx, currentNum
                mov edi, co
                .if tmpNum == 0
                    ;numMat[row][co] = currentNum;
                    mov eax, row
                    mov ebx, co
                    shl eax, 2
                    add eax, ebx
                    mov ecx, currentNum
                    mov numMat[eax*4], ecx
                    ;numMat[row][targetCol] = 0;
                    mov eax, row
                    mov ebx, targetCol
                    shl eax, 2
                    add eax, ebx
                    mov ecx, 0
                    mov numMat[eax*4], ecx
                    ;targetCol = co;
                    mov ecx, co
                    mov targetCol, ecx
                    ;changed = 1;
                    mov changed, 1
                .elseif tmpNum == ecx && flag[edi*4] == 0
                    ;numMat[row][co] = currentNum* 2;
                    mov eax, row
                    mov ebx, co
                    shl eax, 2
                    add eax, ebx
                    mov ecx, currentNum
                    shl ecx, 1
                    mov numMat[eax*4], ecx
                    ;numMat[row][targetCol] = 0;
                    mov eax, row
                    mov ebx, targetCol
                    shl eax, 2
                    add eax, ebx
                    mov ecx, 0
                    mov numMat[eax*4], ecx
                    ;flag[co] = 1;
                    mov edi, co
                    mov flag[edi*4], 1
                    ;changed = 1;
                    mov changed, 1
                .break
                .else
                .break
                .endif
                inc co
            .endw
            .if col == 0
            .break
            .endif
            dec col
        .endw
        inc row
    .endw
    .if changed == 1
        mov movedRight, 1
    .endif
    popad ;Restore registers
    ret
moveRight endp

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>> Check if Movement is Possible 
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
canMove proc
    pushad ;Save registers
    ; Backup numMat
    mov ecx, 0
    .while ecx < 16
        mov esi, numMat[ecx*4]
        mov numMatCopy[ecx*4], esi
        inc ecx
    .endw

    ; Move operation 
    invoke moveUp
    ; Restore numMat 
    mov ecx, 0
    .while ecx < 16
        mov esi, numMatCopy[ecx*4]
        mov numMat[ecx*4], esi
        inc ecx
    .endw

    ; Move operation 
    invoke moveDown
    ; Restore numMat 
    mov ecx, 0
    .while ecx < 16
        mov esi, numMatCopy[ecx*4]
        mov numMat[ecx*4], esi
        inc ecx
    .endw

    ; Move operation 
    invoke moveLeft
    ; Restore numMat 
    mov ecx, 0
    .while ecx < 16
        mov esi, numMatCopy[ecx*4]
        mov numMat[ecx*4], esi
        inc ecx
    .endw

    ; Move operation 
    invoke moveRight
    ; Restore numMat 
    mov ecx, 0
    .while ecx < 16
        mov esi, numMatCopy[ecx*4]
        mov numMat[ecx*4], esi
        inc ecx
    .endw

    .if movedUp || movedDown || movedLeft || movedRight
        mov gameEnd, 0
    .else
        mov gameEnd, 1
    .endif

    popad ; Restore registers
    ret
canMove endp

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>> Display New Block 
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
updateGameWnd proc, hWnd, hDc
    local len
    local szBuffer[10]: byte
    local tmpHandler, _hDc, _cptBmp

    local cellStartX, cellEndX, cellStartY, cellEndY
    local numStartX, numStartY
    local i, j, currentNum

    pushad ; Restore registers

    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ;>> Update Merged Block Bitmap 
    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    invoke CreateCompatibleDC, hDc
    mov _hDc, eax
    invoke CreateCompatibleBitmap, hDc, WINDOW_WIDTH, WINDOW_HEIGHT
    mov _cptBmp, eax
    invoke SelectObject, _hDc, _cptBmp ; Select _cptBmp as the drawing object for _hDc 

    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ;>> Record Merge Process 
    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ; Clear refresh 
    invoke CreateSolidBrush, COLOR_WINDOW_BG
    ; Clear selection 
    mov tmpHandler, eax
    ; Select refresh 
    invoke SelectObject, _hDc, eax
    ; Copy the merged content 
    invoke Rectangle, _hDc, -10, -10, WINDOW_WIDTH, WINDOW_HEIGHT
    ; Delete refresh object 
    invoke DeleteObject, tmpHandler

    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ;>> Store 4×4 Grid Status 
    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    invoke GetStockObject, NULL_PEN
    invoke SelectObject, _hDc, eax
    invoke CreateSolidBrush, COLOR_MATRIX_BG
    mov tmpHandler, eax
    invoke SelectObject, _hDc, eax
    invoke RoundRect, _hDc, WIDGET_MAT_START_XY, WIDGET_MAT_START_XY,WIDGET_MAT_END_XY, WIDGET_MAT_END_XY, 6, 6
    invoke SetBkMode, _hDc, TRANSPARENT

    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ;>> No Available Moves Left 
    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ; Game over 
    invoke RoundRect, _hDc, WIDGET_TITLE_START_X, WIDGET_TITLE_START_Y,WIDGET_TITLE_END_X, WIDGET_TITLE_END_Y, 3, 3
    ; Current score label 
    invoke RoundRect, _hDc, WIDGET_TITLE_START_X, WIDGET_SCORE_START_Y,WIDGET_CURRENT_SCORE_END_X, WIDGET_SCORE_END_Y, 3, 3
    ; High score label 
    invoke RoundRect, _hDc, WIDGET_MAX_SCORE_START_X, WIDGET_SCORE_START_Y,WIDGET_TITLE_END_X, WIDGET_SCORE_END_Y, 3, 3
    ; Game instructions 
    invoke RoundRect, _hDc, WIDGET_TITLE_START_X, WIDGET_INTRO_START_Y,WIDGET_TITLE_END_X, WIDGET_INTRO_END_Y, 3, 3
    ; Restart button 
    invoke RoundRect, _hDc, WIDGET_TITLE_START_X, WIDGET_RE_START_Y, WIDGET_TITLE_END_X, WIDGET_RE_END_Y, 3, 3 
    invoke DeleteObject, tmpHandler

    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ;>> No More Moves Available 
    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ; Game over 
    invoke SelectObject, _hDc, FONT_TITLE
    invoke SetTextColor, _hDc, COLOR_TITLE_TXT
    invoke TextOut, _hDc, TXT_TITLE_START_X, TXT_TITLE_START_Y,addr TXT_TITLE, lengthof TXT_TITLE
    ; Current score display 
    invoke SelectObject, _hDc, FONT_SCORE_TXT
    invoke SetTextColor, _hDc, COLOR_SCORE_TXT
    invoke TextOut, _hDc, TXT_CURRENT_SCORE_TXT_START_X, TXT_SCORE_TXT_START_Y,addr TXT_CURRENT_SCORE, lengthof TXT_CURRENT_SCORE
    ; Current score value 
    invoke updateScore ; Update current score 
    invoke wsprintf, addr szBuffer, addr szNumFormat, score
    mov len, eax ; Record score 
    invoke SelectObject, _hDc, FONT_SCORE_NUM
    invoke SetTextColor, _hDc, COLOR_SCORE_NUM
    invoke TextOut, _hDc, TXT_CURRENT_SCORE_NUM_START_X, TXT_SCORE_NUM_START_Y,addr szBuffer, len
    ; High score display 
    invoke SelectObject, _hDc, FONT_SCORE_TXT
    invoke SetTextColor, _hDc, COLOR_SCORE_TXT
    invoke TextOut, _hDc, TXT_MAX_SCORE_TXT_START_X, TXT_SCORE_TXT_START_Y,addr TXT_BEST_SCORE, lengthof TXT_BEST_SCORE
    ; High score value 
    invoke updateBestScore ; Update high score 
    invoke wsprintf, addr szBuffer, addr szNumFormat, bestScore
    mov len, eax
    invoke SelectObject, _hDc, FONT_SCORE_NUM
    invoke SetTextColor, _hDc, COLOR_SCORE_NUM
    invoke TextOut, _hDc, TXT_MAX_SCORE_NUM_START_X, TXT_SCORE_NUM_START_Y,addr szBuffer, len
    ; Restart button operation 
    ; invoke SelectObject, _hDc, FONT_RESTART 
    ; invoke SetTextColor, _hDc, COLOR_BUTTON_TXT 
    ; invoke TextOut, _hDc, TXT_RE_START_X, TXT_RE_START_Y, addr TXT_BUTTON_RESTART, lengthof TXT_BUTTON_RESTART 
    ; Operation prompt message w 
    invoke SelectObject, _hDc, FONT_SCORE_NUM
    invoke SetTextColor, _hDc, COLOR_INTRO_TITLE
    invoke TextOut, _hDc, TXT_INTRO_TITLE_START_X, TXT_INTRO_TITLE_START_Y,addr TXT_INTRO_TITLE, lengthof TXT_INTRO_TITLE
    ; Operation prompt message w 
    invoke SelectObject, _hDc, FONT_INTRO_TXT
    invoke SetTextColor, _hDc, COLOR_INTRO_TXT
    invoke TextOut, _hDc, TXT_INTRO_INFO_START_X, TXT_INTRO_INFO_START_Yw,addr TXT_INTRO_TXTw, lengthof TXT_INTRO_TXTw
    ; Operation prompt message a 
    invoke SelectObject, _hDc, FONT_INTRO_TXT
    invoke SetTextColor, _hDc, COLOR_INTRO_TXT
    invoke TextOut, _hDc, TXT_INTRO_INFO_START_X, TXT_INTRO_INFO_START_Ya,addr TXT_INTRO_TXTa, lengthof TXT_INTRO_TXTa
    ; Operation prompt message s 
    invoke SelectObject, _hDc, FONT_INTRO_TXT
    invoke SetTextColor, _hDc, COLOR_INTRO_TXT
    invoke TextOut, _hDc, TXT_INTRO_INFO_START_X, TXT_INTRO_INFO_START_Ys,addr TXT_INTRO_TXTs, lengthof TXT_INTRO_TXTs
    ; Operation prompt message d 
    invoke SelectObject, _hDc, FONT_INTRO_TXT
    invoke SetTextColor, _hDc, COLOR_INTRO_TXT
    invoke TextOut, _hDc, TXT_INTRO_INFO_START_X, TXT_INTRO_INFO_START_Yd,addr TXT_INTRO_TXTd, lengthof TXT_INTRO_TXTd

    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ;>> Generate Random Element 
    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ; Random position 
    mov eax, WIDGET_MAT_START_XY
    add eax, WIDGET_MARGIN_SMALL
    mov cellStartY, eax
    add eax, WIDGET_CELL_EDGE
    mov cellEndY, eax

    ; Loop counter 
    mov i, 0
    .while i < 4
        mov j, 0
        mov eax, WIDGET_MAT_START_XY
        add eax, WIDGET_MARGIN_SMALL
        mov cellStartX, eax
        add eax, WIDGET_CELL_EDGE
        mov cellEndX, eax
        .while j < 4
            ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
            ;>> Calculate Current Score 
            ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
            pushad
            mov eax, i
            shl eax, 2
            add eax, j
            mov ecx, numMat[eax*4]
            mov currentNum, ecx

            ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
            ;>> Draw Blocks 
            ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
            ; Create and select refresh 
            .if currentNum == 0
                invoke SelectObject, _hDc, BRUSH_CELL_0
            .elseif currentNum == 2
                invoke SelectObject, _hDc, BRUSH_CELL_2
            .elseif currentNum == 4
                invoke SelectObject, _hDc, BRUSH_CELL_4
            .elseif currentNum == 8
                invoke SelectObject, _hDc, BRUSH_CELL_8
            .elseif currentNum == 16
                invoke SelectObject, _hDc, BRUSH_CELL_16
            .elseif currentNum == 32
                invoke SelectObject, _hDc, BRUSH_CELL_32
            .elseif currentNum == 64
                invoke SelectObject, _hDc, BRUSH_CELL_64
            .elseif currentNum == 128
                invoke SelectObject, _hDc, BRUSH_CELL_128
            .elseif currentNum == 256
                invoke SelectObject, _hDc, BRUSH_CELL_256
            .elseif currentNum == 512
                invoke SelectObject, _hDc, BRUSH_CELL_512
            .elseif currentNum == 1024
                invoke SelectObject, _hDc, BRUSH_CELL_1024
            .else
                invoke SelectObject, _hDc, BRUSH_CELL_2048
            .endif
            ; Copy matrix 
            invoke RoundRect, _hDc, cellStartX, cellStartY, cellEndX, cellEndY, 3, 3

            ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
            ;>> Update Display 
            ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
            ; When value is 0, skip drawing 
            .if currentNum == 0
                jmp L1
            .endif
            ; Set number color 
            .if currentNum > 8
                invoke SetTextColor, _hDc, COLOR_NUM_DARK
            .else
                invoke SetTextColor, _hDc, COLOR_NUM_LIGHT
            .endif
            ; Determine number's drawing position and size 
            mov eax, cellStartX
            mov numStartX, eax
            mov eax, cellStartY
            mov numStartY, eax
            .if currentNum < 10
                invoke SelectObject, _hDc, FONT_CELL_NUM_10
                add numStartX, OFFSET_CELL_10_X
                add numStartY, OFFSET_CELL_10_Y
            .elseif currentNum < 100
                invoke SelectObject, _hDc, FONT_CELL_NUM_100
                add numStartX, OFFSET_CELL_100_X
                add numStartY, OFFSET_CELL_100_Y
            .elseif currentNum < 1000
                invoke SelectObject, _hDc, FONT_CELL_NUM_1000
                add numStartX, OFFSET_CELL_1000_X
                add numStartY, OFFSET_CELL_1000_Y
            .else
                invoke SelectObject, _hDc, FONT_CELL_NUM_10000
                add numStartX, OFFSET_CELL_10000_X
                add numStartY, OFFSET_CELL_10000_Y
            .endif
            ; Draw number 
            invoke wsprintf, addr szBuffer, addr szNumFormat, currentNum
            invoke TextOut, _hDc, numStartX, numStartY, addr szBuffer, eax
L1:
            ; Update display 
            popad
            add cellStartX, WIDGET_CELL_EDGE + WIDGET_MARGIN_SMALL
            add cellEndX, WIDGET_CELL_EDGE + WIDGET_MARGIN_SMALL
            inc j
        .endw
        ; Update display 
        add cellStartY, WIDGET_CELL_EDGE + WIDGET_MARGIN_SMALL
        add cellEndY, WIDGET_CELL_EDGE + WIDGET_MARGIN_SMALL
        inc i
    .endw

    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ;>> Refresh UI 
    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    invoke BitBlt, hDc, 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT, _hDc, 0, 0, SRCCOPY

    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ;>> Free Resources 
    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    invoke DeleteObject, _cptBmp
    invoke DeleteDC, _hDc

    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ;>> Game Win Condition 
    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    .if infiniteMode == 0
        .if reached2048 == 1
            invoke MessageBox, hWinMain, offset MSG_WIN, offset MSG_WIN_TITLE, MB_OK
            .if eax == IDOK
                invoke MessageBox, hWinMain, offset MSG_CONTINUE,offset MSG_WIN_TITLE,MB_YESNO
                .if eax == IDYES
                    mov infiniteMode, 1
                .elseif eax == IDNO
                    invoke DestroyWindow, hWinMain
                .endif
            .endif
        .endif
    .endif

    popad ;Restore registers
    ret
updateGameWnd endp

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>> Initialize Data and Refresh 
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
initFonts proc
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>> Drawing Mode 
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
push eax
invoke CreateFont, 90, 0, 0, 0, FW_BLACK, FALSE, FALSE, FALSE, DEFAULT_CHARSET, OUT_CHARACTER_PRECIS, CLIP_CHARACTER_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH or FF_DONTCARE, addr szFontName
mov FONT_CELL_NUM, eax
invoke CreateFont, 80, 0, 0, 0, FW_BLACK, FALSE, FALSE, FALSE, DEFAULT_CHARSET, OUT_CHARACTER_PRECIS, CLIP_CHARACTER_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH or FF_DONTCARE, addr szFontName
mov FONT_TITLE, eax
invoke CreateFont, 35, 0, 0, 0, FW_BLACK, FALSE, FALSE, FALSE, DEFAULT_CHARSET, OUT_CHARACTER_PRECIS, CLIP_CHARACTER_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH or FF_DONTCARE, addr szFontName
mov FONT_SCORE_TXT, eax
invoke CreateFont, 30, 0, 0, 0, FW_BLACK, FALSE, FALSE, FALSE, DEFAULT_CHARSET, OUT_CHARACTER_PRECIS, CLIP_CHARACTER_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH or FF_DONTCARE, addr szFontName
mov FONT_SCORE_NUM, eax
invoke CreateFont, 40, 0, 0, 0, FW_BLACK, FALSE, FALSE, FALSE, DEFAULT_CHARSET, OUT_CHARACTER_PRECIS, CLIP_CHARACTER_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH or FF_DONTCARE, addr szFontName
mov FONT_RESTART, eax
invoke CreateFont, 40, 0, 0, 0, FW_BLACK, FALSE, FALSE, FALSE, DEFAULT_CHARSET, OUT_CHARACTER_PRECIS, CLIP_CHARACTER_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH or FF_DONTCARE, addr szFontName
mov FONT_INTRO_TITLE, eax
invoke CreateFont, 30, 0, 0, 0, FW_BLACK, FALSE, FALSE, FALSE, DEFAULT_CHARSET, OUT_CHARACTER_PRECIS, CLIP_CHARACTER_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH or FF_DONTCARE, addr szFontName
mov FONT_INTRO_TXT, eax

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>> Block Movement Processing 
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
invoke CreateFont, SIZE_CELL_10, 0, 0, 0, FW_BLACK, FALSE, FALSE, FALSE, DEFAULT_CHARSET, OUT_CHARACTER_PRECIS, CLIP_CHARACTER_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH or FF_DONTCARE, addr szFontName
mov FONT_CELL_NUM_10, eax
invoke CreateFont, SIZE_CELL_100, 0, 0, 0, FW_BLACK, FALSE, FALSE, FALSE, DEFAULT_CHARSET, OUT_CHARACTER_PRECIS, CLIP_CHARACTER_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH or FF_DONTCARE, addr szFontName
mov FONT_CELL_NUM_100, eax
invoke CreateFont, 59, 0, 0, 0, FW_BLACK, FALSE, FALSE, FALSE, DEFAULT_CHARSET, OUT_CHARACTER_PRECIS, CLIP_CHARACTER_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH or FF_DONTCARE, addr szFontName
mov FONT_CELL_NUM_1000, eax
invoke CreateFont, 46, 0, 0, 0, FW_BLACK, FALSE, FALSE, FALSE, DEFAULT_CHARSET, OUT_CHARACTER_PRECIS, CLIP_CHARACTER_PRECIS, DEFAULT_QUALITY, DEFAULT_PITCH or FF_DONTCARE, addr szFontName
mov FONT_CELL_NUM_10000, eax

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>> Block Labeling 
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
invoke CreateSolidBrush, COLOR_NUM0_BG
mov BRUSH_CELL_0, eax
invoke CreateSolidBrush, COLOR_NUM2_BG
mov BRUSH_CELL_2, eax
invoke CreateSolidBrush, COLOR_NUM4_BG
mov BRUSH_CELL_4, eax
invoke CreateSolidBrush, COLOR_NUM8_BG
mov BRUSH_CELL_8, eax
invoke CreateSolidBrush, COLOR_NUM16_BG
mov BRUSH_CELL_16, eax
invoke CreateSolidBrush, COLOR_NUM32_BG
mov BRUSH_CELL_32, eax
invoke CreateSolidBrush, COLOR_NUM64_BG
mov BRUSH_CELL_64, eax
invoke CreateSolidBrush, COLOR_NUM128_BG
mov BRUSH_CELL_128, eax
invoke CreateSolidBrush, COLOR_NUM256_BG
mov BRUSH_CELL_256, eax
invoke CreateSolidBrush, COLOR_NUM512_BG
mov BRUSH_CELL_512, eax
invoke CreateSolidBrush, COLOR_NUM1024_BG
mov BRUSH_CELL_1024, eax
invoke CreateSolidBrush, COLOR_NUM2048_BG
mov BRUSH_CELL_2048, eax
pop eax
ret
initFonts endp

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>> Game Start Initialization 
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
initGameData proc
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>> Initialize Grid 
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
mov gameEnd, 0
mov reached2048, 0
mov infiniteMode, 0
mov score, 0
mov esi, 0
.while esi < 16 ;Clear all grid cells
mov numMat[esi * 4], 0
inc esi
.endw

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>> Initialize State 
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
invoke GetTickCount
mov randomSeed, eax

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>> Handle User Input 
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
invoke randomLCG
invoke randomLCG

ret
initGameData endp

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>> Process Grid Updates 
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
WinMainProc proc, hWnd, uMsg, wParam, lParam
    local ps:PAINTSTRUCT
    local hDc

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>> Close Window 
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
.if uMsg == WM_CLOSE
    invoke DestroyWindow, hWinMain
    invoke PostQuitMessage, 0

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>> Handle Events 
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
.elseif uMsg == WM_CREATE
    invoke initFonts
    invoke initGameData

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>> Process Messages 
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
.elseif uMsg == WM_KEYDOWN

    mov edx, wParam
    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ;>> Merge Up 
    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    .if edx == VK_UP || edx == "W" || edx == "w"
        .if isUpPressed == 0
            mov isUpPressed, 1
            invoke moveUp
            .if movedUp == 1
                invoke randomLCG
            .endif
            invoke InvalidateRect, hWnd, NULL, FALSE
        .endif

    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ;>> Merge Down 
    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    .elseif edx == VK_DOWN || edx == "S" || edx == "s"
        .if isDownPressed == 0
            mov isDownPressed, 1
            invoke moveDown
            .if movedDown == 1
                invoke randomLCG
            .endif
            invoke InvalidateRect, hWnd, NULL, FALSE
        .endif

    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ;>> Merge Left 
    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    .elseif edx == VK_LEFT || edx =="A" || edx == "a"
        .if isLeftPressed == 0
            mov isLeftPressed, 1
            invoke moveLeft
            .if movedLeft == 1
                invoke randomLCG
            .endif
            invoke InvalidateRect, hWnd, NULL, FALSE
        .endif

    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ;>> Merge Right 
    ;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    .elseif edx == VK_RIGHT || edx == "D" || edx == "d"
        .if isRightPressed == 0
            mov isRightPressed, 1
            invoke moveRight
            .if movedRight == 1
                invoke randomLCG
            .endif
            invoke InvalidateRect, hWnd, NULL, FALSE
        .endif
    .endif

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>> Check if Game is Over 
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
invoke canMove
.if gameEnd == 1
    invoke MessageBox, hWinMain, offset MSG_GAME_OVER_TXT, offset MSG_GAME_OVER_TITLE, MB_OK
    .if eax == IDOK
        invoke initGameData
        invoke InvalidateRect, hWnd, NULL, FALSE
    .endif
.endif

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>> Release Resources 
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
.elseif uMsg == WM_KEYUP
    mov edx, wParam
    .if edx == VK_UP || edx == "W" || edx == "w"
        mov isUpPressed, 0
    .elseif edx == VK_DOWN || edx == "S" || edx == "s"
        mov isDownPressed, 0
    .elseif edx == VK_LEFT || edx == "A" || edx == "a"
        mov isLeftPressed, 0
    .elseif edx == VK_RIGHT || edx == "D" || edx == "d"
        mov isRightPressed, 0
    .endif

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>> Display New Block
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
.elseif uMsg == WM_PAINT

    invoke BeginPaint, hWnd, addr ps
    mov hDc, eax
    invoke updateGameWnd, hWnd, hDc
    invoke EndPaint, hWnd, addr ps

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>> Default Settings 
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
.else
    invoke DefWindowProc, hWnd, uMsg, wParam, lParam
    ret
.endif
xor eax, eax
ret
WinMainProc endp

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>> Embedded Functions 
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
WinMain proc
    local wcex:WNDCLASSEX
    local msg:MSG

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>> Get Module Handle 
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
invoke GetModuleHandle, NULL
mov hInstance, eax

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>> Set Window Information 
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
invoke RtlZeroMemory, addr wcex, sizeof wcex
; Set the size of the window class structure
mov wcex.cbSize, sizeof WNDCLASSEX
; Set the instance handle for the window class
push hInstance
pop wcex.hInstance
; Load the default arrow cursor
invoke LoadCursor, 0, IDC_ARROW
mov wcex.hCursor, eax
; Set the window class style
mov wcex.style, CS_HREDRAW or CS_VREDRAW
; Set the background color for the window
mov wcex.hbrBackground, COLOR_WINDOW+1
; Set the class name for the window
mov wcex.lpszClassName, offset szClassName
; Specify the window procedure function
mov wcex.lpfnWndProc, offset WinMainProc

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>> Message Processing
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Initialize fonts
invoke initFonts
; Register the window class
invoke RegisterClassEx, addr wcex
; Create the main window
invoke CreateWindowEx, WS_EX_CLIENTEDGE, offset szClassName, offset szTitleMain, WS_OVERLAPPED or WS_CAPTION or WS_SYSMENU,400, 50, WINDOW_WIDTH, WINDOW_HEIGHT, NULL, NULL, hInstance, NULL
mov hWinMain, eax
; Show the window
invoke ShowWindow, hWinMain, SW_SHOWNORMAL
invoke UpdateWindow, hWinMain

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>> Message Loop
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
.while TRUE
    ; Retrieve a message
    invoke GetMessage, addr msg, NULL, 0, 0
    .if eax == 0
        .break
    .endif
    ; Translate and dispatch the message
    invoke TranslateMessage, addr msg
    invoke DispatchMessage, addr msg
.endw
ret
WinMain endp

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>> Main Function
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
main proc
    invoke WinMain
    invoke ExitProcess, NULL
    ret
main endp
end main