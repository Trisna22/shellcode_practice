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
The spawn-shell shellcode, gives the user a shell from the /bin/sh path. We had to remove the zero's from the bytes and make the shellcode as compact as possible. This code was first programmed in assembly.

### chmod_shadow
The chmod_shadow shellcode makes sure that the normal user can read and write to the /etc/shadow file. We make use of the chmod() syscall with the permissions of the value 0666. 

### overwriteMBR
The shellcode for overwriting the MBR, Master Boot Record. This shellcode writes to the /dev/sda file to overwrite the MBR with 'HAHA', so that the users won't be able to boot their device up after a restart or a shutdown. The shellcode can only succesfully be executed in a window of a program/service that is executed with root permissions or a binary with the setuid permissions enabled. 

### fork_bomb
The fork bomb is a small program that consumes CPU by calling the fork() function in an endless loop. This makes 
the machine slow down or even crash. 

## Notes
When working on this project, I noticed that we can't create shellcode that works on every system. This is because not all shellcode can be understood on every 
system or program. Some systems use different opcodes or instructions, some programs have different memory mappings so that we have to adjust the shellcode in
order to make it work. Before we want to exploit a system or craft shellcode, 
we need to asks some questions first. What operating system is the machine running? Is it 32 or 64 bit? What software do you want to exploit?
  
These are crucial questions we have to ask ourselves, before we can craft and use shellcode. Throwing shellcode or exploits on systems we don't have information about will mostly fail, because we don't know if the shellcode or the exploit even works on the target computer it is developed for.  

The best thing to do is, if you want to exploit a system, you should gather information about the system and create shellcode or exploits based on that and not 
on assumptions or already made shellcode/exploits. This project is good for practicing shellcode crafting and not for using them on arbitrary systems.
