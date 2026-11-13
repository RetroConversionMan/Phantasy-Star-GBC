"""Plan source Hovercraft boarding, sea route and original shore disembarkation.

Read-only geometry. The campaign executes every movement and Item Use normally.
"""
from collections import deque
from campaign_world_route import DIRECTIONS, route_cells
SAMPLES=(64,96,64,112,64,128,64,144,80,96,80,112,80,128,80,144,
         96,96,96,112,96,128,96,144,112,96,112,112,112,128,112,144,
         128,112,128,128,128,144,80,160,96,160,112,160)
BOARD=((2,4,10,12,-1,0),(4,6,12,14,-1,1),(14,38,22,40,0,2),
       (22,40,30,42,1,2),(28,30,34,36,2,1),(26,28,32,34,2,0),
       (16,18,24,26,1,-1),(8,10,16,18,0,-1))
EXIT=((2,-2,-1),(4,-2,0),(14,-1,1),(22,0,1),(28,1,0),
      (26,1,-1),(16,0,-2),(8,-1,-2))
FACING=(2,0,3,1)

def moved(cell,dx,dy):return((cell[0]+dx)%128,(cell[1]+dy)%96)
def value(grid,flags,cell):return flags[grid[cell[1]*128+cell[0]]]
def sample(grid,flags,cell,index):return value(grid,flags,moved(cell,(SAMPLES[index+1]-128)//16,(SAMPLES[index]-96)//16))
def use_hover(grid,flags,cell,facing=0,exit=False):
    if not exit:
        for row in BOARD:
            if all(not sample(grid,flags,cell,i)&10 for i in row[:4]):return moved(cell,row[5],row[4])
    else:
        start=FACING[facing]*2
        for n in range(8):
            index,dy,dx=EXIT[(start+n)%8]
            if not sample(grid,flags,cell,index)&13:return moved(cell,dx,dy)
    return None

def flood(starts,allowed):
    distance={c:0 for c in starts};queue=deque(starts)
    while queue:
        cell=queue.popleft()
        for dx,dy in DIRECTIONS.values():
            dest=moved(cell,dx,dy)
            if dest not in distance and allowed(dest):distance[dest]=distance[cell]+1;queue.append(dest)
    return distance

def plan_hover(grid,flags,start,goals,map_id,items=()):
    goals=set(goals)
    def land_allowed(p):
        meta=grid[p[1]*128+p[0]]
        return not value(grid,flags,p)&13 or(map_id==1 and 59 in items and 0xc7<=meta<0xd2)or(map_id==0 and 0x5f<=meta<0x64)
    land=flood(goals,land_allowed)
    clear=lambda p:all(not value(grid,flags,moved(p,dx,dy))&14 for dx,dy in((0,0),(-1,0),(0,-1),(-1,-1)))
    exits=[]
    for y in range(96):
        for x in range(128):
            cell=(x,y)
            if clear(cell)and all(use_hover(grid,flags,cell,d,True)in land for d in range(4)):exits.append(cell)
    water=flood(exits,clear)
    foot=flood([start],land_allowed)
    options=[]
    for cell,distance in foot.items():
        board=use_hover(grid,flags,cell)
        if board in water:options.append((distance+water[board],distance,cell,board))
    if not options:raise ValueError(('No original Hovercraft shore route',map_id,start,goals))
    _,_,shore,board=min(options)
    cell=board;path=[]
    while water[cell]:
        for key,(dx,dy)in DIRECTIONS.items():
            dest=moved(cell,dx,dy)
            if water.get(dest)==water[cell]-1:path.append(key);cell=dest;break
        else:raise AssertionError('Broken Hovercraft distance map')
    return {'shore':shore,'board':board,'sea_goal':cell,'sea_path':path,
            'exit_land':[use_hover(grid,flags,cell,d,True)for d in range(4)],
            'foot_path':route_cells(grid,flags,start,{shore},map_id,items,exact_goal=True)if start!=shore else[]}
