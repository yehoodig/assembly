; Written for NASM
; Intended for Linux
section .data ; Static data, Constants
  msg: db "Name: "
  hello: db "Hello " ; db: define bytes: Puts this string onto the stack, and gives it the alias "hello". Addresses 0-6, remember strings are ended with a null byte
  ending db "!", 10 ; 10 is the newline character 3 bytes, remember the null
section .bss ; This section is where the we ask for dynamically reserved memory
  input: resb 16 ; Reserve 16 bytes 
section .text
  global _start ; This makes the _start item available to external callers
  _start: 

    mov rax, 1
       mov rdi, 1
       mov rsi, msg
       mov rdx, 6
    syscall

    mov rax, 0  ; Moves the code for the Linux sys_read call into rax
       mov rdi, 0  ; Moves the code for STDIN into the first parameter register
       mov rsi, input ; Moves the address of our input reserved buffer into the second parameter register
       mov rdx, 16 ; Move the number of bytes of our reserved buffer into the third parameter register
    syscall

    mov rax, 1 ; Moves the code for the Linux sys_write call into rax
       mov rdi, 1 ; Moves the code for STDOUT into the first parameter register
       mov rsi, hello ; Moves the address for our message into the second parameter register
       mov rdx, 6 ; Moves the number of bytes to print into the third parameter register
    syscall

    mov rax, 1
       mov rdi, 1
       mov rsi, input
       cmp dword [input], 0000
       je finished
       mov r8, 0
check:
       inc r8
       cmp dword [input+r8], 0000
       jne check
       
finished:
       dec r8
       mov rdx, r8
    syscall
    
    mov rax, 1
       mov rdi, 1
       mov rsi, ending
       mov rdx, 2
    syscall

    mov rax, 60 ; Moves the number code for the Linux sys_exit call into rax
       mov rdi, 0  ; Moves the return value to the first parameter register
    syscall     ; Asks the Linux kernel to do something
    
