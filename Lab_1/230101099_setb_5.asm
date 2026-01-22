section .data
    msg_n db "Enter number of rows of A / columns of B ",0
    msg_m db "Enter number of rows of B / columns of A ",0
    msg_element_A db "Enter elements for matrix A: ",10,0
    msg_element_B db "Enter elements for matrix B: ",10,0
    msg_result db "Output matrix: ",10,0
    fmt db "%d",0
    newline db 10,0
    space db " ",0

section .bss
    N resd 1
    M resd 1
    matA resd 100
    matB resd 100
    matC resd 100
    temp resd 1
    
section .text
    global main
    extern printf
    extern scanf

main:
    push ebp
    mov ebp,esp

    ; Get dimensions---------
    push msg_n
    call printf
    add esp,4

    push N 
    push fmt
    call scanf
    add esp,8

    push msg_m
    call printf
    add esp,4

    push M
    push fmt
    call scanf
    add esp,8

    ;------read matrix A----------
    push msg_element_A
    call printf
    add esp,4

    mov ecx,0
    mov ebx,[N]
    imul ebx,[M]

readA:
    cmp ecx,ebx
    je start_readB
    push ecx
    push ebx

    lea eax,[matA+ecx*4]
    push eax
    push fmt
    call scanf
    add esp,8

    pop ebx
    pop ecx
    inc ecx
    jmp readA

start_readB:
    ;--------Read Matrix B----------
    push msg_element_B
    call printf
    add esp,4

    mov ecx,0
    mov ebx,[M]
    imul ebx,[N]

readB:
    cmp ecx,ebx
    je multiply
    push ecx
    push ebx

    lea eax,[matB+ecx*4]
    push eax
    push fmt
    call scanf
    add esp,8

    pop ebx
    pop ecx
    inc ecx
    jmp readB

multiply:
    ; esi=i , edi=j , edx=k
    xor esi,esi

row_loop:
    cmp esi,[N]
    je display
    xor edi,edi

col_loop:
    cmp edi,[N]
    je next_row

    xor ebx,ebx
    xor edx,edx

dot_product:
    cmp edx,[M]
    je store_res

    ; Index A = (i*M+k)
    mov eax,esi
    imul eax,[M]
    add eax,edx
    mov eax ,[matA+eax*4]

    ; Index B= (k*N+j)
    mov ecx,edx
    imul ecx,[N]
    add ecx,edi
    mov ecx,[matB+ecx*4]

    imul eax,ecx
    add ebx,eax
    inc edx 
    jmp dot_product

store_res:
    mov eax,esi
    imul eax,[N]
    add eax,edi
    mov [matC+eax*4],ebx
    inc edi
    jmp col_loop

next_row:
    inc esi
    jmp row_loop

display:
    push msg_result
    call printf
    add esp,4

    xor esi,esi

print_row:
    cmp esi,[N]
    je exit
    xor edi,edi

print_col:
    cmp edi,[N]
    je print_newline

    mov eax,esi
    imul eax,[N]
    add eax,edi
    push dword [matC+eax*4]
    push fmt
    call printf
    
    add esp,8
    push space
    call printf
    add esp,4

    inc edi
    jmp print_col

print_newline:
    push newline
    call printf
    add esp,4
    inc esi
    jmp print_row

exit:
    mov esp,ebp
    pop ebp
    ret 

