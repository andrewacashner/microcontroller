/*---------------------------------------------------------------------
 * STATISTICS CALCULATOR
 * 
 * Andrew Cashner, 2026/01/08
 * 
 * Calculate statistics on user data on the custom hardware-software
 * system using the TI-MSPMG3507 microcontroller.
 * User can choose to input a list of numbers via the keypad,
 * display the data, sort the data, or get the minimum or maximum values.
 *
 * Sorting, min, and max, are handled via functions in ARM assembly
 * using an internal linked list.
 *---------------------------------------------------------------------*/
 
/* Potential improvements
- calculate mean, median, and standard deviation
- add blinking cursor
- why does "A" or "B" require two presses or long press?
- do 'power' in ASM
- put main switch functions into array of function pointers
*/

#include <ti/devices/msp/msp.h>
#include "LaunchPad.h"
#include "clock.h"
#include "lcd1602.h"

#define MEMORY_BYTES        (256)
#define INPUT_LENGTH        (MEMORY_BYTES / 8)
#define LCD_DELAY           (2000)
#define LCD_LINE_LENGTH     (16)
#define LCD_CURSOR_FLICKER  (200)
#define ASTERISK            (0xE)

// ASM functions
uint32_t *linked_list_create(uint32_t *array_address, uint32_t array_length);
uint32_t *linked_list_to_array(uint32_t *array_address, uint32_t *list_address);
uint32_t *sort(uint32_t *list, uint32_t length);
uint32_t linked_list_head_data(uint32_t *list_address);
uint32_t linked_list_tail_data(uint32_t *list_address);

// C functions
void lcd_display(char *line1, char *line2);
void lcd_display_array(uint32_t *array, uint8_t length);
uint8_t lcd_input(uint32_t *input);
uint32_t power(uint32_t base, uint32_t exp);
uint32_t parse_int(uint8_t *digits, uint8_t length);

void show_menu(void);

int main(void)
{
    clock_init_40mhz();
    launchpad_gpio_init();

    I2C_init();
    lcd1602_init();
    lcd_clear();

    keypad_init();

    lcd_display("   STATISTICS", "   CALCULATOR");

    uint32_t input[INPUT_LENGTH] = { 0 };
    uint8_t input_length = 0;
    uint32_t *list = NULL;

    bool sorted = false;

    while (1)
    {
        show_menu();

        uint8_t input_char = getkey_pressed();
        lcd_write_char('0' + input_char);
        msec_delay(LCD_DELAY / 2);

        switch (input_char)
        {
            case 0:
                show_menu();
                break;
                
            case 1:
                input_length = lcd_input(input);
                list = linked_list_create(input, input_length);
                linked_list_to_array(input, list);
                break;

            case 2:
                if (input_length > 0)
                {
                    lcd_display("Data:", "");
                    lcd_display_array(input, input_length);
                }
                else
                {
                    lcd_display("Invalid command.", "Enter data first");
                }
                break;

            case 3:
                if (list && !sorted)
                {
                    sort(list, input_length);
                    linked_list_to_array(input, list);
                    sorted = true;

                    lcd_display("Sorted data:", "");
                    lcd_display_array(input, input_length);
                }
                else
                {
                    lcd_display("Invalid command.", "Enter data first");
                }
                break;
            
            case 4:
                if (list)
                {
                    if (!sorted)
                    {
                        sort(list, input_length);
                        sorted = true;
                    }

                    uint32_t min = linked_list_head_data(list);
                    
                    lcd_clear();
                    lcd_write_string("Minimum value:");
                    lcd_set_ddram_addr(LCD_LINE2_ADDR);
                    lcd_write_doublebyte((uint16_t) min);
                    msec_delay(LCD_DELAY);
                    // TODO if larger than 16 bits
                }
                else
                {
                     lcd_display("Invalid command.", "Enter data first");
                }
                break;
            
             case 5:
                if (list)
                {
                    if (!sorted)
                    {
                        sort(list, input_length);
                        sorted = true;
                    }

                    uint32_t max = linked_list_tail_data(list);
                    
                    lcd_clear();
                    lcd_write_string("Maximum value:");
                    lcd_set_ddram_addr(LCD_LINE2_ADDR);
                    lcd_write_doublebyte((uint16_t) max);
                    msec_delay(LCD_DELAY);
                    // TODO if larger than 16 bits
                }
                else
                {
                     lcd_display("Invalid command.", "Enter data first");
                }
                break;

            default:
                lcd_display("Invalid input.", "Try again:");
                break;
        }
    }
}

void lcd_display(char *line1, char *line2)
{
    lcd_clear();
    lcd_set_ddram_addr(LCD_LINE1_ADDR);
    lcd_write_string(line1);
    lcd_set_ddram_addr(LCD_LINE2_ADDR);
    lcd_write_string(line2);
    msec_delay(LCD_DELAY);
}

void lcd_display_array(uint32_t *array, uint8_t length)
{
    lcd_clear();

    for (int i = 0; i < length; ++i)
    {
        if (i > 0)
        { 
            if (i % 6 == 0)
            {
                lcd_clear();
            }
            else if (i % 3 == 0) {
                lcd_set_ddram_addr(LCD_LINE2_ADDR);
            }
        }

        // TODO if larger than 16 bits
        lcd_write_doublebyte((uint16_t) array[i]);
        msec_delay(600);
    }
    
    msec_delay(1000);
}

/* 
    Prompt the user to enter a list of numbers on the keypad;
    validate the results via the LCD screen and save the data.
*/
uint8_t lcd_input(uint32_t *input)
{
    uint8_t input_length = 0;
    uint8_t chars_read = 0;
    uint8_t input_char = ' ';
    uint8_t input_values[LCD_LINE_LENGTH] = { 0 };

    bool end_list = false;

    while (!end_list)
    {
        lcd_display("Enter a number", "on the pad:");
        
        chars_read = 0;
        
        while ((input_char = getkey_pressed()) != ASTERISK)
        {
            input_values[chars_read] = input_char;
            ++chars_read;

            if (chars_read == 1)
            {
                lcd_clear();
                lcd_write_string("Press * to enter");
                lcd_set_ddram_addr(LCD_LINE2_ADDR);
            }

            lcd_write_char('0' + input_char);
            
            wait_no_key_pressed();
        }

        lcd_clear();
       
        uint32_t num = parse_int(input_values, chars_read);
        lcd_clear();
        lcd_write_string("Entered: ");
        lcd_write_doublebyte(num);
        msec_delay(LCD_DELAY);
       
        lcd_set_ddram_addr(LCD_LINE2_ADDR);
        lcd_display("Correct?", "A=yes, B=no: ");
        
        do {
             input_char = keypad_scan();
        } while (!(input_char == 0xA || input_char == 0xB));
        
        lcd_write_char(input_char == 0xA ? 'A' : 'B');
        lcd_write_string("Done");

        if (input_char == 0xA)
        {
            input[input_length] = num;
            ++input_length;
            lcd_display("Press A for next", "or B to end: ");

            do {
                input_char = keypad_scan();
            } while (!(input_char == 0xA || input_char == 0xB));

            lcd_write_char(input_char == 0xA ? 'A' : 'B');
            
            if (input_char == 0xB)
            {
                end_list = true;
            }
        }
        else 
        {
            lcd_display("OK, try again.", "");
        }

    }

    return input_length;
}

/* Reimplementation of pow */
uint32_t power(uint32_t base, uint32_t exp)
{
    uint32_t result = 1;

    for (uint8_t i = 0; i < exp; ++i)
    {
        result *= base;
    }

    return result;
}

/* Reimplementation of atoi */
uint32_t parse_int(uint8_t *digits, uint8_t length)
{
    uint32_t num = 0;

    for (uint8_t i = 0; i < length; ++i)
    {
        num += digits[length - 1 - i] * power(10, i);
    }

    return num;
}

void show_menu(void)
{
    lcd_display("      MENU", "1: Enter data");
    lcd_display("2: Display data", "3: Sort data");
    lcd_display("4: Min value", "5: Max value");
    // lcd_display("6: Mean", "7: Median");
    lcd_display("0: Show menu", "");
    lcd_display("Enter selection:", "");
    lcd_set_ddram_addr(LCD_LINE2_ADDR);
}