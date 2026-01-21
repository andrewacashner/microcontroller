/* midi_to_lcd

    Display a MIDI on/off signal on the LCD

    INPUT
        R0: Copy of MidiSignal struct
    
    OUTPUT
        None (R0: Unchanged)
    
    REGISTERS during execution
        R0: Byte to write
        R4: MidiSignal input
        
    POSTCONDITION
        Contents of MidiSignal have been shown on LCD screen

*/

/* In C:
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
*/

.global     midi_to_lcd
.extern     lcd_clear, lcd_write_char, hex_to_ascii, lcd_write_byte

.data
            .equ            SPACE_CHAR, 32

.text

midi_to_lcd:
            push            {R0, R1, R2, R3, R4, LR}
            
            mov             R4, R0              // R4 <- input MidiSignal
            bl              lcd_clear
 
            mov             R0, R4
            lsrs            R0, R0, #4          // write midi.status left digit
            bl              hex_to_ascii
            bl              lcd_write_char

            mov             R0, R4
            bl              hex_to_ascii        // write midi.status right digit
            bl              lcd_write_char

            ldr             R0, =SPACE_CHAR
            bl              lcd_write_char

            mov             R0, R4
            lsrs            R0, R0, #8
            bl              lcd_write_byte      // write midi.data1 as number

            ldr             R0, =SPACE_CHAR
            bl              lcd_write_char

            mov             R0, R4
            lsrs            R0, R0, #16
            bl              lcd_write_byte      // write midi.data2 as number

            pop             {R0, R1, R2, R3, R4, PC}
            blx             LR
.end