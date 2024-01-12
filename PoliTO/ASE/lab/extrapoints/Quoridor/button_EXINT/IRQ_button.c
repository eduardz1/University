#include "LPC17xx.h"
#include "button.h"

#define CLEAR_PENDING_INTERRUPT(n) LPC_SC->EXTINT &= (1 << n);

void EINT0_IRQHandler(void) /* INT0 */
{
    CLEAR_PENDING_INTERRUPT(0)
}

void EINT1_IRQHandler(void) /* KEY1 */
{
    NVIC_DisableIRQ(EINT1_IRQn);       /* disable Button interrupts			 */
    LPC_PINCON->PINSEL4 &= ~(1 << 22); /* GPIO pin selection */
    CLEAR_PENDING_INTERRUPT(1)
}

void EINT2_IRQHandler(void) /* KEY2 */
{
    NVIC_DisableIRQ(EINT2_IRQn);       /* disable Button interrupts			 */
    LPC_PINCON->PINSEL4 &= ~(1 << 24); /* GPIO pin selection */
    CLEAR_PENDING_INTERRUPT(2)
}
