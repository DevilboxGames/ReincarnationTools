
struct AccessoryShape
(
	Type,
	Points = #(),
	Radius
)

struct AccessoryFileLump
(
	Mass,
	CentreOfMass,

	Shapes =#(),
	fn CreateShape objects =
	(
		for obj in objects do
		(
			objType = classof obj

			isAxisAligned = (
				normXAxis = normalize obj.Transform.row1
				normXAxis.x == 1 or normXAxis.y == 1 or normXAxis.z == 1
			)
			isScaled = obj.scale.x != 1 or obj.scale.y != 1 or obj.scale.z != 1
			isUniformScaled = obj.scale.x == obj.scale.y and obj.scale.x == obj.scale.z
			format "%\nisAxisAligned: %\nisScaled: %\nisUniformScaled: %\n" objType isAxisAligned isScaled isUniformScaled
			if (objType == Sphere or objType == GeoSphere) and isUniformScaled then
			(
				accShape = AccessoryShape Type:"Sphere"
				append accShape.Points obj.position
				accShape.Radius = obj.radius * obj.scale.x
			)
			else if (objType == Box) and isAxisAligned then
			(
				accShape = AccessoryShape Type:"AlignedCuboid"
				append accShape.Points obj.min
				append accShape.Points obj.max
			)
			else if objType == Capsule and isUniformScaled then
			(
				accShape = AccessoryShape Type:"TicTac"
				ticTacRadius = obj.scale.x * obj.radius
				ticTacHeight = obj.scale.x * obj.height
				if (obj.heighttype == 0) then ticTacHeight = ticTacHeight - ticTacRadius
				startPos = obj.position + obj.Transform.row3 * ticTacRadius
				endPos = startPos + obj.Transform.row3 * ticTacHeight
				append accShape.points startPos
				append accShape.points endPos
				accShape.radius = ticTacRadius
			)
			else
			(
				msh = snapshotasmesh obj
				accShape = AccessoryShape Type:"Polyhedron"
				numShapeVerts = getNumVerts msh
				for v=1 to numShapeVerts do
				(
					pos = getVert msh v
					appendifunique accShape.points pos
				)
			)
			append Shapes accShape
		)
	),
	fn OutputShapeString =
	(
		strstream = StringStream ""
		append strStream "<shape>\n"
		append strstream "(default_label)\n"
		append strstream (shapes.count as string)
				append strStream "\n"
		for shape in Shapes do
		(
			append strStream shape.type
				append strStream "\n"
			if shape.type == "Sphere" then
			(
				pos = ConvertToCRSpace shape.points[1]
				format "%,%,%\n" pos.x pos.y pos.z to:strStream
				append strStream (shape.radius as string)
				append strStream "\n"
			)
			else if shape.type == "AlignedCuboid" then
			(
				pos1 = ConvertToCRSpace shape.points[1]
				pos2 = ConvertToCRSpace shape.points[2]
				format "%,%,%\n" pos1.x pos1.y pos1.z to:strStream
				format "%,%,%\n" pos2.x pos2.y pos2.z to:strStream
			)
			else if shape.type == "TicTac" then
			(
				pos1 = ConvertToCRSpace shape.points[1]
				pos2 = ConvertToCRSpace shape.points[2]
				format "%,%,%\n" pos1.x pos1.y pos1.z to:strStream
				format "%,%,%\n" pos2.x pos2.y pos2.z to:strStream
				append strStream (shape.radius as string)
				append strStream "\n"
			)
			else if shape.type == "Capsule" then
			(
				pos1 = ConvertToCRSpace shape.points[1]
				pos2 = ConvertToCRSpace shape.points[2]
				format "%,%,%\n" pos1.x pos1.y pos1.z to:strStream
				format "%,%,%\n" pos2.x pos2.y pos2.z to:strStream
				append strStream (shape.radius as string)
				append strStream "\n"
			)
			else if shape.type == "Polyhedron" then
			(
				append strStream (shape.points.count as string)
				append strStream "\n"
				for v in shape.points do
				(
					pos1 = ConvertToCRSpace v
					format "%,%,%\n" pos1.x pos1.y pos1.z to:strStream
				)
			)
				append strStream "\n"
				append strStream "\n"
		)
		format "%" (strStream as string)
	)
)
