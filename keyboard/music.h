#ifndef MUSIC_H
#define MUSIC_H

/*-----------------------------------------------------------------------------
 *  music.h
 *
 *  DESIGNER: Andrew Cashner
 *
 *  DESCRIPTION
 *    This is a driver for playing music on the passive buzzer on our custom
 *    extension board for the MSPM0G3507 microcontroller.
 *
 *-----------------------------------------------------------------------------*/ 

/*-----------------------------------------------------------------------------
 *  INCLUDES 
 *-----------------------------------------------------------------------------*/
// C library
#include <stdint.h>
#include <stdbool.h>
#include <math.h>

// CSC 202
#include <ti/devices/msp/msp.h>
#include "clock.h"
#include "LaunchPad.h"

/*-----------------------------------------------------------------------------
 *  SYMBOLIC CONSTANTS
 *-----------------------------------------------------------------------------*/
// Pitches
#define PITCH_A4                                                          (440)
#define A4_KEY_NUM                                                         (49)
#define STEP_RATIO_12TET                                              (1.05946)

// Rhythmic durations
#define BUZZER_BPM                                                      (160.0)
#define BEAT_LENGTH_MSEC                             (1000.0 * 60 / BUZZER_BPM)

#define DUR_QUARTER                                          (BEAT_LENGTH_MSEC)
#define DUR_32ND                                          (1.0/8 * DUR_QUARTER)
#define DUR_16TH                                          (1.0/4 * DUR_QUARTER)
#define DUR_16TH_TRIPLET                                  (1.0/3 * DUR_8TH)
#define DUR_8TH                                             (2.0 * DUR_16TH)
#define DUR_8TH_TRIPLET                                   (1.0/3 * DUR_QUARTER)
#define DUR_HALF                                            (2.0 * DUR_QUARTER)
#define DUR_HALF_DOTTED                                     (3.0 * DUR_QUARTER)
#define DUR_WHOLE                                           (2.0 * DUR_HALF)

// Buzzer settings
#define BUZZER_PIN_ON                                                       (1)
#define BUZZER_INITIAL_PWM                                           (PITCH_A4) 
#define BUZZER_AMPLITUDE                                                 (4000)

/*-----------------------------------------------------------------------------
 *  DATA TYPES
 *-----------------------------------------------------------------------------*/

//  A Pitch_class_t represents a key on the piano (that is, an enharmonic
//  pitch class in an equal-tempered system). These may be thought of as
//  offsets from C.
typedef enum {
  PC_REST  = (-1),
  PC_C_FL  = (12),
  PC_C     = (0),
  PC_C_SH  = (1),
  PC_D_FL  = (1),
  PC_D     = (2),
  PC_D_SH  = (3),
  PC_E_FL  = (3),
  PC_E     = (4),
  PC_E_SH  = (5),
  PC_F_FL  = (4),
  PC_F     = (5),
  PC_F_SH  = (6),
  PC_G_FL  = (6),
  PC_G     = (7),
  PC_G_SH  = (8),
  PC_A_FL  = (8),
  PC_A     = (9),
  PC_A_SH  = (10),
  PC_B_FL  = (10),
  PC_B     = (11),
  PC_B_SH  = (12),
  PC_MAX   = (12)
} Pitch_class_t;

// A Pitch_t struct includes a pitch class (like A or C), an octave (making
// the pitch class a specific pitch, like A4 or C3), and a rhythmic duration
// (symbolic constant as defined above).
typedef struct {
  Pitch_class_t pitch_class;
  uint8_t octave;
  uint32_t duration;
} Pitch_t;


/*-----------------------------------------------------------------------------
 * FUNCTION PROTOTYPES 
 *-----------------------------------------------------------------------------*/

/*-----------------------------------------------------------------------------
 *  buzzer_init
 *
 *  DESCRIPTION
 *    This function configures the IOMUX to drive a motor using PWM. The motor
 *    control is based on the assumption that one side of the L293D IC is
 *    used.  This function repurposes LED0 for TIMA0 output 3, which is
 *    connected to the Enable pin of the L293D. LED1 and LED2 are configured
 *    as general-purpose outputs to control the direction of the motor, and
 *    these pins are connected to the IN pins of the L293D.
 *
 *  INPUT PARAMETERS
 *     None
 * 
 *  RETURN
 *     None
 *
 *  POSTCONDITIONS
 *    The buzzer is ready for use.
 *-----------------------------------------------------------------------------*/
void buzzer_init(void);

/*-----------------------------------------------------------------------------
 *  buzzer_off
 *
 *  DESCRIPTION
 *    Turn off the buzzer.
 *  
 *  INPUT PARAMETERS
 *    None
 *
 *  RETURN
 *    None
 *
 *  POSTCONDITIONS
 *    The buzzer is turned off.
 *-----------------------------------------------------------------------------*/
void buzzer_off(void);

/*-----------------------------------------------------------------------------
 *  buzzer_play_freq
 *
 *  DESCRIPTION
 *    Play the given frequency on the buzzer (forever).
 *
 *  PRECONDITIONS
 *    The buzzer is initialized and enabled.
 *
 *  INPUT PARAMETERS
 *    frequency_hz - 32-bit value with desired base frequency in Hertz
 *    amplitude    - 32-bit value with desired amplitude
 *  
 *  RETURN
 *    None
 *
 *  POSTCONDITIONS
 *    The buzzer is oscillating with a sine wave on the desired base
 *    frequency. The duty cycle has been reset.
 *-----------------------------------------------------------------------------*/
void buzzer_play_freq(uint32_t frequency_hz, uint32_t amplitude);

/*-----------------------------------------------------------------------------
 *  buzzer_play_freq_dur
 *
 *  DESCRIPTION
 *    Play the given frequency for the given duration of milliseconds, at the
 *    given amplitude, then turn the buzzer off.
 * 
 *  PRECONDITIONS
 *    The buzzer is initialized and enabled.
 *
 *  INPUT PARAMETERS
 *    frequency_hz  - 32-bit value with desired base frequency in Hertz
 *    duration_msec - 32-bit value with number of milliseconds to play
 *    amplitude     - 32-bit value with desired amplitude
 *
 *  RETURN
 *    None
 *
 *  POSTCONDITIONS
 *    The buzzer is off. Execution was delayed by the duration of the tone.
 *-----------------------------------------------------------------------------*/
void buzzer_play_freq_dur(uint32_t frequency_hz, uint32_t duration_msec,
    uint32_t amplitude);

/*-----------------------------------------------------------------------------
 *  buzzer_play_pitch
 *
 *  DESCRIPTION
 *    Play a Pitch_t object according to its pitch class, octave, and
 *    duration. Note: the object may be a rest (no sound, just duration).
 *    If the object is the constant FINE, don't do anything.
 *
 *  PRECONDITIONS
 *    The buzzer is initialized and enabled.
 *
 *  INPUT PARAMETERS
 *    pitch - Pitch_t object to play
 *  
 *  RETURN 
 *    None
 *
 *  POSTCONDITIONS
 *    The buzzer is off. Execution was delayed by the duration of the pitch.
 *-----------------------------------------------------------------------------*/
void buzzer_play_pitch(Pitch_t pitch);

/*-----------------------------------------------------------------------------
 *  buzzer_play_pitch_forever
 *
 *  DESCRIPTION
 *    Play a Pitch_t object according to its pitch class and octave, but
 *    ignore its duration and keep playing it forever (until someone else
 *    turns the buzzer off). 
 *    
 *    Note: the object may be a rest (no sound, just duration).
 *    If the object is the constant FINE, don't do anything.
 *
 *  PRECONDITIONS
 *    The buzzer is initialized and enabled.
 *
 *  INPUT PARAMETERS
 *    pitch - Pitch_t object to play
 *  
 *  RETURN 
 *    None
 *
 *  POSTCONDITIONS
 *    The buzzer is playing the given pitch. Execution does NOT wait for the
 *    pitch to finish.
 *-----------------------------------------------------------------------------*/
void buzzer_play_pitch_forever(Pitch_t pitch);

#endif /* MUSIC_H */

/* music.h */
