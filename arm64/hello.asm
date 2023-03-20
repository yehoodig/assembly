/*
 Example program in Raspberry Pi Assembly (arm64)
 Outputs a prompt, then accepts input <=16 characters, and finally outputs a greeting


*/
.data                              @ Data Section, where variables are defined
  msg: .asciz "Name: "             @   .asciz indicates a null terminated character array
  hello: .asciz "Hello "           @
  ending: .asciz "!\n"             @
  outfile: .asciz "out.txt"        @
  scan_pattern: .asciz "%s"        @
  input: .asciz "                " @   Reserve 16+1 bytes
  .balign 4                        @   Declares the addressable width of the following variable: 4 bytes
  return: .word 0                  @
.text                              @ Text section, where the program is defined
.global main                       @   make the identifier 'main' available to outside callers
main:                              @
   ldr r1, =return                 @   "Load to Register" r1, the address of return
   str lr, [r1]                    @   Store to the linking register what is pointed to by r1.  See line 35.
                                   @
   ldr r0, =msg                    @   Load to Register to the first parameter register (r0) the address of msg.
   bl printf                       @   "Branch and Link" execution to the instructions found at the identifier printf.
                                   @   
   ldr r0, =scan_pattern           @   Load to the first parameter register
   ldr r1, =input                  @   Load to the second parameter register
   bl scanf                        @   Branch and link to the function scanf
                                   @
   ldr r0, =input                  @   
   bl printf                       @
                                   @
   ldr r0, =ending                 @
   bl printf                       @
                                   @
   ldr lr, =return                 @   Load to the linking register the address of return.
   ldr lr, [lr]                    @   Load to the linking register the value pointed to by lr. 
   bx lr                           @   Branch and Exchange execution flow with the instructions found at the address in lr
                                   @
.global printf                     @   Declare expected identifiers which will be linked in from an external source.
.global scanf                      @
