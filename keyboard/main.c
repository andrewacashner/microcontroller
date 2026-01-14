
#include <stdio.h>

#include <ti/devices/msp/msp.h>
#include "clock.h"
#include "LaunchPad.h"
#include "lcd1602.h"
#include "uart.h"
#include "music.h"

#define BAUD_RATE       (31250)
#define LCD_LINE_LENGTH (16)
#define ENTER_KEY       ('\r')
#define BACKSPACE_KEY   ('\b')
#define MIDI_NOTE_ON    (0x90)
#define MIDI_NOTE_OFF   (0x80)

typedef struct MidiSignal {
    uint8_t status;
    uint8_t data1;
    uint8_t data2;
} MidiSignal;

void MidiSignal_to_lcd(MidiSignal signal);
void buzzer_play_midi(MidiSignal signal);

int main(void)
{
    clock_init_40mhz();
    launchpad_gpio_init();

    I2C_init();
    lcd1602_init();
    lcd_clear();

    led_init();
    led_enable();
  
    UART_init(BAUD_RATE);

    buzzer_init();

    MidiSignal input = { 0, 0, 0 };

    while (1)
    {
        uint8_t input_byte = 0;

        while (!((input_byte = UART_in_char()) == MIDI_NOTE_ON
                 || input_byte == MIDI_NOTE_OFF))
        { /* just wait for valid signal */ };

        input.status = input_byte;
        input.data1 = UART_in_char();
        input.data2 = UART_in_char();

        MidiSignal_to_lcd(input);
        buzzer_play_midi(input);
    }
    
    while (1);

} /* main */

void MidiSignal_to_lcd(MidiSignal signal)
{
    lcd_clear();
    lcd_write_char(hex_to_ascii(signal.status >> 4));
    lcd_write_char(hex_to_ascii(signal.status));
    lcd_write_char(' ');
    lcd_write_byte(signal.data1);
    lcd_write_char(' ');
    lcd_write_byte(signal.data2);
}

void buzzer_play_midi(MidiSignal signal)
{
    static uint8_t previous = 0;

    if (signal.status == MIDI_NOTE_OFF)
    {
        if (previous == signal.data1)
        {
            buzzer_off();
            previous = 0;
        }
    }
    else {
        Pitch_t pitch = { 
            .pitch_class = signal.data1 % 12, 
            .octave      = signal.data1 / 12,
            .duration    = 0 
        };
        buzzer_play_pitch_forever(pitch);
        previous = signal.data1;
    }
}
