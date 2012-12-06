#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include "alt_ucosii_simple_error_check.h"
#include "traffic_light.h"

/* Mutex */
OS_EVENT *traffic_light;

/* Task Stacks */
OS_STK task_stack[NUM_TASKS][TASK_STACKSIZE];

int i;
int LIGHTS; 

volatile int *red_leds = (int *) RED_LEDS; 
volatile int *grn_leds = (int *) GRN_LEDS; 

volatile int *buttons  = (int *) BUTTONS;  
volatile int *switches = (int *) SWITCHES; 

volatile int *hex_0    = (int *) HEX_0; 
volatile int *hex_3    = (int *) HEX_3; 

int letters[27] = {0x08, 0x03, 0x46, 0x21, 0x04, 0x0e, 0x10, 0x09, 0x43,
                   0x61, 0x7f, 0x47, 0x7f, 0x2b, 0x23, 0x0c, 0x7f, 0x2f,
                   0x12, 0x07, 0x63, 0x7f, 0x7f, 0x7f, 0x11, 0x7f, 0x3f};

void disp_hex(char *string)
{
    if (strlen(string) < 4)
    {
        *hex_0 = BLANK;

        for (i = 2; i > -1; i--)
        {
            *(hex_3 - i * 4) = letters[string[i] - 'a'];
            //printf("hex = %p\n", (hex_3 + i*4));
        }
    }
    else
    {
        for (i = 3; i > -1; i--)
        {
            *(hex_3 - i * 4) = letters[string[i] - 'a'];
            //printf("hex = %p\n", (hex_3 + i*4));
        }
    }
    if (string == "erro")
    {
        for (i = 3; i > -1; i--)
        {
            *(hex_3 - i * 4) = letters[27];
            //printf("hex = %p\n", (hex_3 + i*4));
        }
    }
}

void flash_leds(char *string, int FLASH_LEDS, int sec, int ms)
{
    while (1)
    {
        switch(FLASH_LEDS)
        {
            case RED:

                *red_leds = FLASH_RED_LEDS;
                disp_hex(string);

                OSTimeDlyHMSM(0, 0, sec, ms);

                *red_leds = ~FLASH_RED_LEDS;
                disp_hex("zzzz");

                OSTimeDlyHMSM(0, 0, sec, ms);

                return;

            case GRN:

                *grn_leds = FLASH_GRN_LEDS;
                disp_hex(string);

                OSTimeDlyHMSM(0, 0, sec, ms);

                *red_leds = ~FLASH_GRN_LEDS;
                disp_hex("zzzz");

                OSTimeDlyHMSM(0, 0, sec, ms);
            
                return;

            case RED_GRN:

                *red_leds = FLASH_RED_LEDS;
                *grn_leds = FLASH_GRN_LEDS;
                disp_hex(string);

                OSTimeDlyHMSM(0, 0, sec, ms);

                *red_leds = ~FLASH_RED_LEDS;
                *grn_leds = ~FLASH_GRN_LEDS;
                disp_hex("zzzz");

                OSTimeDlyHMSM(0, 0, sec, ms);

                return;

            /* in case of error */
            case ERROR:

                printf("SYSTEM ERROR!\n");
                disp_hex("erro");

                OSTimeDlyHMSM(0, 0, 2, 0);

                break;

            /* default to error */
            default:
                LIGHTS = ERROR;
        }
    }

}

void flash_disp(char *string, int sec, int ms)
{
    disp_hex(string);

    OSTimeDlyHMSM(0, 0, sec, ms);

    disp_hex("zzzz");
}

/*******************************************************************************/ 
/*                                    TASK A                                   */
/*******************************************************************************/ 
/*                                                                             */
/* Primary Street is a main thoroughfare, with heavy traffic. Secondary Street */
/* is used by fewer vehicles. This difference should be reflected in the       */
/* relative times that traffic on each street has a green signal.              */
/*******************************************************************************/ 

void task_a(void *pdata)
{
    INT8U return_code;

    *grn_leds = OFF;
    *red_leds = OFF;

    /* initialize primary and secondary
       streets to have red lights */
    OSSemPend(traffic_light, 0, &return_code);

    *red_leds = RED_LIGHT;
    *grn_leds = RED_LIGHT;

    disp_hex("red");

    OSTimeDlyHMSM(0, 0, 5, 0);
    OSSemPost(traffic_light);

    LIGHTS = PRIM_GRN;

    while(1)
    {
        switch(LIGHTS)
        {
            /* primary street is green */
            case PRIM_GRN:

                LIGHTS = PRIM_YEL;

                /* lock traffic light semaphore */
                OSSemPend(traffic_light, 0, &return_code);

                *grn_leds = GRN_LIGHT;

                printf("Light is green on Primary Street.\n");
                disp_hex("pgrn");

                OSTimeDlyHMSM(0, 0, 10, 0);
                OSSemPost(traffic_light);

                break;

            /* primary street is yellow */
            case PRIM_YEL:

                LIGHTS = PRIM_RED;

                /* lock traffic light semaphore */
                OSSemPend(traffic_light, 0, &return_code);

                *grn_leds = YEL_LIGHT;

                printf("Light is yellow on Primary Street.\n");
                disp_hex("pyel");

                OSTimeDlyHMSM(0, 0, 2, 0);
                OSSemPost(traffic_light);

                break;

            /* primary street is red */ 
            case PRIM_RED:

                LIGHTS = SECN_GRN;

                /* lock traffic light semaphore */
                OSSemPend(traffic_light, 0, &return_code);

                *grn_leds = RED_LIGHT;

                printf("Light is red on Primary Street.\n");
                disp_hex("pred");

                OSTimeDlyHMSM(0, 0, 1, 0);
                OSSemPost(traffic_light);

                break;

            /* secondary street is green */
            case SECN_GRN:

                LIGHTS = SECN_YEL;

                /* lock traffic light semaphore */
                OSSemPend(traffic_light, 0, &return_code);

                *red_leds = GRN_LIGHT; 

                printf("Light is green on Secondary Street.\n");
                disp_hex("sgrn");

                OSTimeDlyHMSM(0, 0, 4, 0);
                OSSemPost(traffic_light);

                break;

            /* secondary street is yellow */
            case SECN_YEL:

                LIGHTS = SECN_RED;

                /* lock traffic light semaphore */
                OSSemPend(traffic_light, 0, &return_code);

                *red_leds = YEL_LIGHT; 

                printf("Light is yellow on Secondary Street.\n");
                disp_hex("syel");

                OSTimeDlyHMSM(0, 0, 2, 0);
                OSSemPost(traffic_light);

                break;

            /* secondary street is red */ 
            case SECN_RED:

                LIGHTS = PRIM_GRN;

                /* lock traffic light semaphore */
                OSSemPend(traffic_light, 0, &return_code);

                *red_leds = RED_LIGHT;

                printf("Light is red on Secondary Street.\n");
                disp_hex("sred");

                OSTimeDlyHMSM(0, 0, 1, 0);
                OSSemPost(traffic_light);

                break;

            /* in case of error */
            case ERROR:

                /* lock traffic light semaphore */
                OSSemPend(traffic_light, 0, &return_code);

                printf("SYSTEM ERROR!\n");
                disp_hex("erro");

                OSTimeDlyHMSM(0, 0, 2, 0);
                OSSemPost(traffic_light);

                break;

            /* default to error */
            default:
                LIGHTS = ERROR;
        }

        /* poll for lights every 5ms */
        OSTimeDlyHMSM(0, 0, 0, 5);
    }
}

/*******************************************************************************/ 
/*                                    TASK B                                   */
/*******************************************************************************/ 
/*                                                                             */
/* Primary Street also has left turn lanes onto Secondary Street (in both      */
/* directions). If there is a vehicle in either of these lanes when it is time */
/* for Primary Street to have a green signal, there should first be a task run */
/* to enable these vehicles to make left turns, while the other traffic on     */
/* Primary Street and Secondary Street gets a stop signal.                     */
/*******************************************************************************/ 

void task_b(void *pdata)
{
    INT8U return_code;

    while (1)
    {
        if (LIGHTS == PRIM_GRN       &&
           (*switches == PRIM_LTRN_1 || 
            *switches == PRIM_LTRN_2))
        {
            /* lock traffic light semaphore */
            OSSemPend(traffic_light, 0, &return_code);

            printf("We are turning left now.\n");
            disp_hex("left");

            OSTimeDlyHMSM(0, 0, 3, 0);
            OSSemPost(traffic_light);
        }

        /* poll for switches every 5 ms */
        OSTimeDlyHMSM(0, 0, 0, 5);
    }
}

/*******************************************************************************/ 
/*                                    TASK C                                   */
/*******************************************************************************/ 
/*                                                                             */
/* There are also pedestrian buttons for crossing both Primary Street and      */ 
/* Secondary Street. If any of these buttons is pushed, a task to make all     */
/* vehicles stop and allow for pedestrians to cross the streets should be run. */
/*******************************************************************************/ 

void task_c(void *pdata)
{
    int cwlk_button = 0;
    INT8U return_code;
    
    while (1)
    {
        if (*buttons == PRIM_CWLK ||
           (*buttons == SECN_CWLK))
        {
            if (*buttons == PRIM_CWLK) 
                printf("Primary crosswalk button has been pressed\n");
            else 
                printf("Secondary crosswalk button has been pressed\n");

            OSSemPend(traffic_light, 0, &return_code);

            cwlk_button = 1;

            OSTimeDlyHMSM(0, 0, 5, 0);
            OSSemPost(traffic_light);
        }

        if (cwlk_button == 1 && 
           (LIGHTS == PRIM_GRN))
        {
            //*grn_leds = 0x80;
            OSSemPend(traffic_light, 0, &return_code);

            printf("Pedestrians are now crossing!\n"); 
            disp_hex("crss");

            OSTimeDlyHMSM(0, 0, 5, 0);
            OSSemPost(traffic_light);

            cwlk_button = 0;

        }

        else if (cwlk_button == 1 &&
                (LIGHTS == SECN_GRN))
        {
            //*grn_leds = 0x40;
            OSSemPend(traffic_light, 0, &return_code);

            printf("Pedestrians are now crossing!\n"); 
            disp_hex("crss");

            OSTimeDlyHMSM(0, 0, 5, 0);
            OSSemPost(traffic_light);

            cwlk_button = 0;
        }

        /* poll for button press every 5 ms */
        OSTimeDlyHMSM(0, 0, 0, 5);

    }

}

/*******************************************************************************/ 
/*                                    TASK D                                   */
/*******************************************************************************/ 
/*                                                                             */
/* There is also an emergency setting, which sets lights in all directions to  */
/* flashing red. This setting is triggered by a special signal which includes  */
/* a specific duration to be in this state. At the end of this time, the       */
/* system should return to task A.                                             */
/*******************************************************************************/ 

void task_d(void *pdata)
{
    int lock = 0;
    INT8U return_code;

    while (1)
    {
        while (*switches == EMERGENCY)
        { 
            if (lock == 0)
            {
                OSSemPend(traffic_light, 0, &return_code);
                *grn_leds = OFF;
                lock = 1;
            }

            if (lock)
            {
                printf("EMERGENCY!!!!\n");
                flash_leds("attn", RED, 0, 500);
            }
        }

        if (lock) OSSemPost(traffic_light);
        lock = 0;

        /* poll for switch every 5 ms */
        OSTimeDlyHMSM(0, 0, 0, 5);
    }
}

/*******************************************************************************/ 
/*                                    TASK E                                   */
/*******************************************************************************/ 
/*                                                                             */
/* There is also a “broken” setting which is activated when there is a power   */
/* outage, e.g., and which sets the signals on Primary Street to flashing      */
/* YELLOW and the signals on Secondary Street to flashing RED. This setting is */
/* deactivated manually, with a return to task A. There is also an emergency   */
/* setting, which sets lights in all directions to flashing red. This setting  */
/* is triggered by a special signal which includes a specific duration to be   */
/* in this state. At the end of this time, the system should return to task A. */
/*******************************************************************************/ 

void task_e(void *pdata)
{
    int lock = 0;
    INT8U return_code;

    while (1)
    {
        while (*switches == POWER_OUT)
        { 
            if (lock == 0)
            {
                OSSemPend(traffic_light, 0, &return_code);
                lock = 1;
            }

            if (lock)
            {
                printf("Lights are out due to power outage.\n");
                flash_leds("pout", RED_GRN, 0, 500);
            }
        }

        if (lock) OSSemPost(traffic_light);
        lock = 0;

        /* poll for switch every 5 ms */
        OSTimeDlyHMSM(0, 0, 0, 5);
    }
}

/*******************************************************************************/ 
/*                                    TASK F                                   */
/*******************************************************************************/ 
/*                                                                             */
/* And finally there is a manual setting in which the signals are switched by  */
/* hand. This task is triggered by a switch operated by a human and is turned  */
/* off by another switch, at which time the system should return to task A.    */
/*******************************************************************************/ 

void task_f(void *pdata)
{
    INT8U return_code;
}

void traffic_light_init(void)
{
	INT8U return_code = OS_NO_ERR;

    /* create traffic light semaphore */
    traffic_light = OSSemCreate(1);

	/* create task A */
    return_code = OSTaskCreate(task_a, NULL, (void *) &task_stack[0][TASK_STACKSIZE - 1], TASK_A_PRIORITY);
    alt_ucosii_check_return_code(return_code);

	/* create task B */
    return_code = OSTaskCreate(task_b, NULL, (void *) &task_stack[1][TASK_STACKSIZE - 1], TASK_B_PRIORITY);
    alt_ucosii_check_return_code(return_code);

	/* create task C */
    return_code = OSTaskCreate(task_c, NULL, (void *) &task_stack[2][TASK_STACKSIZE - 1], TASK_C_PRIORITY);
    alt_ucosii_check_return_code(return_code);

	/* create task D */
    return_code = OSTaskCreate(task_d, NULL, (void *) &task_stack[3][TASK_STACKSIZE - 1], TASK_D_PRIORITY);
    alt_ucosii_check_return_code(return_code);

	/* create task E */
    return_code = OSTaskCreate(task_e, NULL, (void *) &task_stack[4][TASK_STACKSIZE - 1], TASK_E_PRIORITY);
    alt_ucosii_check_return_code(return_code);

	///* create task F */
    //return_code = OSTaskCreate(task_f, NULL, (void *) &task_stack[5][TASK_STACKSIZE - 1], TASK_F_PRIORITY);
    //alt_ucosii_check_return_code(return_code);
}

int main (int argc, char *argv[], char *envp[])
{
	traffic_light_init();

	OSStart();

	return 0;
}
