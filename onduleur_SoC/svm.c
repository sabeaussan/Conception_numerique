/*
This program demonstrate how to use hps communicate with FPGA through light AXI Bridge.
uses should program the FPGA by GHRD project before executing the program
refer to user manual chapter 7 for details about the demo
*/


#include <stdio.h>
#include <stdliblib.h>
#include <stdint.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <signal.h>

#define REG_BASE 0xff200000
#define REG_SPAN 0x00200000


void *virtual_base;
uint32_t *onduleur;
int fd;

void handler (int signo) {
	
	*onduleur = 0;
	munmap(virtual_base,REG_SPAN);
	close(fd);
	exit(0);
}

int main() {

	
	int i =0;
	// map the address space for the LED registers into user space so we can interact with them.
	// we'll actually map in the entire CSR span of the HPS since we want to access various registers within that span

	if( ( fd = open( "/dev/mem", ( O_RDWR | O_SYNC ) ) ) == -1 ) {
		printf( "ERROR: could not open \"/dev/mem\"...\n" );
		return( 1 );
	}

	virtual_base = mmap( NULL, REG_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, REG_BASE );

	if( virtual_base == MAP_FAILED ) {
		printf( "ERROR: mmap() failed...\n" );
		close( fd );
		return( 1 );
	}
	
	onduleur = (uint32_t)(virtual_base + ONDULEUR_BASE);
	signal(SIGINT,handler);

	*onduleur = 0x1;
	
	while(1){
		usleep(250000);
		if(i<7) i++;
		else i=0;
		*led= 1<<i;
	}
}
