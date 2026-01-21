
/*
    read_midi

    Wait for a single MIDI signal input (NOTE ON or NOTE OFF only), parse and save it.

    INPUT
        R0: Address of MidiSignal struct instance
    
    OUTPUT
        None (R0: Unchanged)
    
    REGISTERS during execution
        R0: Input byte
        R1: Address of MidiSignal struct

    POSTCONDITION
        Execution paused while waiting for MIDI input;
        contents of struct at R0 have been updated with last received MIDI signal
*/

/* In C:
#define MIDI_NOTE_ON    (0x90)
#define MIDI_NOTE_OFF   (0x80)
uint8_t input_byte = 0;

while (!((input_byte = UART_in_char()) == MIDI_NOTE_ON
        || input_byte == MIDI_NOTE_OFF))
{ };

input.status = input_byte;
input.data1 = UART_in_char();
input.data2 = UART_in_char();
*/



.global     read_midi
.extern     UART_in_char

.data
            .equ            MIDI_NOTE_ON,  0x90
            .equ            MIDI_NOTE_OFF, 0x80

.text

read_midi:
            push            {R0, R1, LR}
            mov             R1, R0              // R1 <- Address of MidiSignal struct
            subs            R0, R0, R0          // R0 <- 0

wait:
            bl              UART_in_char        // R0 <- next character input from UART
            cmp             R0, #MIDI_NOTE_ON
            beq             read
            cmp             R0, #MIDI_NOTE_OFF
            beq             read                // if NOTE_ON or NOTE_OFF, read value
            bl              wait                // otherwise keep waiting for valid input

read:
            strb            R0, [R1]            // store signal.status
            
            bl              UART_in_char      
            strb            R0, [R1, #1]        // read, store signal.data1

            bl              UART_in_char   
            strb            R0, [R1, #2]        // read, store signal.data2
    
            pop             {R0, R1, PC}
            blx             LR

.end