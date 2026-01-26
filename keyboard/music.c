// See documentation in "music.h"
#include "music.h"

// Return a key number for a given pitch.
//
// Piano keys start on A but pitch class numbers start on C and octaves
// increment at C, hence the + 4 at the end
uint8_t Pitch_key_num(Pitch_t pitch)
{
  uint8_t octave_offset = 12 * (pitch.octave - 1) + 4;
  return pitch.pitch_class + octave_offset;
} /* Pitch_key_num */

// Return the frequency corresponding to a key number, in 12-TET equal temperament.
//
// Note: We have to invert the ratio for the buzzer (TODO Why?)
//
// Formula from https://en.wikipedia.org/wiki/Equal_temperament
float equal_tempered_frequency_hz(uint8_t key_num)
{
  return PITCH_A4 / pow(STEP_RATIO_12TET, key_num - A4_KEY_NUM);
} /* equal_tempered_frequency_hz */

float Pitch_frequency(Pitch_t pitch)
{
  return equal_tempered_frequency_hz(Pitch_key_num(pitch));
} /* Pitch_frequency */

float sine_values[90] = { 0.0 };


/* 
Initialize the buzzer motor and precalculate sine values for
radians 0 < theta < pi / 2; we can calculate everything from those.
Requires 90 * 32-bit float (360B) space and some constant time for lookups,
but avoids having to calculate the sin for all angles for every single
pitch.
*/
void buzzer_init(void)
{
  motor0_init();

  for (uint16_t theta = 0; theta < 90; ++theta)
  { 
    float radians = (float) theta * RADIAN;
    sine_values[theta] = sin(radians);
  }
} /* buzzer_init */

void buzzer_on(void) {
  led_on(BUZZER_PIN_ON);
} /* buzzer_on */

void buzzer_off(void) {
  leds_off();
  motor0_pwm_disable();
} /* buzzer_off */

void buzzer_play_freq(uint32_t frequency_hz, uint32_t amplitude)
{
  motor0_pwm_init(frequency_hz, 0);
  motor0_pwm_enable();
  buzzer_on();

  motor0_set_pwm_count(frequency_hz);

  // Adapted from Freenove tutorial
  // Calculate sound frequency according to the sine of theta
  // Set PWM to the appropriate duty cycle
  uint16_t theta = 0;
  uint32_t tone = frequency_hz;
  
  for (theta = 0; theta < 90; ++theta)
  {
    tone = frequency_hz + amplitude * sine_values[theta];
    motor0_set_pwm_count(tone);
  } 
  for (; theta > 0; --theta)
  {
    tone = frequency_hz + amplitude * sine_values[theta];
    motor0_set_pwm_count(tone);
  } 
  for (; theta < 90; ++theta)
  {
    tone = frequency_hz + amplitude * -sine_values[theta];
    motor0_set_pwm_count(tone);
  } 
  for (; theta > 0; --theta)
  {
    tone = frequency_hz + amplitude * -sine_values[theta];
    motor0_set_pwm_count(tone);
  } 
  
} /* buzzer_play_freq */

void buzzer_play_freq_dur(uint32_t frequency_hz, 
    uint32_t duration_msec,
    uint32_t amplitude)
{
  if (frequency_hz != 0) {
    buzzer_play_freq(frequency_hz, amplitude);
  }

  msec_delay(duration_msec);

  if (frequency_hz != 0) {
    buzzer_off();
  }
} /* buzzer_play_freq_dur */

void buzzer_play_pitch(Pitch_t pitch) 
{
  buzzer_play_freq_dur(Pitch_frequency(pitch), 
      pitch.duration, BUZZER_AMPLITUDE);
} /* buzzer_play_pitch */

void buzzer_play_pitch_forever(Pitch_t pitch)
{
    buzzer_play_freq(Pitch_frequency(pitch), BUZZER_AMPLITUDE);
} /* buzzer_play_pitch_forever */

/* music.c */
