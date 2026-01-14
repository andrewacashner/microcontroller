 .GLOBAL aac_lp_leds_off

    .data

// CONSTANTS
    .EQU    GPIOA,              0x400A1280
    .EQU    GPIOB,              0x400A3280

LP_LED_MASKS:
    .BYTE   0     // LP_LED_RED_MASK
    .BYTE   26    // LP_RGB_RED_MASK
    .BYTE   27    // LP_RGB_GREEN_MASK
    .BYTE   22    // LP_RGB_BLUE_MASK

.text

aac_lp_leds_off:
    CMP     R0, #0
    BNE     RGB

    // Find and read memory at pin address
    LDR     R4, =GPIOA
    LDR     R5, [R4]

    // Set bit using bitmask (use complement because active low)
    LDR     R6, =1
    ORRS    R5, R6
    STR     R5, [R4]

    B       RETURN
    
RGB:
    LDR     R4, =GPIOB
    LDR     R5, [R4]

    // Create bitmask (active high)
    LDR     R6, =LP_LED_MASKS
    ADDS    R6, R0
    LDRB    R7, [R6]
    LDR     R6, =1
    LSLS    R6, R6, R7

    // Set bit using bitmask
    MVNS    R6, R6
    ANDS    R5, R6
    STR     R5, [R4]

RETURN:
    BLX     LR

    .END
