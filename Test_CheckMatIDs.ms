for obj in selection do (
	if obj.material == undefined then format "Object % has no material assigned\n" obj.name
	else if classof obj.material == Multimaterial then (
		format "Object % has a multimaterial assigned with % submaterials:\n" obj.name obj.material.material.count
		for i = 1 to obj.material.material.count do (
			local mat = obj.material.material[i]
			if mat == undefined then (
				format "\t%: THIS MATERIAL ID IS NOT ASSIGNED!\n" i
			)
			else (
				format "\t%: % (%)\n" i mat.name (classof mat)
			)
		)
	)
	else  (
		format "\t%: % (%)\n" i obj.material.name (classof obj.material)
	)
	local m = snapshotAsMesh obj
	local numFaces = getnumfaces m
	materialIds = #()
	for i = 1 to numfaces do (
		local matId = getfacematid m i
		appendIfUnique materialIds matId
	)
	format "Object % has % material ids:\n" obj.name materialIds.count
	for matID in materialIds do (
		format "\t%\n" matId
	)
	format "\n========\n\n"
)