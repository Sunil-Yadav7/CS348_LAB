; ==========================================================
; Description: Allocates memory for N elements and ensures 
;              only unique prime numbers are stored.
; ==========================================================

section .data
    prompt_size     db "Enter array size: ", 0
    prompt_size_len equ $ - prompt_size
    
    prompt_num      db "Enter a unique prime number: ", 0
    prompt_num_len  equ $ - prompt_num
    
    msg_result      db "Final Array: ", 0
    msg_result_len  equ $ - msg_result
    
    char_space      db " "
    char_newline    db 10

section .bss
    input_buf       resb 32    ; Buffer 
    mem_start       resd 1     ; Pointer to dynamically allocated memory
    limit           resd 1     ; Total elements to store
    current_count   resd 1     ; Current index of valid numbers stored

section .text
    global _start

_start:
    ; --- Step 1: Request Array Size ---
    mov eax, 4          ; sys_write
    mov ebx, 1          ; stdout
    mov ecx, prompt_size
    mov edx, prompt_size_len
    int 0x80

    call get_user_input
    mov [limit], eax

    ; --- Step 2: Dynamic Heap Allocation (sys_brk) ---
    mov eax, 45         ; Get current break point
    xor ebx, ebx
    int 0x80
    mov [mem_start], eax

    ; Calculate memory needed: limit * 4 bytes
    mov ebx, [limit]
    shl ebx, 2          ; Multiplies by 4
    add ebx, eax        ; New break point address
    mov eax, 45         ; Set new break point
    int 0x80

    mov dword [current_count], 0

;  Populate the Array ---
fetch_data:
    mov eax, [current_count]
    cmp eax, [limit]
    je display_output

    ; Request number
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt_num
    mov edx, prompt_num_len
    int 0x80

    call get_user_input
    mov ebx, eax        ; Store the candidate number in EBX

    ; Check if Prime
    push ebx
    call verify_prime
    add esp, 4
    test eax, eax
    jz fetch_data       ; If not prime (0), ask again

    ; Check if Duplicate
    push ebx
    call check_exists
    add esp, 4
    test eax, eax
    jnz fetch_data      ; If exists (1), ask again

    ; If both tests pass, save it
    mov ecx, [current_count]
    mov edx, [mem_start]
    mov [edx + ecx*4], ebx
    inc dword [current_count]
    jmp fetch_data

; --- Display Logic ---
display_output:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_result
    mov edx, msg_result_len
    int 0x80

    xor esi, esi
    mov edi, [mem_start]
.print_loop:
    cmp esi, [limit]
    je .exit_prog
    
    mov eax, [edi + esi*4]
    call print_number
    
    push eax            ; Print space
    mov eax, 4
    mov ebx, 1
    mov ecx, char_space
    mov edx, 1
    int 0x80
    pop eax
    
    inc esi
    jmp .print_loop

.exit_prog:
    mov eax, 4
    mov ebx, 1
    mov ecx, char_newline
    mov edx, 1
    int 0x80

    mov eax, 1          ; sys_exit
    xor ebx, ebx
    int 0x80

; ==========================================================
; ==========================================================

get_user_input:
    ; Read from keyboard and convert ASCII to Integer
    mov eax, 3          ; sys_read
    mov ebx, 0          ; stdin
    mov ecx, input_buf
    mov edx, 31
    int 0x80

    xor eax, eax
    mov esi, input_buf
.parse:
    movzx ecx, byte [esi]
    cmp ecx, 10         ; Stop at Newline
    je .done
    sub ecx, '0'
    imul eax, 10
    add eax, ecx
    inc esi
    jmp .parse
.done:
    ret

verify_prime:
    ; Returns 1 in EAX if prime, 0 if not
    mov ecx, [esp+4]
    cmp ecx, 2
    jl .no
    je .yes
    mov esi, 2
.loop:
    mov eax, esi
    mul eax             ; EAX = esi * esi
    cmp eax, ecx
    jg .yes
    mov eax, ecx
    xor edx, edx
    div esi
    test edx, edx       ; Remainder 0?
    jz .no
    inc esi
    jmp .loop
.yes: mov eax, 1
    ret
.no: xor eax, eax
    ret

check_exists:
    ; Returns 1 if number exists in current array
    mov edx, [esp+4]
    xor ecx, ecx
    mov edi, [mem_start]
.loop:
    cmp ecx, [current_count]
    je .absent
    cmp edx, [edi + ecx*4]
    je .found
    inc ecx
    jmp .loop
.found: mov eax, 1
    ret
.absent: xor eax, eax
    ret

print_number:
    ; Standard itoa: Divides by 10 and stores remainders backwards
    mov ecx, input_buf + 31
    mov byte [ecx], 0
    mov ebx, 10
.next_digit:
    xor edx, edx
    div ebx
    add dl, '0'
    dec ecx
    mov [ecx], dl
    test eax, eax
    jnz .next_digit
    
    mov eax, 4
    mov ebx, 1
    mov edx, input_buf + 31
    sub edx, ecx
    int 0x80
    ret