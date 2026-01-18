; ------------------------------------------------
; Smallest & Largest element with index (0-based)
; ------------------------------------------------

section .data
    msg1 db "Enter n : ",
    l1   equ $-msg1
    msg2 db "Enter elements: ",10
    l2   equ $-msg2
    msg3 db "Smallest_num = "
    l3   equ $-msg3
    msg4 db 10,"Location_smallest = "
    l4   equ $-msg4
    msg5 db 10,"Largest_num = "
    l5   equ $-msg5
    msg6 db 10,"Location_largest = "
    l6   equ $-msg6
    nl   db 10

section .bss
    n      resd 1
    arr    resd 100
    min    resd 1
    max    resd 1
    min_i  resd 1
    max_i  resd 1
    buffer resb 16

section .text
    global _start

_start:
    mov eax ,4
    mov ebx ,1
    mov ecx, msg1
    mov edx, l1
    int 0x80

    ; read n
    call read_int 
    mov [n] , eax

    mov eax ,4
    mov ebx ,1
    mov ecx, msg2
    mov edx, l2
    int 0x80

    xor esi ,esi  ; counter for array elements

input_loop:
    cmp esi, [n]
    jge input_done

    call read_int
    mov [arr+ esi*4],eax
    inc esi
    jmp input_loop

input_done:
    xor eax ,eax
    xor ecx,ecx

init:
    mov eax,[arr]
    mov [min],eax
    mov [max],eax
    mov dword [min_i],0
    mov dword [max_i],0

    mov esi,1

check:
    cmp esi , [n]
    jge output

    mov eax , [arr+ esi*4]
    cmp eax, [min]
    jge chkmax
    mov [min],eax
    mov [min_i] , esi

chkmax:
    cmp eax, [max]
    jle next
    mov [max],eax
    mov [max_i], esi

next:
    inc esi
    jmp check

output:
    ; print min
    mov eax,4
    mov ebx,1
    mov ecx,msg3
    mov edx, l3
    int 0x80

    mov eax, [min]
    call print_int

    ;print min_loc
 
    mov eax,4
    mov ebx,1
    mov ecx,msg4
    mov edx, l4
    int 0x80

    mov eax, [min_i]
    call print_int

    ; print max
    mov eax,4
    mov ebx,1
    mov ecx,msg5
    mov edx, l5
    int 0x80

    mov eax, [max]
    call print_int

    ;print max_loc
 
    mov eax,4
    mov ebx,1
    mov ecx,msg6
    mov edx, l6
    int 0x80

    mov eax, [max_i]
    call print_int
    
    mov eax, 1          
    xor ebx, ebx       
    int 0x80           
    
; Function to read integer from stdin
read_int:
    push ebx
    push ecx
    push edx
    
    ; Read input string
    mov eax, 3          ; sys_read
    mov ebx, 0          ; stdin
    mov ecx, buffer
    mov edx, 16
    int 0x80
    
    ; Convert string to integer
    xor eax, eax
    xor ebx, ebx
    mov ecx, buffer
convert_loop:
    movzx edx, byte [ecx]
    cmp dl, 10          ; newline
    je convert_done
    cmp dl, '0'
    jl convert_done
    cmp dl, '9'
    jg convert_done
    
    sub dl, '0'
    imul eax, 10
    add eax, edx
    inc ecx
    jmp convert_loop
    
convert_done:
    pop edx
    pop ecx
    pop ebx
    ret

; Function to print integer to stdout
print_int:
    push eax
    push ebx
    push ecx
    push edx

    mov ecx, buffer
    add ecx, 15         ; point to end
    mov byte [ecx], 0   ; newline
    mov ebx, 10

.convert:
    dec ecx
    xor edx, edx
    div ebx
    add dl, '0'
    mov [ecx], dl
    test eax, eax
    jnz .convert

    mov eax, 4           ; sys_write
    mov ebx, 1           ; stdout
    mov edx, buffer
    add edx, 32
    sub edx, ecx         ; length = end - start
    int 0x80

    pop edx
    pop ecx
    pop ebx
    pop eax
    ret





 