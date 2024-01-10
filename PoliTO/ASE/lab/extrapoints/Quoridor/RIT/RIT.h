/*********************************************************************************************************
**--------------File
*Info---------------------------------------------------------------------------------
** File name:           RIT.h
** Last modified Date:  2014-09-25
** Last Version:        V1.00
** Descriptions:        Prototypes of functions included in the lib_RIT,
*funct_RIT, IRQ_RIT .c files
** Correlated files:    lib_RIT.c, funct_RIT.c, IRQ_RIT.c
**--------------------------------------------------------------------------------------------------------
*********************************************************************************************************/
#ifndef __RIT_H
#define __RIT_H

#include <stdint.h>

extern uint32_t init_RIT(uint32_t RITInterval);
extern void enable_RIT(void);
extern void disable_RIT(void);
extern void reset_RIT(void);

/**
 * @brief Tracks joystick movements and updates the player position and walls
 * accordingly
 */
extern void RIT_IRQHandler(void);

/**
 * @brief updates either the wall or player selector, based on current mode
 *
 * @param up offset up (or down if negative)
 * @param right osset right (or left if negative)
 */
void do_update(const int up, const int right);

#endif /* end __RIT_H */
/*****************************************************************************
**                            End Of File
******************************************************************************/
