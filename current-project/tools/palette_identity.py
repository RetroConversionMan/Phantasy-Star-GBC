"""Quantize RGB while keeping source palette-effect classes exact.

Indices with equal RGB and equal effect class may share a native palette slot;
indices with different effect classes may never share one. This distinction is
required for originally-black wall/enemy pixels that become white on impact.
"""
from collections import Counter
from itertools import combinations
from extract_assets import color_distance

def select_palettes(histograms,weights,colors,classes,count,size):
    equivalent={};aliases={}
    for c in range(len(colors)):
        aliases[c]=equivalent.setdefault((colors[c],classes[c]),c)
    hist=[Counter({}) for _ in histograms]
    for result,original in zip(hist,histograms):
        for c,n in original.items():result[aliases[c]]+=n
    used=sorted({c for h in hist for c in h})
    # Per-tile candidates retain every present effect class, including a rare
    # one that would disappear from a simple most-common-colors shortlist.
    candidates=set()
    for h in hist:
        popular=[c for c,n in h.most_common(size+2)]
        for category in set(classes[c] for c in h):
            if not any(classes[c]==category for c in popular):
                popular.append(max((c for c in h if classes[c]==category),key=h.get))
        for p in combinations(sorted(popular),min(size,len(popular))):
            candidates.add(p+(p[0],)*(size-len(p)))
    # Ensure a globally usable palette for every class subset. This makes
    # zero semantic error achievable even when source tile histograms vary.
    common=sum(hist,Counter())
    reps=[max((c for c in used if classes[c]==category),key=common.get)for category in sorted(set(classes[c]for c in used))]
    assert len(reps)<=size
    extras=sorted((c for c in used if c not in reps),key=lambda c:-common[c])
    baseline=(reps+extras)[:size];baseline += [baseline[0]]*(size-len(baseline));candidates.add(tuple(sorted(baseline)))
    candidates=sorted(candidates)
    distance=[[color_distance(colors[a],colors[b])+(10**12 if classes[a]!=classes[b] else 0) for b in range(len(colors))]for a in range(len(colors))]
    error=[[min(distance[c][p]for p in pal)for c in range(len(colors))]for pal in candidates]
    scores=[[weight*sum(n*err[c]for c,n in h.items())for h,weight in zip(hist,weights)]for err in error]
    best=[10**20]*len(hist);selected=[]
    for _ in range(min(count,len(candidates))):
        ix=min((i for i in range(len(candidates))if i not in selected),key=lambda i:sum(min(a,b)for a,b in zip(best,scores[i])))
        selected.append(ix);best=[min(a,b)for a,b in zip(best,scores[ix])]
    refs=[candidates[i]for i in selected];refs += [refs[0]]*(count-len(refs))
    return refs,distance
