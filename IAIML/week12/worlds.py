
import gridworld as gw

def world1():
    env = gw.GridWorld(4,4, 0,0, 3,3)
    return env

def world2():
    env = gw.GridWorld(4,4, 0,0, 3,3)
    env.add_wall(0,2)
    return env