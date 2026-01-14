/*
 #define LP_RED_LED1_IDX                                                      (0)
 #define LP_RGB_RED_LED_IDX                                                   (1)
 #define LP_RGB_GRN_LED_IDX                                                   (2)
 #define LP_RGB_BLU_LED_IDX                                                   (3)
 #define MAX_NUM_LP_LEDS                                                      (4)

 #define GPIO_PORTA                                                           (0)
 #define GPIO_PORTB                                                           (1)

  Defines for RED LED1 on Launchpad
 #define LP_LED_RED_PORT                                             (GPIO_PORTA)
 #define LP_LED_RED_MASK                                                 (1 << 0)
 #define LP_LED_RED_IOMUX                                          (IOMUX_PINCM1)

  Defines for RGB LED on Launchpad
 #define LP_RGB_RED_PORT                                             (GPIO_PORTB)
 #define LP_RGB_RED_MASK                                                (1 << 26)
 #define LP_RGB_RED_IOMUX                                         (IOMUX_PINCM57)
 #define LP_RGB_GRN_PORT                                             (GPIO_PORTB)
 #define LP_RGB_GRN_MASK                                                (1 << 27)
 #define LP_RGB_GRN_IOMUX                                         (IOMUX_PINCM58)
 #define LP_RGB_BLU_PORT                                             (GPIO_PORTB)
 #define LP_RGB_BLU_MASK                                                (1 << 22)
 #define LP_RGB_BLU_IOMUX                                         (IOMUX_PINCM50)

 typedef struct
 {
   uint8_t  port_id
   uint32_t bit_mask
   uint16_t pin_cm
   uint8_t  polarity
 } gpio_struct
 const gpio_struct lp_led_config_data[] = {
         {LP_LED_RED_PORT, LP_LED_RED_MASK, LP_LED_RED_IOMUX, ACTIVE_LOW},
         {LP_RGB_RED_PORT, LP_RGB_RED_MASK, LP_RGB_RED_IOMUX, ACTIVE_HIGH},
         {LP_RGB_GRN_PORT, LP_RGB_GRN_MASK, LP_RGB_GRN_IOMUX, ACTIVE_HIGH},
         {LP_RGB_BLU_PORT, LP_RGB_BLU_MASK, LP_RGB_BLU_IOMUX, ACTIVE_HIGH}
 }

 lp_leds_on(uint8_t index)
 {

   if (lp_led_config_data[index].port_id == GPIO_PORTA)
   {
     if (lp_led_config_data[index].polarity == ACTIVE_HIGH)
     {
       GPIOA->DOUT31_0 |= lp_led_config_data[index].bit_mask
     } 
     else
     {
       GPIOA->DOUT31_0 &= ~lp_led_config_data[index].bit_mask
     } 
   } 
   else
   {
     if (lp_led_config_data[index].polarity == ACTIVE_HIGH)
     {
       GPIOB->DOUT31_0 |= lp_led_config_data[index].bit_mask
     } 
     else
     {
       GPIOB->DOUT31_0 &= ~lp_led_config_data[index].bit_mask
     }
   }
 }

 typedef struct {
        uint32_t RESERVED0[256]
   __IO uint32_t FSUB_0                            // !< (@ 0x00000400) Subsciber Port 0 
   __IO uint32_t FSUB_1                            // !< (@ 0x00000404) Subscriber Port 1 
        uint32_t RESERVED1[15]
   __IO uint32_t FPUB_0                            // !< (@ 0x00000444) Publisher Port 0 
   __IO uint32_t FPUB_1                            // !< (@ 0x00000448) Publisher Port 1 
        uint32_t RESERVED2[237]
   GPIO_GPRCM_Regs  GPRCM                             // !< (@ 0x00000800) 
        uint32_t RESERVED3[510]
   __IO uint32_t CLKOVR                            // !< (@ 0x00001010) Clock Override 
        uint32_t RESERVED4
   __IO uint32_t PDBGCTL                           // !< (@ 0x00001018) Peripheral Debug Control 
        uint32_t RESERVED5
   GPIO_CPU_INT_Regs  CPU_INT                           // !< (@ 0x00001020) 
        uint32_t RESERVED6
   GPIO_GEN_EVENT0_Regs  GEN_EVENT0                        // !< (@ 0x00001050) 
        uint32_t RESERVED7
   GPIO_GEN_EVENT1_Regs  GEN_EVENT1                        // !< (@ 0x00001080) 
        uint32_t RESERVED8[13]
   __IO uint32_t EVT_MODE                          // !< (@ 0x000010E0) Event Mode 
        uint32_t RESERVED9[6]
   __I  uint32_t DESC                              // !< (@ 0x000010FC) Module Description 
        uint32_t RESERVED10[64]
   __O  uint32_t DOUT3_0                           // !< (@ 0x00001200) Data output 3 to 0 
   __O  uint32_t DOUT7_4                           // !< (@ 0x00001204) Data output 7 to 4 
   __O  uint32_t DOUT11_8                          // !< (@ 0x00001208) Data output 11 to 8 
   __O  uint32_t DOUT15_12                         // !< (@ 0x0000120C) Data output 15 to 12 
   __O  uint32_t DOUT19_16                         // !< (@ 0x00001210) Data output 19 to 16 
   __O  uint32_t DOUT23_20                         // !< (@ 0x00001214) Data output 23 to 20 
   __O  uint32_t DOUT27_24                         // !< (@ 0x00001218) Data output 27 to 24 
   __O  uint32_t DOUT31_28                         // !< (@ 0x0000121C) Data output 31 to 28 
        uint32_t RESERVED11[24]
   __IO uint32_t DOUT31_0                          // !< (@ 0x00001280) Data output 31 to 0 
        uint32_t RESERVED12[3]
   __O  uint32_t DOUTSET31_0                       // !< (@ 0x00001290) Data output set 31 to 0 
        uint32_t RESERVED13[3]
   __O  uint32_t DOUTCLR31_0                       // !< (@ 0x000012A0) Data output clear 31 to 0 
        uint32_t RESERVED14[3]
   __O  uint32_t DOUTTGL31_0                       // !< (@ 0x000012B0) Data output toggle 31 to 0 
        uint32_t RESERVED15[3]
   __IO uint32_t DOE31_0                           // !< (@ 0x000012C0) Data output enable 31 to 0 
        uint32_t RESERVED16[3]
   __O  uint32_t DOESET31_0                        // !< (@ 0x000012D0) Data output enable set 31 to 0 
        uint32_t RESERVED17[3]
   __O  uint32_t DOECLR31_0                        // !< (@ 0x000012E0) Data output enable clear 31 to 0 
        uint32_t RESERVED18[7]
   __I  uint32_t DIN3_0                            // !< (@ 0x00001300) Data input 3 to 0 
   __I  uint32_t DIN7_4                            // !< (@ 0x00001304) Data input 7 to 4 
   __I  uint32_t DIN11_8                           // !< (@ 0x00001308) Data input 11 to 8 
   __I  uint32_t DIN15_12                          // !< (@ 0x0000130C) Data input 15 to 12 
   __I  uint32_t DIN19_16                          // !< (@ 0x00001310) Data input 19 to 16 
   __I  uint32_t DIN23_20                          // !< (@ 0x00001314) Data input 23 to 20 
   __I  uint32_t DIN27_24                          // !< (@ 0x00001318) Data input 27 to 24 
   __I  uint32_t DIN31_28                          // !< (@ 0x0000131C) Data input 31 to 28 
        uint32_t RESERVED19[24]
   __I  uint32_t DIN31_0                           // !< (@ 0x00001380) Data input 31 to 0 
        uint32_t RESERVED20[3]
   __IO uint32_t POLARITY15_0                      // !< (@ 0x00001390) Polarity 15 to 0 
        uint32_t RESERVED21[3]
   __IO uint32_t POLARITY31_16                     // !< (@ 0x000013A0) Polarity 31 to 16 
        uint32_t RESERVED22[23]
   __IO uint32_t CTL                               // !< (@ 0x00001400) FAST WAKE GLOBAL EN 
   __IO uint32_t FASTWAKE                          // !< (@ 0x00001404) FAST WAKE ENABLE 
        uint32_t RESERVED23[62]
   __IO uint32_t SUB0CFG                           // !< (@ 0x00001500) Subscriber 0 configuration 
        uint32_t RESERVED24
   __IO uint32_t FILTEREN15_0                      // !< (@ 0x00001508) Filter Enable 15 to 0 
   __IO uint32_t FILTEREN31_16                     // !< (@ 0x0000150C) Filter Enable 31 to 16 
   __IO uint32_t DMAMASK                           // !< (@ 0x00001510) DMA Write MASK 
        uint32_t RESERVED25[3]
   __IO uint32_t SUB1CFG                           // !< (@ 0x00001520) Subscriber 1 configuration 
 } GPIO_Regs

 #define GPIOA_BASE   (0x400A0000U)     //!< Base address of module GPIOA 
 #define GPIOB_BASE   (0x400A2000U)     //!< Base address of module GPIOB 

 static GPIO_Regs *const GPIOA = ((GPIO_Regs *) GPIOA_BASE)
 static GPIPO_Regs *const GPIOB = ((GPIO_Regs *) GPIOB_BASE)

 R0 - input parameter: led index
     if led 0 -> use gpio_porta, active low else gpio_portb, active_high
 if led is 0:
  GPIOA->DOUT31_0 &= ~ (1 << 0)
 else
   GPIOB->DOUT31_0 |= (1 << color) where color = red 26, green 27, blue 22
*/
    .GLOBAL aac_lp_leds_on

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

aac_lp_leds_on:
    CMP     R0, #0
    BNE     RGB

    // Find and read memory at pin address
    LDR     R4, =GPIOA
    LDR     R5, [R4]

    // Set bit using bitmask (use complement because active low)
    LDR     R6, =1
    MVNS    R6, R6
    ANDS    R5, R6
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
    ORRS    R5, R6
    STR     R5, [R4]

RETURN:
    BLX     LR

    .END



