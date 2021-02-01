mouseRay = (mapScreenToWorldRay mouse.Pos)
format "Ray pos: % - ray dir: %\n" mouseRay.pos mouseRay.dir
hits = 0
selectedObj = undefined
nearestDist=undefined
for obj in selection do (
	hit = intersectRay obj mouseRay
	if hit != undefined then(
		dist = distance hit.pos mouseRay.pos
		hits = hits + 1
		format "Found % at % - nearestDist %\n" obj dist nearestDist
		
		if(nearestDist == undefined or dist < nearestDist) then (
			selectedObj = obj
			nearestDist = dist
		)
	)
)

format "hit % objects; nearest is %;" hits selectedObj