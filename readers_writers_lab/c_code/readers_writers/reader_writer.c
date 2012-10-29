
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include "includes.h"
#include "alt_ucosii_simple_error_check.h"
#include "reader_writer.h"



/* Definition of shared_buf_sem Semaphore */
OS_EVENT *shared_write_sem;
OS_EVENT *shared_reader_sem;

/* Definition of Task Stacks */
OS_STK reader_stk[TASK_STACKSIZE];
OS_STK reader2_stk[TASK_STACKSIZE];
OS_STK reader3_stk[TASK_STACKSIZE];
OS_STK writer_stk[TASK_STACKSIZE];

void elipsis(){
	INT8U i;
	//OSTimeDlyHMSM(0,0,1,0);

	for(i=0; i<3; i++){
		printf(".");
	}
	//OSTimeDlyHMSM(0,0,4,0);
}

void reader(void *pdata){
	INT8U return_code;

	while(true)
	{
		//Hold Reader Semaphore
		OSSemPend(shared_reader_sem, 0, &return_code);
        printf("Hold Reader Semaphore\n");

		// Count number of Readers using queue
		reader_count++;

		// If first reader Hold writer semaphore or wait
		if (reader_count==1)
        {
			OSSemPend(shared_write_sem, 0, &return_code);
			printf("Hold Writer Semaphore\n");
        }

		// Release Reader semaphore and continue
        printf("Release Reader Semaphore\n");
		OSSemPost(shared_reader_sem);

		if(book_mark == 0)
		{
			//Hold Reader Semaphore
			OSSemPend(shared_reader_sem, 0, &return_code);
			printf("Hold Reader Semaphore\n");

			// Decrement number of Readers using queue
			reader_count--;

			// If no more readers release writer semaphore
			if (reader_count==0)
			{
				OSSemPost(shared_write_sem);
				printf("Release Writer Semaphore\n");
			}

			// Release Reader semaphore and delay
			printf("Release Reader Semaphore\n");
			OSSemPost(shared_reader_sem);

			OSTimeDlyHMSM(0,0,9,0);
		}
		else
		{
			INT8U index = 0;

			printf("\nReader is reading\n");
			OSTimeDlyHMSM(0,0,2,0);
            printf("Read");
			elipsis();

			while(index < book_mark){
				printf("%s ", book[index][0]);
				index += 1;
			}

			printf("\n");

			//Hold Reader Semaphore
			OSSemPend(shared_reader_sem, 0, &return_code);
			printf("Hold Reader Semaphore\n");

			// Decrement number of Readers using queue
			reader_count--;

			// If no more readers release writer semaphore
			if (reader_count==0)
			{
				printf("Release Writer Semaphore\n");
				OSSemPost(shared_write_sem);
			}

			// Release Reader semaphore and delay
			printf("Release Reader Semaphore\n");
			OSSemPost(shared_reader_sem);

			OSTimeDlyHMSM(0,0,10,0);
		}
	}
}

void writer(void *pdata){
	INT8U return_code;

	while(true)
	{
		OSSemPend(shared_write_sem, 0, &return_code);
		printf("Hold Writer Semaphore\n");

		if(book_mark == WORDS_IN_BOOK){
			book_mark = 0;
		}
		printf("\nWriter is writing\n");
        OSTimeDlyHMSM(0,0,2,0);
        printf("Writing");
		elipsis();

		book[book_mark][0] = pangram[book_mark][0];
		printf("%s \n", book[book_mark][0]);

		book_mark += 1;

		printf("Release Writer Semaphore\n");
		OSSemPost(shared_write_sem);

		OSTimeDlyHMSM(0,0,1,0);
	}
}


void  reader_writer_init()
{
	INT8U return_code = OS_NO_ERR;
	book_mark = 0;
	reader_count = 0;

	//initialize pangram
	pangram[0][0] = "A\0";
	pangram[1][0] = "quick\0";
	pangram[2][0] = "brown\0";
	pangram[3][0] = "fox\0";
	pangram[4][0] = "jumps\0";
	pangram[5][0] = "over\0";
	pangram[6][0] = "the\0";
	pangram[7][0] = "lazy\0";
	pangram[8][0] = "dog\0";

	//create writer
	return_code = OSTaskCreate(writer, NULL, (void*)&writer_stk[TASK_STACKSIZE-1], WRITER_PRIO);
	alt_ucosii_check_return_code(return_code);

	//create reader
	return_code = OSTaskCreate(reader, NULL, (void*)&reader_stk[TASK_STACKSIZE-1], READER_PRIO);
	alt_ucosii_check_return_code(return_code);

	//create reader
	return_code = OSTaskCreate(reader, NULL, (void*)&reader2_stk[TASK_STACKSIZE-1], READER_PRIO2);
	alt_ucosii_check_return_code(return_code);

	//create reader
	return_code = OSTaskCreate(reader, NULL, (void*)&reader3_stk[TASK_STACKSIZE-1], READER_PRIO3);
	alt_ucosii_check_return_code(return_code);
}


int main (int argc, char* argv[], char* envp[])
{
	shared_write_sem = OSSemCreate(1);
	shared_reader_sem = OSSemCreate(1);

	reader_writer_init();

	OSStart();

	return 0;
}
