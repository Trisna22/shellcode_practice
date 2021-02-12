

nasm -f elf chmod_shadow.asm && ld -o chmod_shadow chmod_shadow.o -m elf_i386 && strace ./chmod_shadow
