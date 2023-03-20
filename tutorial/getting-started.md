Always believe that something is easy.  Don't abandon the fight before even showing up.

The first thing to remember is which architecture you are writing for.  
This impacts 2 things: 
 - What commands are available
 and 
 - Which assembler you can use

Assemblers
==========
Each assembler has slightly different syntax, so it is important that pick one that works on your architecture, and try to stick with it.
- On Windows systems, the assembler is called MASM: The Microsoft Assembler
- In Linux or other x86 systems the most popular assembler is NASM: The Netwide Assembler
- Also available is AS: The GNU Assembler.  This one is generally installed along with any open source compilation toolset.
Arm64 systems (Like Raspberry Pi) are generally not compatible with MASM or NASM.

For this reason, this Tutorial will target The GNU Assembler.

For other processors, like the incredibly popular 6502, you will have to do some additional research.

First Principles
================
Installation
------------
The fastest and easiest way to get an environment set up for assembly development, is to find a Linux command line, and install the GNU Assembler.
Try: sudo apt install as


Addressing
----------
Perhaps, the most important thing to understand, is how you call what you may have think of as a system function.
You give the function parameters, and then ask it to do something, and return a value.  
In assembly, functions make assumptions that you have to respect.  

Think of it this way, functions are very good at what they do, but they are shy, you can't talk to them directly.
What you do instead, is leave your instructions where you know that they will find them, and then make a general announcement,
that you are ready for them to get to work.

The places that you leave instructions are called registers.  On x86 systems, registers have names like rax, eax, rdi, edi, etc.  The 'e' means that it is a 32bit register, and the 'r' means that it uses the whole 64bits.  

In this tutorial we are going to be using a Raspberry Pi, which uses R0-R7.

After you leave your arguments in the registers, then you call a system command which says that the function should look in these special registers.

Hello World
===========
The following is slightly advanced Hello World program written in GNU Assembler, for Arm64 (Rasperry Pi) to demonstrate the primary structure of an assembly program:

The structure of an assembly program mirrors how final executable file exists on disk.  
Keywords that start with a dot are called directives.  Some directives indicate which section of the file we are defining..

.data indicates the start of the data section, where we define variables with initial values.
   These are properly thought of as constants: [Identifier]: [value]
.asciz indicates that the character array should end with a NUL character.  
.ascii would just insert the the character array as is.

.bss is where you reserve an explicit number of bytes under a given name for use later. Items is this section start off filled with zeros.
.locomm directs the assembler to reserve a length of common memory under the given symbol: .lcomm [symbol] [length in bytes]

.text is the section where the program is defined.
  global: This keyword indicates, that following identifier should be exposed to the outside world as a callable section of executable instructions (a function).
  _start: This is just an identifier, it can be anything you want.

Differences in NASM:
-------------------
* Sections begin with the 'section' keyword, and inline directives do not start with dots:

* section .data ; Static data, Constants
*   msg: db "Name: "

* db is "Define Bytes" and reserves the space required for the character array an the ending NUL.
* resb is used in the .bss section instead of .locomm

* section .bss ; This section is where the we ask for dynamically reserved memory
*  input: resb 16 ; Reserve 16 addresses 

