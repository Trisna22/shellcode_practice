; Author: Trisna Quebe
; 64 bit exit shellcode

Section .text
	global _start

_start:
	xor rax, rax
	inc rax			; increament to make the value 1, for SYS_EXIT
	xor rbx, rbx
	int 0x80
