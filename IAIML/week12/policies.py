
import numpy as np

import constants as const

def policy_random(state):
    return np.random.choice(const.actions)

def policy1(state):
    if(state.y==3):
        return const.DOWN
    else:
        return const.RIGHT
    
def policy2(state):
    if(state.y==0):
        if(state.x!=3):
            return const.DOWN
        else:
            return const.RIGHT
    
    elif(state.y==1):
        if (state.x!=0):
            return const.UP
        else:
            return const.RIGHT
    
    elif(state.y==3):
        return const.DOWN
    
    else:
        return const.RIGHT

def policy_epsilon1(state,eps=0.2):
    if (np.random.random() < eps):
        return np.random.choice(const.actions)
    
    else:
        if(state.y==3):
            return const.DOWN
        else:
            return const.RIGHT
