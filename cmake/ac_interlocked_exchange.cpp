#include <windows.h>

int main(int argc, char** argv){
	volatile LONG once; 
	InterlockedExchange(&once,  1);	
	return 0;
}
