/* flash_leds.s
 * Andrew Cashner, 2025/12/18
 * Flash the four LP LEDs in order forever
 */

    .global led_main
    .extern aac_lp_leds_on, aac_lp_leds_off
    .extern clock_init_40mhz, launchpad_gpio_init, lp_leds_init

.data  
    .EQU    MAX_LEDS, 4
    .EQU    DELAY,    1000
.text

led_main:
    BL      clock_init_40mhz
    BL      launchpad_gpio_init
    BL      lp_leds_init

outer:
    BL      flash
    BL      outer

flash:
    PUSH    {LR}
    LDR     R0, =0
    LDR     R1, =MAX_LEDS
    LDR     R2, =DELAY

inner:
    BL      aac_lp_leds_on

    PUSH    {R0, R1, R2}
    MOV     R0, R2
    BL      msec_delay
    POP     {R0, R1, R2}

    BL      aac_lp_leds_off
    
    ADDS    R0, R0, 1 
    CMP     R0, R1
    BNE     inner
    
return:
    LDR     R0, #0
    POP     {PC}
    BLX     LR

    .END