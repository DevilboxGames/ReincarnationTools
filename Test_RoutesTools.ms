fn FindAILinksWithNode node =
(
	clearSelection()
	for i=1 to objects.count do 
	( 
		if (classof objects[i]) == AILink then 
			(
				if (objects[i].Node1.node == node) then
				(
					selectMore objects[i]
				)
				
			) 
	)
)
fn FindAILinksWithOneWay =
(
	clearSelection()
	for i=1 to objects.count do 
	( 
		if (classof objects[i]) == AILink then 
			(
				if (objects[i].OneWay) then
				(
					selectMore objects[i]
				)
				
			) 
	)
)
fn FindAILinksForRace raceNum =
(
	clearSelection()
	for i=1 to objects.count do 
	( 
		if (classof objects[i]) == AILink then 
			(
				if (objects[i].LinkType.count >= (raceNum + 1)) then
				(
					if objects[i].LinkType[(raceNum + 1)] == 1 then
					(
					selectMore objects[i]
					)
				)
				
			) 
	)
)
fn ShowOnlyAILinksForRace raceNum = 
(
	
	for i=1 to objects.count do 
	( 
		if (classof objects[i]) == AILink then 
			(
				if(raceNum == -1) then 
				(
					unhide objects[i]
				)
				else if (objects[i].LinkType.count >= (raceNum)) then
				(
					if raceNum == 0 then
					(
						for j = 0 to objects[i].LinkType.count do (
							if objects[i].LinkType[j] == 1 then
							(
								hide objects[i]
							)
							else
							(
								unhide objects[i]
							)
						)
					)
					else
					(
						if objects[i].LinkType[raceNum] == 1 then
						(
							unhide objects[i]
						)
						else
						(
							hide objects[i]
						)
					)
				)
				
			) 
	)
)
fn SetRaceOnSelectedLinks raceNum value =
(
	for obj in selection where (classof obj) == AILink do
	(
		if obj.LinkType.count >= racenum then
		(
			obj.LinkType[raceNum] = value
		)
	)
)

fn SwapLinkNodes =
(
	for obj in selection where (classof obj) == AILink do (
		node1 = obj.node1.node
		node2 = obj.node2.node
		obj.node1.node= node2
		obj.node2.node = node1
	)
)

AllAINodes = for obj in objects where (classof obj) == AINode collect obj
when transform AllAINodes changes nodeObj do 
(
	for lnk in objects where (classof lnk) == AILink do
	(
		if(lnk.Node1.node == nodeObj or lnk.Node2.node == nodeObj) then lnk.ForceMeshUpdate = true
	)
)