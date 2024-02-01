#include "button.h"
#include "lpc17xx.h"

#include "../led/led.h"
#include "../timer/timer.h"
#include <string.h>

extern char vector[100];
extern uint8_t input[100];
extern char output[100];

int length;
int RES;

extern int translate_morse(const char *input, const int input_length,
                           char *output, const int output_length,
                           const char change_symbol, const char space,
                           const char sentence_end);

void EINT0_IRQHandler(void) {
  LED_Out(0);

  memset(vector, 0, sizeof(vector));
  memset(output, 0, sizeof(output));

  length = 0;
  reset_timer(1);
  disable_timer(1);

  LPC_SC->EXTINT &= (1 << 0); /* clear pending interrupt         */
}

void EINT1_IRQHandler(void) {
  int i;

  LED_Out(0);

  for (i = 0; i < 100 && vector[i] != END_SENTENCE; i++) {
    vector[i] = '0' + input[i]; // converts to ASCII
  }

  length = i++;

  LED_Out(255);
  NVIC_DisableIRQ(EINT0_IRQn);
  NVIC_DisableIRQ(EINT2_IRQn);

  enable_timer(0);

  LPC_SC->EXTINT &= (1 << 1); /* clear pending interrupt         */
}

void EINT2_IRQHandler(void) {
  NVIC_DisableIRQ(EINT0_IRQn);
  NVIC_DisableIRQ(EINT1_IRQn);

  RES = translate_morse(vector, length, output, length, '2', '3', '4');

  NVIC_EnableIRQ(EINT0_IRQn);
  NVIC_EnableIRQ(EINT1_IRQn);

  enable_timer(1);

  LPC_SC->EXTINT &= (1 << 2); /* clear pending interrupt         */
}
