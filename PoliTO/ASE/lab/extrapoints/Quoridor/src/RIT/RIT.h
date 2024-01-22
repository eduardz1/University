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

#include <stdbool.h>
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
 * @param show if set to false the selector clears itself
 * @return struct Coordinate with {x, y} the current offset
 */
struct Coordinate
handle_update_selector(const int8_t up, const int8_t right, bool show);

/**
 * @brief refreshes the info panel in the top right corner
 *
 * @param counter counter used to keep track of the time
 */
void handle_info_panel(uint32_t *counter);

/**
 * @brief handles of of the 5 joystick operations
 *
 * @param counter counter for the move's timer
 * @param offset offset of the current move from the player or the center (in
 * case of a wall placement type move)
 */
void handle_joystick(uint32_t *counter, struct Coordinate *offset);

/**
 * @brief handles the button presses, BUTTON1 is used to switch between
 * PLAYER_MOVE and WALL_PLACEMENT mode, while BUTTON2 is used to change the
 * wall's direction
 *
 * @param offset offset of the current move from the player or the center (in
 * case of a wall placement type move)
 */
void handle_buttons(struct Coordinate *offset);

#endif /* end __RIT_H */
/*****************************************************************************
**                            End Of File
******************************************************************************/
