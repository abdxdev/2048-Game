.386
.model flat, stdcall
option casemap:none

.code

PUBLIC ConvertHexColor

ConvertHexColor proc color:DWORD
    mov eax, color   ; EAX = 0x00RRGGBB
    mov edx, eax     
    and eax, 0FFh    
    shl eax, 16      
    and edx, 0FF00h  
    or eax, edx      
    shr edx, 8       
    and ecx, 0FF0000h
    shr ecx, 16      
    or eax, ecx      ; final format: 0xBBGGRR
    ret
ConvertHexColor endp

end