/*
    sine_wave

    Fill a buffer with sine values for angles 0 to 360

    AUTHOR
        Andrew Cashner, 2026/01/21

    INPUT
        R0: Address of array (length: 360 floats)
    
    OUTPUT
        None
    
    PRECONDITION
        Given array is of correct size

    POSTCONDITION
        Sine values have been written to buffer

    REGISTERS during execution
*/

/*
uint32_t tones[360] = {0};

 for (float theta = 0; theta < 360; ++theta)
  { 
    // Calculate the sine of theta in degrees
    float sin_deg = sin(theta * (M_PI / 180)); 

    // Calculate sound frequency according to the sine of theta
    tones[theta] = frequency_hz + amplitude * sin_deg;
}

// alternative
for (float theta = 0; theta < 90; ++theta)
{
    float sincos[2] = sincos(theta * (MPI / 180));
    tones[theta]       = sincos[0];
    tones[theta + 90]  = sincos[1];
    tones[theta + 180] = -sincos[0];
    tones[theta + 270] = -sincos[1];
*/

.global     sine_wave

.data
            .equ        MATHACL_PWREN, 0x404BF800
/*
            .equ        PI_180, 0.017453293
*/
.text

sine_wave:

            push        {R0, R1, LR}
           

/*
            subs        R1, R1, R1

loop:
            cmp         R1, #360
            beq         return

            muls        R2, R1, =PI_180
            
           // set func to 1h
           // set numiter to num iterations
           
            mov         R0, R2              // sincos
            str         R??, [R0, R1]
            bl          loop

return:
*/
            pop         {R0, R1, PC}
            blx         LR

.end