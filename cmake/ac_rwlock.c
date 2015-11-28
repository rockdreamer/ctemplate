#define _XOPEN_SOURCE 500
#include <pthread.h>

int main(int argc, char**argv){
	pthread_rwlock_t l;
	pthread_rwlock_init(&l, NULL);
    pthread_rwlock_rdlock(&l); 
    return 0;
}