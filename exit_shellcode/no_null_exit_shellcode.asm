
Section .text
	global _start
_start:
	xor ebx,ebx ; ebx or ebx -> always 0
	mov al,1    ; al is 16 bit, so no 4 zeros
	int 0x80
