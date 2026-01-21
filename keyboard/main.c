
#include <stdio.h>

#include <ti/devices/msp/msp.h>
#include "clock.h"
#include "LaunchPad.h"
#include "lcd1602.h"
#include "uart.h"
#include "music.h"

#define BAUD_RATE       (31250)
#define MIDI_NOTE_OFF   (0x80)

typedef struct MidiSignal {
    uint8_t status;
    uint8_t data1;
    uint8_t data2;
} MidiSignal;

void buzzer_play_midi(MidiSignal signal);

// ASM
void read_midi(MidiSignal *input);
void midi_to_lcd(MidiSignal midi);

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
        read_midi(&input);
        midi_to_lcd(input);
        buzzer_play_midi(input);
    }

} /* main */

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
