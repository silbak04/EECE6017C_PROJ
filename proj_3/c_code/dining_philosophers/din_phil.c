#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <unistd.h>
#include <string.h>
#include "alt_ucosii_simple_error_check.h"
#include "din_phil.h"

/* Mutex */
OS_EVENT *forks[NUM_PHILOSOPHERS];

/* Task Stacks */
OS_STK philosopher_stk[NUM_PHILOSOPHERS][TASK_STACKSIZE];

void eater(void *pdata)
{
    /* which philosopher am I? */
    int num = (int) pdata;

    /* right or left fork? */
    int left_fork  = num;
    int right_fork = (num + 1) % NUM_PHILOSOPHERS;

    /* keep track of time during eating or thinking */
    int time = 0;

    /* keep track of how much each philosopher has eaten */
    int gobble = 0;

    while(1)
    {
        INT8U return_code;

        /* random time between 1 and 10 seconds */
        time = (rand() % 9) + 1;

        /* Philosophers thinking */
        printf("Philosopher[%d] has gobbled down %d times and is thinking for %ds...\n", num, gobble, time);
        printf("------------------------------------------------------------------------------------------------------\n");
        OSTimeDlyHMSM(0,0,time,0);

        if (right_fork < left_fork)
        {
            /* wait to pick up right fork */
            printf("Philosopher[%d] has gobbled down %d times and is waiting to pick up Philosopher[%d]'s (right) fork...\n", num, gobble, right_fork);
            printf("------------------------------------------------------------------------------------------------------\n");
            OSSemPend(forks[right_fork], 0, &return_code);

            /* wait to pick up left fork */
            printf("Philosopher[%d] has gobbled down %d times and is waiting to pick up Philosopher[%d]'s (left) fork...\n", num, gobble, left_fork);
            printf("------------------------------------------------------------------------------------------------------\n");
            OSSemPend(forks[left_fork], 0, &return_code);
        } 
        else
        {
            /* wait to pick up left fork */
            printf("Philosopher[%d] has gobbled down %d times and is waiting to pick up Philosopher[%d]'s (left) fork...\n", num, gobble, left_fork);
            printf("------------------------------------------------------------------------------------------------------\n");
            OSSemPend(forks[left_fork], 0, &return_code);

            /* wait to pick up right fork */
            printf("Philosopher[%d] has gobbled down %d times and is waiting to pick up Philosopher[%d]'s (right) fork...\n", num, gobble, right_fork);
            printf("------------------------------------------------------------------------------------------------------\n");
            OSSemPend(forks[right_fork], 0, &return_code);
        }

        time = (rand() % 9) + 1;
        
        /* Philosophers eating */
        printf("Philosopher[%d] has gobbled down %d times and is eating for %ds...\n", num, gobble, time);
        OSTimeDlyHMSM(0,0,time,0);
        gobble++;

        /* put down left fork */
        printf("Philosopher[%d] has gobbled down %d times and is putting down Philosopher[%d]'s (left) fork...\n", num, gobble, left_fork);
        printf("------------------------------------------------------------------------------------------------------\n");
        OSSemPost(forks[left_fork]);

        /* put down right fork */
        printf("Philosopher[%d] has gobbled down %d times and is putting down Philosopher[%d]'s (right) fork...\n", num, gobble, right_fork);
        printf("------------------------------------------------------------------------------------------------------\n");
        OSSemPost(forks[right_fork]);

    }
}

void philosopher_init()
{
    int i;
	INT8U return_code = OS_NO_ERR;

    /* create forks semaphores */
    for (i = 0; i < NUM_PHILOSOPHERS; i++)
        forks[i] = OSSemCreate(1);

	/* create philosophers */
    for (i = 0; i < NUM_PHILOSOPHERS; i++)
    {
        return_code = OSTaskCreate(eater, (void *) i, (void *) &philosopher_stk[i][TASK_STACKSIZE - 1], i);
        alt_ucosii_check_return_code(return_code);
    }
}

int main (int argc, char* argv[], char* envp[])
{
    printf("------------------------------------------------------------------------------------------------------\n");

	philosopher_init();

	OSStart();

	return 0;
}
