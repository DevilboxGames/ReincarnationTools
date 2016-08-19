fn VertIsOnBoundary obj v testMatIDs:false=
(
	edges = polyop.GetEdgesUsingVert obj v
	--format "vert % has % edges\n" v edges.numberSet
	isBoundary = false
	for e in edges while isBoundary == false do
	(
		faces = polyop.GetFacesUsingEdge obj e
		--format "edge % has % faces\n" e faces.numberSet
		if faces.numberSet == 1 then isBoundary = true
		else
		(
			matIDs = #{}
			for f in faces do
			(
				matIDs[polyop.GetFaceMatID obj f] = true
				--format "\tface % has matID of %\n" f (polyop.GetFaceMatID obj f)
			)
			if matIDs.numberSet > 1 then isBoundary = true
		)
	)
	if testMatIDs then
	(
		local vToFind = v-- (for v in (polyop.GetVertSelection obj) collect v)[1]
		if classof v == bitarray then vToFind = (v as array)[1]
		local mapVerts = #{}

		for f in (polyop.getFacesUsingVert obj vToFind) do
		(
			local polyFace = polyOp.getFaceVerts obj f
			local mapFace = polyOp.getMapFace obj 1 f
			local mapVert = mapFace[finditem polyFace vToFind]
			mapVerts[mapVert] = true
		)
		if mapVerts.numberSet > 1 then isBoundary = true
	)
	--format "vert % of % has % edges with % reverse edges\n" v obj.name edges.numberSet reverseEdges.numberSet
	return isBoundary
)
fn CleanUpPlanarVerts obj vertList threshold:1=
(
	numVerts = getNumVerts obj
	vertsToRemove = #{}
	--format "Cleaning up % from % to %\n" obj.name startVert endVert
	for v in vertList do
	(
		facesUsingVert = polyop.getFacesUsingVert obj v
		
		if facesUsingVert.numberSet < 3 or (VertIsOnBoundary obj v) then
		(
			bndry = "not on bounday"
			if VertIsOnBoundary obj v then bndry = "on boundary"
			--format "Vert % used by % faces and is %\n" v facesUsingVert.numberSet bndry
			continue
		)
		--format "vert: %\n" v
		normalsDot = 0
		faceCount = 0
		lastNormal = undefined
		
		for f in facesUsingVert do
		(
			faceCount += 1
			normal = polyop.getFaceNormal obj f
			--format "\tf#%:\t\tnormal %\n" f normal
			if lastNormal != undefined then 
			(
				currentDot = dot lastNormal normal
				--format "\t\t\tnDotln %\n" currentDot
				normalsDot += currentDot
			)
			lastNormal = normal
		)
		normalsDot = normalsDot / (faceCount-1)
		--format "average dot: %\n=========================\n" normalsDot
		if normalsDot >= threshold then vertsToRemove[v] = true
	)
	
	polyop.setVertSelection obj vertsToRemove
	select obj
	subobjectlevel = 1
	obj.Remove()
)
fn CleanUpPlannerVertsFromSelectedFaces obj threshold:1 =
(
	verts = polyop.getVertsUsingFace obj (polyop.getFaceSelection obj)
	CleanUpPlanarVerts obj verts threshold:threshold
)