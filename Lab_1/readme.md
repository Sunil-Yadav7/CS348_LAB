# Assembly Language Lab Submission

**Name:** Sunil  
**Roll No.:** 230101099  

---

## 1. SET A: Question No. 3
Consider an array of size n. 
Print the smallest and largest number and their location in the array. 
Take n as a user input.
EX:
ARRAY: 12, 230, 2, 304, 760, 43, 203,300, 450, 130
smallest=2
loc_small=2
largest=760
loc_lar=4 
##array starts with index 0

### Assumptions made:
Array consists only integers.
Array size cannot exceed 100.

### Commands to Execute:
To assemble, link, and run the program, use the following commands in your terminal:

```bash
nasm -f elf32 230101099_seta.asm -o 230101099_seta.o
ld -m elf_i386 230101099_seta.o -o 230101099_seta
./230101099_seta
```

## 2. SET B: Question No. 12
Given an array of size n, take inputs from the user and add them to the array only if
they satisfy the following conditions: it is a prime and it is a non-duplicate number.
The program stops taking inputs when the array is full. Print the resultant array.

### Assumptions made:
Dynamically allocated memory for array.
Choose n keeping in mind the memory available on your PC. 

### Commands to Execute:
To assemble, link, and run the program, use the following commands in your terminal:

```bash
nasm -f elf32 230101099_setb.asm -o 230101099_setb.o
ld -m elf_i386 230101099_setb.o -o 230101099_setb
./230101099_setb
```

## 3. SET B: Question No. 5
Write a program to multiply the given two matrices (N*M, M*N) and print the
resultant matrix. All inputs must be taken from user.

### Assumptions made:
Both input matrices A & B contain atmost 100 integers each.
Resultant matrix can also contain atmost 100 integers only.
N and M can be taken accordingly keeping in mind the capacity of the matrices.

### Commands to Execute:
To assemble, link, and run the program, use the following commands in your terminal:

```bash
nasm -f elf32 230101099_setb_5.asm -o 230101099_setb_5.o
ld -m elf_i386 230101099_setb_5.o -o 230101099_setb_5
./230101099_setb_5
```