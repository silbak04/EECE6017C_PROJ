/*
 * producer_consumer_enums.h
 *
 *  Created on: Aug 27, 2012
 *      Author: Eric
 */

#ifndef ENUMERATIONS_H_
#define ENUMERATIONS_H_

//ensure these PIO BARS are correct
//(Programmed I/O Base Address Registers)
/*#define green_LEDs (INT8U *) 0x01003030
#define hex3 (INT8U *) 0x01003040
#define hex2 (INT8U *) 0x01003050
#define hex1 (INT8U *) 0x01003060
#define hex0 (INT8U *) 0x01003070*/

#define green_LEDs (INT8U *) 0x01002070 
#define hex3 (INT8U *) 0x01002060 
#define hex2 (INT8U *) 0x01002050 
#define hex1 (INT8U *) 0x01002040 
#define hex0 (INT8U *) 0x01002030 

//task priorities, the producer one step higher (lower priority# = higher priority)
#define CONSUMER_PRIORITY 10
#define PRODUCER_PRIORITY 9

#define TASK_STACKSIZE 2048
#define BUFFER_SIZE 8
#define SEMAPHORE_TIMEOUT 0 //Wait FOR-EV-ER

#define WRITE 0
#define READ 1

//bit patterns lighting green LEDs
//LEDs active high
//used by lightLEDs()
#define BIT0 0x01
#define BIT0NOT 0xFE
#define BIT1 0x02
#define BIT1NOT 0xFD
#define BIT2 0x04
#define BIT2NOT 0xFB
#define BIT3 0x08
#define BIT3NOT 0xF7
#define BIT4 0x10
#define BIT4NOT 0xEF
#define BIT5 0x20
#define BIT5NOT 0xDF
#define BIT6 0x40
#define BIT6NOT 0xBF
#define BIT7 0x80
#define BIT7NOT 0x7F

//seven segment display encodings
//seven segment display active low
//used by sevenSegEncoder()
#define SevenSegDASH 0x3f;
#define SevenSegOFF 0x7f;
#define SevenSeg0 0x40
#define SevenSeg1 0x79
#define SevenSeg2 0x24
#define SevenSeg3 0x30
#define SevenSeg4 0x19
#define SevenSeg5 0x12
#define SevenSeg6 0x02
#define SevenSeg7 0x58
#define SevenSeg8 0x00
#define SevenSeg9 0x18

#endif /* ENUMERATIONS_H_ */
