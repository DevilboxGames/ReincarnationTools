
struct TriangleStripper_Vertex
(
	Index,
	Edges,
	Triangles
)
struct TriangleStripper_Edge
(
	Index,
	Vertices,
	Triangles
)
struct TriangleStripper_Triangle
(
	Index,
	Edges,
	Vertices,

	fn GetOppositeVert(v1, v2)
	{
		for v in Vertices do
		(
			if v != v1 && v != v2 then return v
		)
	}
)

struct TriangleStripper
(
	Obj,
	NumberOfTriangles,
	NumberOfVerts,
	NumberOfEdges,
	Triangles = #(),
	Edges = #(),
	Vertices = #(),
	Strips = #(),
	TrianglesDone = #{},

	TrianglesDoneThisStrip = #{},
	CurrentStrips = #(#(),#(),#()),
	CurrentStripFaces = #(#(),#(),#()),

	fn CreateAdjacency = 
	(
		if AdjacentTriangles.count > 0 then
		(
			free AdjacentTriangles
			AdjacentTriangles = #()
		)
		if AdjacentEdges.count > 0 then
		(
			free AdjacentEdges
			AdjacentEdges = #()
		)

		NumberOfTriangles = getNumFaces Obj
		NumberOfVerts = getNumVerts Obj
		NumberOfEdges = getNumEdges Obj

		for t=1 to NumberOfTriangles do
		(
			verts = polyop.GetVertsUsingFace Obj #{t}
			edges = polyop.GetEdgesUsingFace Obj #{t}
			tri = TriangleStripper_Triangle Index:t Edges:edges Vertices:verts
			append Triangles tri
		)
		for v=1 to NumberOfVerts do
		(
			edges = polyop.GetEdgesUsingVert Obj #{v}
			tris = polyop.GetFacesUsingVert Obj #{v}
			vert = TriangleStripper_Vertex Index:v Edges:edges Triangles:tris
			append Vertices vert
		)
		for e=1 to NumberOfEdges do
		(
			verts = polyop.GetVertsUsingEdge Obj #{e}
			tris = polyop.GetFacesUsingEdge Obj #{e}
			edge = TriangleStripper_Edge Index:e Vertices:verts Triangles:tris
			append Edges edge
		)

	),
	fn FindFirstUndusedTriangle bits =
	(
		FirstUnusedBit = 0
		CurrentBitUsed = 0
		for n in bits while (CurrentBitUsed=n;on) and (FirstUnusedBit=FirstUnusedBit+1;CurrentBitUsed == FirstUnusedBit) do ( )
		return FirstUnusedBit
	),

	fn TrackStrip faceIndex oldest middle stripNum offset =
	(
		stripLength = 2
		faceCount = 1

		if 1 + offset <= CurrentStrips[stripNum].count then
		(
			CurrentStrips[stripNum][1 + offset] = oldest
		)
		else
		(
			apped CurrentStrips[stripNum] oldest
		)

		if 2 + offset <= CurrentStrips[stripNum].count then
		(
			CurrentStrips[stripNum][2 + offset] = middle
		)
		else
		(
			append CurrentStrips[stripNum] middle
		)

		DoingTheStripper = true
		oldFaceIndex = faceIndex
		itteration = 0

		while DoingTheStripper do
		(
			itteration += 1

			newest = Triangles[faceIndex].GetOppositeVert oldest middle

			stripLength += 1

			if stripLength + offset < CurrentStrips[stripNum].count then
			(
				CurrentStrips[stripNum][stripLength + offest] = newest
			)
			else
			(
				append CurrentStrips[stripNum] newest
			)

			if faceCount + offset < CurrentStripFaces[stripNum].count then
			(
				CurrentStripFaces[stripNum][faceCount + offset] = face
			)
			else
			(
				append CurrentStripFaces[stripNum] face
			)



		)
	),
	fn ComputeBestStrip index =
	(
		CurrentStrips = #(#(),#(),#())
		CurrentStripFaces = #(#(),#(),#())
		lengths = #(0,0,0)
		firstLengths = #(0,0,0)

		face = Triangles[index]
		vertices1 = #(tri.Vertices[1],tri.Vertices[3],tri.Vertices[2])
		vertices2 = #(tri.Vertices[2],tri.Vertices[1],tri.Vertices[3])

		for stripNum = 1 to 3 do
		(
			trisDone = copy TrianglesDone


		)

	)
	fn ShakeItBaby theObj mergeStrips:true =
	(
		Triangles = #()
		Edges = #()
		Vertices = #()
		Strips = #()
		Obj = theObj
		CreateAdjacency()

		TrianglesDone = #{}
		numTrianglesStripped = 0

		while numTrianglesStripped < NumberOfTriangles do
		(
			index = FindFirstUndusedTriangle TrianglesDone

			numTrianglesStripped += ComputeBestStrip index

		)
	)
)