; Written for NASM
; Intended for Linux
; Basics of assembly:
;   syscall tells the system to execute a kernel function
;   rax is the register which holds the id of the function to call.
;   rdi is the first argument 
;   rsi is the second argument
;   rdx is the second argument, etc
;   
;   
section .data ; Static data, Constants
  msg: db "Name: "
  hello: db "Hello " ; db: define bytes: Puts this string onto the stack, and gives it the alias "hello". Addresses 0-6, remember strings are ended with a null byte
  ending: db "!", 10 ; 10 is the newline character 3 bytes, remember the null
  outfile: db "out.txt" ; File name to output to.
section .bss ; This section is where the we ask for dynamically reserved memory
  input: resb 16 ; Reserve 16 addresses 
section .text
  global _start ; This makes the _start item available to external callers
  _start: 


    mov rax, 1      ; Moves the code for the Linux sys_write call into rax
       mov rdi, 1   ; Moves the code for STDOUT into the first parameter register
       mov rsi, msg ; Moves the address for our message into the second parameter register
       mov rdx, 6   ; Moves the number of bytes to write into the third parameter register
    syscall

    mov rax, 0        ; Moves the code for the Linux sys_read call into rax
       mov rdi, 0     ; Moves the code for STDIN into the first parameter register
       mov rsi, input ; Moves the address of our input reserved buffer into the second parameter register
       mov rdx, 16    ; Move the number of bytes of our reserved buffer into the third parameter register
    syscall

    mov rax, 1        ; Moves the code for the Linux sys_write call into rax
       mov rdi, 1     ; Moves the code for STDOUT into the first parameter register
       mov rsi, hello ; Moves the address for our message into the second parameter register
       mov rdx, 6     ; Moves the number of bytes to print into the third parameter register
    syscall

   ; Find the length of the user input string and only output that number of characters
    mov rax, 1                 ; Write
        mov rdi, 1              ; To STDOUT
        mov rsi, input          ; User input
        mov r10, 0               ; Initialize character count to 0
      check:
        cmp dword [input+r10], 10 ; Compare character of user input to NEWLINE 
        je finished             ; and if equal goto finished
        inc r10 ; Increment counter
        jmp check
      finished:
        ;dec r10 ; Removes the input newline (Always there?)
        mov rdx, r10 ; Move the number of chars to write into third parameter register
    syscall
    
    mov rax, 1         ; Write 
       mov rdi, 1      ; to STDOUT
       mov rsi, ending ; ending
       mov rdx, 2      ; number of characters
    syscall

    mov rax, 60 ; Moves the number code for the Linux sys_exit call into rax
       mov rdi, 0  ; Moves the return value to the first parameter register
    syscall     ; Asks the Linux kernel to do something
    
