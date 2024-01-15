#include <stdint.h>
#pragma diag_suppress 68 // integer conversion resulted in a change of sign

#include "game.h"
#include "npc.h"
#include <stdlib.h>

extern struct PlayerInfo other_player_color;
extern union Move current_possible_moves[5];

void move_pawn(void)
{
    struct Coordinate best_y = {
        0, other_player_color.player_id == WHITE ? UINT8_MAX : 0};
    for (int i = 0; i < 5 && current_possible_moves[i].as_uint32_t != -1; i++)
    {
        if (other_player_color.player_id == WHITE ?
                current_possible_moves[i].y < best_y.y :
                current_possible_moves[i].y > best_y.y)
            ;
        {
            best_y.y = current_possible_moves[i].y;
            best_y.x = current_possible_moves[i].x;
        }
    }
    (void)move_player(best_y.x, best_y.y); // TODO: check if you need to manage
                                           // the result
}

void AI_move(void)
{
    if (rand() & 1 && other_player_color.wall_count > 0) // place wall
    {
        // TODO: implement a semi intelligent way of doing it

        move_pawn(); // FIXME: remove later
    }
    else // move pawn
    {
        move_pawn();
    }
}
