extern char _start[];
extern char data_start[];
extern char dummy[]  __attribute__((weak));

int main(int argc, char**argv){
	return (_start && data_start && dummy);	
}

