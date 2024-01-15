#if defined(__ARMCC_VERSION) && (__ARMCC_VERSION < 6000000)
#pragma diag_suppress 68 // integer conversion resulted in a change of sign
#endif

#include "npc.h"
#include "game.h"
#include <stdint.h>
#include <stdlib.h>

void move_pawn(void)
{
    struct Coordinate best_y = {0, other_player_color == WHITE ? UINT8_MAX : 0};
    for (int i = 0;
         i < 5 && current_possible_moves[i].as_uint32_t != (uint32_t)-1;
         i++)
    {
        if (other_player_color == WHITE ?
                current_possible_moves[i].y < best_y.y :
                current_possible_moves[i].y > best_y.y)
            ;
        {
            best_y.y = current_possible_moves[i].y;
            best_y.x = current_possible_moves[i].x;
        }
    }
    (void)move_player((uint8_t)best_y.x, (uint8_t)best_y.y); // TODO: check if
                                                             // you need to
                                                             // manage the
                                                             // result
}

void AI_move(void)
{
    if (rand() & 1 /*&& other_player_color.wall_count > 0*/) // place wall
    {
        // TODO: implement a semi intelligent way of doing it

        move_pawn(); // FIXME: remove later
    }
    else // move pawn
    {
        move_pawn();
    }
}
