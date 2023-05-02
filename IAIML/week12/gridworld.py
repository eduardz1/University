
import numpy as np
import constants as const
import codecs

class Loc():
    def __init__(self,x,y):
        self.x = x
        self.y = y
        
    def __eq__(self,other):
        return (self.x == other.x) and (self.y == other.y)
    
    def __ne__(self,other):
        return (self.x != other.x) or (self.y != other.y)
    
    def __str__(self):
        return '('+str(self.x)+','+str(self.y)+')'
    
    def __hash__(self):
        return hash(str(self))
    
def find_location_in_array(x,xs):
    xs = np.array(xs)
    index = np.where(xs==x)[0]
    if (index.size==0):
        return None
    else:
        return index[0]
    
def compute_adjacent(loc,world):
    minx = 0; maxx = world.height-1;
    miny = 0; maxy = world.width-1;
    
    nextxs = []
    if loc.x == 0:
        nextxs.append(1)
    elif loc.x == maxx:
        nextxs.append(maxx-1)
    else:
        nextxs.append(loc.x+1)
        nextxs.append(loc.x-1)
        
    nextys = []
    if loc.y == 0:
        nextys.append(1)
    elif loc.y == maxy:
        nextys.append(maxy-1)
    else:
        nextys.append(loc.y+1)
        nextys.append(loc.y-1)
        
    nextlocs = []
    for x in nextxs:
        nextlocs.append(gw.Loc(x,loc.y))
    for y in nextys:
        nextlocs.append(gw.Loc(loc.x,y))
    
    return nextlocs   

class GridWorld():
    
    def __init__(self, width, height, start_x, start_y, end_x, end_y):
        # TODO: check conditions on width, height, start_x, start_y, end_x, end_y
        
        self.width = width
        self.height = height
        self.starting_position = Loc(start_x,start_y)
        self.ending_position = Loc(end_x,end_y)
        self.current_position = self.starting_position
        
        self.termination = False
        
        self.world = np.zeros((width,height))
        self.world[start_x,start_y] = const.STARTING
        self.world[end_x,end_y] = const.ENDING
        
    def add_wall(self,x,y):
        # TODO: check conditions on x,y
        self.world[x,y] = const.WALL
        
    def add_trap(self,x,y):
        # TODO: check conditions on x,y
        self.world[x,y] = const.TRAP
        
    def reset(self):
        self.termination = False
        self.current_position = self.starting_position
        
        return self.current_position, 0, self.termination, []
    
    def step(self,action):
        
        if(not self.termination):
            self.current_position, transition_msgs = self._compute_transition(action)
            reward, reward_msgs = self._compute_reward()
            termination_msgs = self._check_termination()
            return self.current_position, reward, self.termination, [transition_msgs,reward_msgs,termination_msgs]
        
        else:
            return Loc(-1,-1), -1, self.termination, 'Game is over'
        
    def _compute_transition(self,action):
        x = self.current_position.x
        y = self.current_position.y
        
        if action==const.LEFT:
            if (y==0): return self.current_position, 'I can not move out of the world'
            elif (self.world[x,y-1]==const.WALL): return self.current_position, 'I can not move past the wall'
            else: return Loc(x,y-1), 'I moved'
            
        elif action==const.UP:
            if (x==0): return self.current_position, 'I can not move out of the world'
            elif (self.world[x-1,y]==const.WALL): return self.current_position, 'I can not move past the wall'
            else: return Loc(x-1,y), 'I moved'
        
        elif action==const.RIGHT:
            if (y==self.width-1): return self.current_position, 'I can not move out of the world'
            elif (self.world[x,y+1]==const.WALL): return self.current_position, 'I can not move past the wall'
            else: return Loc(x,y+1), 'I moved'
        
        elif action==const.DOWN:
            if (x==self.height-1): return self.current_position, 'I can not move out of the world'
            elif (self.world[x+1,y]==const.WALL): return self.current_position, 'I can not move past the wall'
            else: return Loc(x+1,y), 'I moved'
        
    def _compute_reward(self):
        if(self.current_position == self.ending_position):
            return 100, None
        elif(self.world[self.current_position.x,self.current_position.y]==const.TRAP):
            return -100, None 
        else:
            return -1, None
        
    def _check_termination(self):
        if(self.current_position == self.ending_position):
            self.termination = True
            return 'Objective reached'
        elif(self.world[self.current_position.x,self.current_position.y]==const.TRAP):
            self.termination = True
            return 'You fell into a trap!'
                
    def print_basic(self):
        np.set_printoptions(formatter={'float': " {: 0.0f} ".format})
        
        printworld = self._get_world_representation()
        print(printworld)
        print('\n')
  
        np.set_printoptions()
        
    def print_unicode(self):
        printworld = self._get_world_representation()
        
        rows = []
        for i in range(self.height):
            rows.append([const.translate_to_unicode(int(printworld[i,j])) for j in range(self.width)])
        for i in range(self.height):
            print(*rows[i], sep=' ')
        print('\n')
        
    def _get_world_representation(self):
        repworld = self.world.copy()
        repworld[self.current_position.x, self.current_position.y] = const.PLAYER
        return repworld
        