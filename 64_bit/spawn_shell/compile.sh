nasm -f elf64 spawn_shell.asm && ld -m elf_x86_64 spawn_shell.o -o spawn_shell && strace ./spawn_shell
