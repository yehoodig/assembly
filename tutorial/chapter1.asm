; Assembly is easy, but it is slow to write. 
; What is hard, is remembering what everything does.
; 
; The first thing to remember is which architecture you are writing for.  
; This impacts 2 things: 
;  - What commands are available
;  and 
;  - Which assembler you can use

; Assemblers
; ==========
; Each assembler has slightly different syntax, so it is important that pick one that works on your architecture, and try to stick with it.
; - On Windows systems, the assembler is called MASM: The Microsoft Assembler
; - In Linux or other x86 systems the most popular assembler is NASM: The Netwide Assembler
; - Also available is AS: The GNU Assembler.  This one is generally installed along with any open source compilation toolset.
; Arm64 systems (Like Raspberry Pi) are generally not compatible with MASM or NASM.
;
; For this reason, this Tutorial will target The GNU Assembler.

; Hello World
; ===========
; The following is slightly advanced Hello World program written in GNU Assembler, for Arm64 (Rasperry Pi) to demonstrate the primary structure of an assembly program:

; The structure of an assembly program mirrors how final executable file exists on disk.  
; Keywords that start with a dot are called directives.  Some directives indicate which section of the file we are defining..

; .data indicates the start of the data section, where we define variables with initial values.
;    These are properly thought of as constants: [Identifier]: [value]
; .asciz indicates that the character array should end with a NUL character.  
; .ascii would just insert the the character array as is.

; .bss is where you reserve an explicit number of bytes under a given name for use later. Items is this section start off filled with zeros.
; .locomm directs the assembler to reserve a length of common memory under the given symbol: .lcomm [symbol] [length in bytes]

; .text is the section where the program is defined.
;   global: This keyword indicates, that following identifier should be exposed to the outside world as a callable section of executable instructions (a function).
;   _start: This is just an identifier, it can be anything you want.

; Differences in NASM:
; -------------------
; * Sections begin with the 'section' keyword, and inline directives do not start with dots:

; * section .data ; Static data, Constants
; *   msg: db "Name: "

; * db is "Define Bytes" and reserves the space required for the character array an the ending NUL.
; * resb is used in the .bss section instead of .locomm

; * section .bss ; This section is where the we ask for dynamically reserved memory
; *  input: resb 16 ; Reserve 16 addresses 

; Addressing
; ----------
; Perhaps, the most important thing to understand, is how you call what in the past you may have thought of as a system function.
; You give the function parameters, and then ask it to do something, and return a value.  
; In assembly, system functions make assumptions that you have to respect.  
;
; Think of it this way, system functions are very good at what they do, but they are shy, you can't talk to the directly.
; What you do instead, is leave your instructions where you know that they will find them, and then make a general announcement,
; that you are ready for them to get to work.

; The places that you leave instructions are called registers.  R0-R7 are where you leave arguments for a function to find.
; 


.data ; Static data, Constants
  msg: .asciz "Name: "
  hello: .asciz "Hello " ; db: define bytes: Puts this string onto the stack, and gives it the alias "hello". Addresses 0-6, remember strings are ended with a null byte
  ending: .asciz "!\n" ; 10 is the newline character 3 bytes, remember the null
  outfile: .asciz "out.txt" ; File name to output to.
.bss ; This section is where the we ask for dynamically reserved memory
  .locomm input 16 ; Reserve 16 addresses 
.text
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
    
