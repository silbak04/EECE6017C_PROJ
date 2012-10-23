#include <stdio.h>
#include <unistd.h>
#include "includes.h"//includes header full of necessary includes files (ucosii author's style)
#include "alt_ucosii_simple_error_check.h"
#include "producer_consumer_enums.h"

//ring buffer data structure definition
struct ringBuffer{
	INT8U readMe;//index of oldest element to be read
	INT8U bufSize;//fixed size of ring buffer
	INT8U numElements;//number of elements currently in ring buffer
	INT16U ring[BUFFER_SIZE];//ring buffer. Not initialized, filled by producer.
}ringBuffer;

//task stack definitions
OS_STK    consumer_stk[TASK_STACKSIZE];
OS_STK	  producer_stk[TASK_STACKSIZE];

//ring buffer semaphore (AKA lock) definition
OS_EVENT *buffer_sem;

//light up green LEDs to reflect state of buffer
void lightLEDs(int rw, INT8U stateOfLEDs)
{
	switch(stateOfLEDs){
	case 0:
		if(rw == WRITE){
			*green_LEDs = *green_LEDs | BIT0;
		}else{
			*green_LEDs = *green_LEDs & BIT0NOT;
		}
		return;
	case 1:
		if(rw == WRITE){
			*green_LEDs = *green_LEDs | BIT1;
		}else{
			*green_LEDs = *green_LEDs & BIT1NOT;
		}
		return;
	case 2:
		if(rw == WRITE){
			*green_LEDs = *green_LEDs | BIT2;
		}else{
			*green_LEDs = *green_LEDs & BIT2NOT;
		}
		return;
	case 3:
		if(rw == WRITE){
			*green_LEDs = *green_LEDs | BIT3;
		}else{
			*green_LEDs = *green_LEDs & BIT3NOT;
		}
		return;
	case 4:
		if(rw == WRITE){
			*green_LEDs = *green_LEDs | BIT4;
		}else{
			*green_LEDs = *green_LEDs & BIT4NOT;
		}
		return;
	case 5:
		if(rw == WRITE){
			*green_LEDs = *green_LEDs | BIT5;
		}else{
			*green_LEDs = *green_LEDs & BIT5NOT;
		}
		return;
	case 6:
		if(rw == WRITE){
			*green_LEDs = *green_LEDs | BIT6;
		}else{
			*green_LEDs = *green_LEDs & BIT6NOT;
		}
		return;
	case 7:
		if(rw == WRITE){
			*green_LEDs = *green_LEDs | BIT7;
		}else{
			*green_LEDs = *green_LEDs & BIT7NOT;
		}
		return;
	}
}

//lots of fun BCD arithmetic to increment runningTotal
INT16U incrementBCD(INT16U runningTotal)
{
	if(runningTotal == 0x0255){
		printf("runningTotal reset\n");
		return 0x0001;
	}

	INT16U ONE = 0x0001;

	INT16U carry = 0x0000;
	INT16U retVal = 0x0000;

	INT16U upperNibble = (runningTotal & 0x0f00) >> 8;
	INT16U middleNibble = (runningTotal & 0x00f0) >> 4;
	INT16U lowerNibble = runningTotal & 0x000f;

	lowerNibble = lowerNibble + ONE;
	if(lowerNibble > 0x0009){
		carry = (lowerNibble + 0x0006);//convert carry to BCD
		lowerNibble = carry & 0x000f;//mask off carry, leaving lowerNibble
		carry = (carry & 0x00f0) >> 4;//mask off lowerNibble and shift right 4
		middleNibble = (middleNibble + carry);
		if(middleNibble > 0x0009){
			carry = (middleNibble + 0x0006);//convert carry to BCD
			middleNibble = carry & 0x000f;//mask off carry, leaving middleNibble
			carry = (carry & 0x00f0) >> 4;//mask off middleNibble and shift right 4
			upperNibble = (upperNibble + carry);
			if(upperNibble > 0x0009){
				carry = (upperNibble + 0x0006);//convert carry to BCD
				upperNibble = carry & 0x000f;
				carry = (carry & 0x000f) >> 4;
				lowerNibble = lowerNibble + carry;
				//reconstruct packed BCD
				retVal = retVal | (upperNibble << 8);
				retVal = retVal | (middleNibble << 4);
				retVal = retVal | lowerNibble;
				return retVal;
			}else{
				//reconstruct packed BCD
				retVal = retVal | (upperNibble << 8);
				retVal = retVal | (middleNibble << 4);
				retVal = retVal | lowerNibble;
				return retVal;
			}
		}else{
			//reconstruct packed BCD
			retVal = retVal | (upperNibble << 8);
			retVal = retVal | (middleNibble << 4);
			retVal = retVal | lowerNibble;
			return retVal;
		}
	}else{
		//reconstruct packed BCD
		retVal = retVal | (upperNibble << 8);
		retVal = retVal | (middleNibble << 4);
		retVal = retVal | lowerNibble;
		return retVal;
	}
}

//returns seven segment encoding of encode_me
INT8U sevenSegEncoder(int encode_me)
{
	switch(encode_me){
	case 0:
		return SevenSeg0;
		break;
	case 1:
		return SevenSeg1;
		break;
	case 2:
		return SevenSeg2;
		break;
	case 3:
		return SevenSeg3;
		break;
	case 4:
		return SevenSeg4;
		break;
	case 5:
		return SevenSeg5;
		break;
	case 6:
		return SevenSeg6;
		break;
	case 7:
		return SevenSeg7;
		break;
	case 8:
		return SevenSeg8;
		break;
	case 9:
		return SevenSeg9;
		break;
	}
	return SevenSeg0;
}

//prints info to NIOS II Console,
//and writes displayNumBCD to the seven segment displays
void displayDigits(INT8U RW, INT16U displayNumBCD){
	INT8U i = 0;

	//mask and shift to extract digits
	INT16U upperNibble = (displayNumBCD & 0x0f00) >> 8;
	INT16U middleNibble = (displayNumBCD & 0x00f0) >> 4;
	INT16U lowerNibble = displayNumBCD & 0x000f;

	if(RW == READ){
		*hex3 = SevenSegDASH;
		printf("Consuming: ");
	}else{
		*hex3 = SevenSegOFF;
		printf("Producing: ");
	}

	printf("%d", upperNibble);
	printf("%d", middleNibble);
	printf("%d\n", lowerNibble);

	for(i = 0; i < ringBuffer.bufSize; i++)
		printf(" %d ", ringBuffer.ring[i]);

	printf(" numElements = %d\n", ringBuffer.numElements);
	printf("**********************************************\n");

	*hex2 = sevenSegEncoder(upperNibble);
	*hex1 = sevenSegEncoder(middleNibble);
	*hex0 = sevenSegEncoder(lowerNibble);
}

//consumer task consumes numbers from the ring buffer
void consumer(void* pdata){
	//error check argument
	INT8U return_code;

	//task infinite loop
	while(1){
		OSSemPend(buffer_sem, 0, &return_code);//acquire semaphore (system call)
		alt_ucosii_check_return_code(return_code);//check for errors during system call

		if(ringBuffer.numElements <= 3){//buffer is empty release share_resource_sem
			OSSemPost(buffer_sem);//release semaphore (system call)
			alt_ucosii_check_return_code(return_code);//check for errors during system call
			OSTimeDlyHMSM(0, 0, 0, 100);//delay to allow producer to catch up (system call)
		}else{//read from buffer
			INT16U temp = ringBuffer.ring[ringBuffer.readMe];//read next number from ring[]
			ringBuffer.ring[ringBuffer.readMe] = 0;//Set that member to 0
			ringBuffer.numElements = ringBuffer.numElements - 1;//update numElements

			displayDigits(READ, temp);//display read number on seven seg displays
			lightLEDs(READ, ringBuffer.readMe);//update LEDs to reflect ring[] population

			OSTimeDlyHMSM(0, 0, 1, 0);//delay half a second to allow viewing of seven seg displays and LED array (system call)

			ringBuffer.readMe = (ringBuffer.readMe + 1) % ringBuffer.bufSize;//increment readMe to next location

			OSSemPost(buffer_sem);//release semaphore (system call)
		}
	}
}

//producer fills the ring buffer with incrementing numbers
void producer(void* pdata)
{
	//error check argument
	INT8U return_code = OS_NO_ERR;

	//producer's running total encoding packed BCD (easier to display)
	INT16U runningTotalBCD = 0x0001;

	//task infinite loop
	while(1){
		OSSemPend(buffer_sem, 0, &return_code);//acquire semaphore (system call)
		alt_ucosii_check_return_code(return_code);//check for errors during system call

		if(ringBuffer.numElements == ringBuffer.bufSize){//buffer is full, release share_resource_sem
			OSSemPost(buffer_sem);//release semaphore (system call)
			alt_ucosii_check_return_code(return_code);//check for errors during system call
			OSTimeDlyHMSM(0, 0, 0, 100);//delay to allow producer to catch up (system call)
		}else{//proceed with write operation, protected by shared_resource_sem
			INT8U writeHere = (ringBuffer.readMe + ringBuffer.numElements) % ringBuffer.bufSize;
			ringBuffer.ring[writeHere] = runningTotalBCD;//Write runningTotal to buffer

			if(ringBuffer.numElements == ringBuffer.bufSize){//producer is overwriting elements, readMe is incremented accordingly, numElements unchanged
				ringBuffer.readMe = (ringBuffer.readMe + 1) % ringBuffer.bufSize;
			}else{//no elements overwritten, increment numElements accordingly
				ringBuffer.numElements = ringBuffer.numElements + 1;
			}

			displayDigits(WRITE, runningTotalBCD);//display read number on seven seg displays
			lightLEDs(WRITE, writeHere);//update LEDs to reflect ring[] population

			OSTimeDlyHMSM(0, 0, 1, 0);//delay half a second to allow viewing of seven seg displays and LED array (system call)

			runningTotalBCD = incrementBCD(runningTotalBCD);//increment runningTotal

			OSSemPost(buffer_sem);//release semaphore (system call)
		}
	}
}

//main initializes OS data structures,
//creates producer and consumer,
//and starts the OS
int main (int argc, char* argv[], char* envp[])
{
	//initialize buffer_sem as binary semaphore
	buffer_sem = OSSemCreate(1);

	//initialize ring buffer meta data
	ringBuffer.readMe = 0;
	ringBuffer.bufSize = BUFFER_SIZE;
	ringBuffer.numElements = 0;

	//error check argument
	INT8U return_code = OS_NO_ERR;

	//create producer task
	return_code = OSTaskCreate(producer,			 //task pointer
			NULL,									 //task argument pointer (not used)
			(void*)&producer_stk[TASK_STACKSIZE - 1],//top of stack pointer (stack grows down)
			PRODUCER_PRIORITY);						 //task priority (must be unique)
	//error check
	alt_ucosii_check_return_code(return_code);

	//create consumer task
	return_code = OSTaskCreate(consumer,			//task pointer
			NULL,									//task argument pointer (not used)
			(void*)&consumer_stk[TASK_STACKSIZE -1],//top of stack pointer (stack grows down)
			CONSUMER_PRIORITY);					    //task priority (must be unique)
	//error check
	alt_ucosii_check_return_code(return_code);

	//Start the OS task switching
	OSStart();

	return 0;
}
