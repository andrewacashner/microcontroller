/*
#define RADIAN ((float) M_PI / 180)

float sine_values[90] = { 0.0 };

for (uint16_t theta = 0; theta < 90; ++theta)
  { 
    float radians = (float) theta * RADIAN;
    sine_values[theta] = sin(radians);
  }
*/

/*
.global     sine_calc, sine_values
.extern     sin

.data
            .equ        RADIAN, 0.01745329252   // pi / 180

sine_values:
            .space      360                     // 90 * 32-bit float

.text

sine_calc:
            push        {R0, LR}
            subs        R4, R4, R4
            ldr         R7, =sine_values
loop:
            cmp         R4, #90
            beq         return
            // TODO floating point
            vmov        S0, R4
            vldr        S1, =RADIAN
            vmul        S0, S0, S1

            mov         R0, R5
            bl          sin
            str         R0, [R7, R4]

            adds        R4, R4, #1
return:
            pop         {R0, PC}
            blx         LR
            */