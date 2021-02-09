# Author:		ramb0
# Book:			The Shellcoders Handbook - page 42

Dump of assembler code for function _exit:
   0x0806e05a <+0>:	mov    ebx,DWORD PTR [esp+0x4]
   0x0806e05e <+4>:	mov    eax,0xfc
   0x0806e063 <+9>:	call   DWORD PTR gs:0x10
   0x0806e06a <+16>:	mov    eax,0x1
   0x0806e06f <+21>:	int    0x80
   0x0806e071 <+23>:	hlt 

# 6 possible parameters for syscall
eax
ebx
ecx
edx
esi
edi
epb

# List of syscall numbers
syscall number 0xfc (252) -> exit_group()
syscall number 1    (1)   ->  exit()
# Syscall for 0xfc (252)
mov eax,0xfc


# For exit shell code we only need exit()
# Our exit_shellcode.asm file:

Section .text
        global _start
_start:
        mov ebx,0
        mov eax,1
        int 0x80

# Commands to compile:
nasm -f elf32 exit_shellcode.asm
ld -m elf_i386 -o exit_shellcode exit_shellcode.o

# To get the bytes of the shellcode:
objdump -d exit_shellcode

exit_shellcode:     file format elf32-i386


Disassembly of section .text:

08049000 <_start>:
 8049000:	bb 00 00 00 00       	mov    $0x0,%ebx
 8049005:	b8 01 00 00 00       	mov    $0x1,%eax
 804900a:	cd 80                	int    $0x80


# To try it out, c code:
char shellcode[] = "\xbb\x00\x00\x00\x00"
		   "\xb8\x01\x00\x00\x00"
		   "\xcd\x80";

int main() {

	int* ret;
	ret = (int*) &ret + 2;
	(*ret) = (int)shellcode;
}

# But this is now with zero's, and in a buffer it gets strings terminated.

Using "xor ebx,ebx" to make sure that ebx is zero.
Because ebx or ebx is always zero.
We use "mov al,1" to load an one in the al register which 16 bit is.
The code looks like: (no_null_exit_shellcode.asm)

Section .text
        global _start
_start:
        xor ebx,ebx ; ebx or ebx -> always 0
        mov al,1    ; al is 16 bit, so no 4 zeros
        int 0x80


# Compiling with the same flags and commands:
nasm -f elf32 no_null_exit_shellcode.asm
ld -m elf_i386 -o exit_shellcode no_null_exit_shellcode.o

# Use objdump -d to extract the bytes:
no_null_exit_shellcode.o:     file format elf32-i386


Disassembly of section .text:

00000000 <_start>:
   0:	31 db                	xor    %ebx,%ebx
   2:	b0 01                	mov    $0x1,%al
   4:	cd 80                	int    $0x80

Shellcode: "\x31\xdb\xb0\x01\xcd\x80"

# Now you can use it in a buffer, without fearing the 0 byte will terminate the string.
