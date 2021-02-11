# shellcode_practice
In this project I am learning how to write shellcode, I am able to inject the shellcode in a buffer and execute arbitrary code.

## Handbook
Recently I bought the book 'Shellcoders Handbook' where I am learning how to write shellcode and use it to exploit various machines.  
I love the book and I learn a lot from it, in this project I want to show my learned skills off.

## Tools
The tools that are used for this project are compilers, debuggers and ELF/object readers.  
These tools are simply downloaded from the internet or installed in the different linux distro's.
  
  
GDB: The GNU Project Debugger https://www.gnu.org/software/gdb/  
Objdump: https://ftp.gnu.org/old-gnu/Manuals/binutils-2.12/html_chapter/binutils_4.html  
NASM: https://nasm.us/  
LD: https://www.man7.org/linux/man-pages/man1/ld.1.html  


## Sections:
In every section there is a own README file with  the explaining how I wrote the code. 

### exit_shellcode
The exit shellcode was my first shellcode ever, and is based on the example from the book. The shellcode 

### spawn_shell
The spawn-shell shellcode, gives the user a shell from the /bin/sh path. We had to remove the zero's from the bytes and make  
the shellcode as compact as possible. This code was first programmed in assembly.

### chmod_shadow
The chmod_shadow shellcode makes sure that the normal user can read and write to the /etc/shadow file. We make use of the chmod() syscall with the permissions of the value 0666. 

### overwriteMBR
The shellcode for overwriting the MBR, Master Boot Record. This shellcode writes to the /dev/sda file to overwrite the MBR with 'HAHA', so that the users won't be able to boot their device up after a restart or a shutdown. The shellcode can only succesfully be executed in a window of a program/service that is executed with root permissions or a binary with the setuid permissions enabled. 
