# Exit shellcode
My very first shellcode, exit_shellcode for making a fast exit of a program.  
The Shellcoders Handbook - page 42  
  
6 possible parameters for syscall
eax, ebx, ecx, edx, ,esi, edi, epb

# List of syscall numbers for exiting.
To check the list of syscalls with their numbers, 
the list file is located at:  
```   
File location: /usr/include/asm/unistd.h

syscall number 0xfc (252) -> exit_group()
syscall number 1    (1)   ->  exit()
```
  
For the exit shellcode we only need exit()  
Our exit_shellcode.asm file:  
  
```asm
Section .text
        global _start
_start:
        mov ebx,0
        mov eax,1
        int 0x80
```

To compile this code, we need to use the commands:

```bash
nasm -f elf32 exit_shellcode.asm
ld -m elf_i386 -o exit_shellcode exit_shellcode.o
```
  
To get the bytes of the shellcode:  
```bash
objdump -d exit_shellcode
exit_shellcode:     file format elf32-i386


Disassembly of section .text:

08049000 <_start>:
 8049000:	bb 00 00 00 00       	mov    $0x0,%ebx
 8049005:	b8 01 00 00 00       	mov    $0x1,%eax
 804900a:	cd 80                	int    $0x80
```

To try the exit shellcode, we need to code a C program that  
executes our shellcode.  
  
test.c
```C++
char shellcode[] = "\xbb\x00\x00\x00\x00"
		   "\xb8\x01\x00\x00\x00"
		   "\xcd\x80";

int main() {

	int* ret;
	ret = (int*) &ret + 2;
	(*ret) = (int)shellcode;
}
```
The problem is, that this code contains zero's, and in a buffer it gets strings terminated.  

Using "xor ebx,ebx" to make sure that ebx is zero, because  
  
``` Python
ebx xor ebx
```
  
always returns zero.  
  
We use "mov al, 1" to load a '1 value' in the al register which has a size of 16 bits.  
The code eventually looks like: (no_null_exit_shellcode.asm)
```asm
Section .text
        global _start
_start:
        xor ebx,ebx ; ebx or ebx -> always 0
        mov al,1    ; al is 16 bit, so no 4 zeros
        int 0x80
``` 

Now we compile this with the same flags and commands:
```bash
nasm -f elf32 no_null_exit_shellcode.asm
ld -m elf_i386 -o no_null_exit_shellcode no_null_exit_shellcode.o
```
And use objdump -d to extract the bytes:  
```
$ objdump -d -M intel no_null_exit_shellcode

no_null_exit_shellcode:     file format elf32-i386

Disassembly of section .text:

00000000 <_start>:
   0:	31 db                	xor    %ebx,%ebx
   2:	b0 01                	mov    $0x1,%al
   4:	cd 80                	int    $0x80
``` 
  
Shellcode: "\x31\xdb\xb0\x01\xcd\x80"  
Now you can use it in a buffer, without fearing the 0 byte will terminate the string.
