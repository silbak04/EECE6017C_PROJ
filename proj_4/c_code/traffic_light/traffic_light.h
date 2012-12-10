#define HEX_0               0x01003030
#define HEX_1               0x01003040
#define HEX_2               0x01003050
#define HEX_3               0x01003060

#define BUTTONS             0x01003070
#define SWITCHES            0x01003080

#define GRN_LEDS            0x01003090
#define RED_LEDS            0x010030a0

#define GPIO_0              0x010030b0
#define GPIO_1              0x010030c0

#define NUM_TASKS           6

#define TASK_STACKSIZE      2048

#define TASK_A_PRIORITY     5
#define TASK_B_PRIORITY     4
#define TASK_C_PRIORITY     3
#define TASK_D_PRIORITY     2
#define TASK_E_PRIORITY     1
#define TASK_F_PRIORITY     0

#define PRIM_GRN            0
#define PRIM_YEL            1
#define PRIM_RED            2

#define SECN_GRN            3
#define SECN_YEL            4
#define SECN_RED            5

#define LEFT_TRN_1          6
#define LEFT_TRN_2          7

#define GRN_LIGHT           0x10
#define YEL_LIGHT           0x04 
#define RED_LIGHT           0x01
#define LTN_LIGHT_1         0x80
#define LTN_LIGHT_2         0x40

#define PRIM_CWLK           0x07
#define SECN_CWLK           0x0b

#define PRIM_LTRN_1         0x04
#define PRIM_LTRN_2         0x02

#define FLASH_RED_LEDS      0x3ff
#define FLASH_GRN_LEDS      0xff

#define EMERGENCY           0x280
#define POWER_OUT           0x140
#define MANUAL_SET          0x201
#define MANUAL_LIGHT        0xe
#define LAST_LIGHT          7

#define RED                 0
#define GRN                 1
#define RED_GRN             2

#define BLANK               0x7f
#define OFF                 0x000
