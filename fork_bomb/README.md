# fork_bomb
This a dangerous piece of shellcode for crashing and slowing down a machine. I used it on mine and I had to force 
shutdown the computer with the power-button. A fork bomb is a loop where the fork() syscall function gets called
every loop. This happens so fast that the machine runs out of virutal memory. 
  
The code is very simple, I won't be explaining the code, because it would be understandable for everyone who
has red my earlier projects.
  
The only function that we are using is the fork() function. This can be found on the man page.  
```C++
pid_t fork(void);
```
