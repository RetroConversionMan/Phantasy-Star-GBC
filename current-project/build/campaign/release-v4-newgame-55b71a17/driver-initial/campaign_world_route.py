"""Source collision planner; actual movement remains native controller input."""
import heapq

DIRECTIONS = {'down': (0, 1), 'right': (1, 0), 'left': (-1, 0), 'up': (0, -1)}


def route_cells(data, flags, start, goals, map_id, items=(), vehicle=0, exact_goal=False):
    assert vehicle in (0, 8, 12), 'Only foot, Hovercraft and Ice Digger routes are supported'
    goals = set(goals)
    previous, distance, queue = {start: None}, {start: 0}, [(0, start)]
    destination = None
    while queue:
        cost, cell = heapq.heappop(queue)
        if cost != distance[cell]:
            continue
        footprint = [cell] if not vehicle else [((cell[0]+dx)%128, (cell[1]+dy)%96)
                                                for dx,dy in ((0,0),(-1,0),(0,-1),(-1,-1))]
        primary = data[cell[1]*128+cell[0]]
        if vehicle == 12 and 0xd8 <= primary < 0xe0:primary=0xd7
        visible_goal = cell in goals or (not exact_goal and not flags[primary]&4 and any(p in goals for p in footprint))
        if cell != start and visible_goal:
            destination = cell
            break
        for key, (dx, dy) in DIRECTIONS.items():
            nxt = ((cell[0]+dx)%128, (cell[1]+dy)%96)
            if vehicle:
                # Original 7A2B leading samples, primary at the lower right.
                lead = ((cell[0]+(dx if dx>=0 else -2))%128,
                        (cell[1]+(dy if dy>=0 else -2))%96)
                samples = [lead, ((lead[0]-(dy!=0))%128, (lead[1]-(dx!=0))%96)]
            else:
                samples = [nxt]
            blocked = False
            weight = 1
            for p in samples:
                meta = data[p[1]*128+p[0]]
                if vehicle == 12 and 0xd8 <= meta < 0xe0:
                    meta = 0xd7
                value = flags[meta]
                source_special = (map_id == 0 and ((meta == 0x5e and 53 in items) or 0x5f <= meta < 0x64)) or (map_id == 2 and vehicle == 12 and meta == 0xd7) or (map_id == 1 and 59 in items and 0xc7 <= meta < 0xd2)
                if value & (10 if vehicle == 8 else 1) or (value & 12 and p not in goals and not source_special):
                    blocked = True
                    break
                weight = max(weight, 100 if 0x5f <= meta < 0x64 else
                             40 if map_id < 3 and value >> 4 > 1 else 1)
            if blocked or cost+weight >= distance.get(nxt, 10**9):
                continue
            distance[nxt] = cost+weight
            previous[nxt] = (cell, key)
            heapq.heappush(queue, (cost+weight, nxt))
    if destination is None:
        raise ValueError(('No source world route', map_id, start, goals, vehicle))
    result, cursor = [], destination
    while previous[cursor]:
        cursor, key = previous[cursor]
        result.append(key)
    return result[::-1]
