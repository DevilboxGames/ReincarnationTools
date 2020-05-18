
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
	fn CreateShape objects moveToOrigin:false forcePolyhedron:false =
	(
		for obj in objects do
		(
			oldPos = obj.pos
			obj.pos = [0,0,0]
			oldRot = obj.rotation
			objType = classof obj

			isAxisAligned = (
				normXAxis = normalize obj.Transform.row1
				normXAxis.x == 1 or normXAxis.y == 1 or normXAxis.z == 1
			)
			isScaled = obj.scale.x != 1 or obj.scale.y != 1 or obj.scale.z != 1
			isUniformScaled = obj.scale.x == obj.scale.y and obj.scale.x == obj.scale.z
			format "%\nisAxisAligned: %\nisScaled: %\nisUniformScaled: %\n" objType isAxisAligned isScaled isUniformScaled
			if forcePolyhedron == false and (objType == Sphere or objType == GeoSphere) and isUniformScaled then
			(
				accShape = AccessoryShape Type:"Sphere"
				append accShape.Points obj.position
				accShape.Radius = obj.radius * obj.scale.x
			)
			else if forcePolyhedron == false and (objType == Box) and isAxisAligned then
			(
				accShape = AccessoryShape Type:"AlignedCuboid"
				append accShape.Points obj.min
				append accShape.Points obj.max
			)
			else if forcePolyhedron == false and objType == Capsule and isUniformScaled then
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
			obj.pos = oldPos
			obj.rotation = oldRot
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
			append strStream  "form_collision_groups\n1"
		)
		--format "%" (strStream as string)
		return (strStream as string)
	),
	
	fn SaveTXT txtFile obj= (
		
		accTxt = "[DYNAMICS]\n\n<lump_name>\n"+obj.name+"\n\n<solid>\n<part_of_world>\n<mass>\n1000.000000\n\n\n<centre_of_mass>\n0.000000,0.000000,0.000000\n<DRIVABLE_ON>\n"
		accTxt = accTxt + OutputShapeString()
		
		fp = openFile txtFile mode:"wt"
		format "%" accText to:fp
		close fp
		
	)
)
fn QuickGetAccessoryShape moveToOrigin:false forcePolyhedron:false =
(
	accessory = AccessoryFileLump()
	accessory.CreateShape $ moveToOrigin:moveToOrigin forcePolyhedron:forcePolyhedron
	format "%\n\n" (accessory.OutputShapeString())

	accessory
)

fn SpawnAccessoryPlaceholder accessoryName pos:[0,0,0] rot:(quat 0 0 0 1) = (
	local newacc = CarmaHelper_AccessoryPlaceholder()
	
	newacc.loadAccessoryMesh ("E:\\Backups\\CarmAndroid\\WADs\\Data_Android\DATA\\CONTENT\\TRACKS\\ACCESSORIES\\"+accessoryName+"\\ACCESSORY.CNT")
	newacc.pos = pos
	newacc.rotation = rot
	select newacc
	viewport.zoomtobounds true newacc.min newacc.max
)
fn MakeC1AccessoriesList = (
	outputstring = ""
	for obj in selection  do (
		tm = copy obj.transform
				if dot (normalize (cross tm.row3 tm.row1)) (normalize tm.row2) < 0.9 then tm.row1 = -tm.row1
				--tm.row1 = normalize tm.row1
				--tm.row2 = normalize tm.row2
				--tm.row3 = normalize tm.row3
				tm = matrix3 [-1,0,0] [0,0,1] [0,-1,0] [0,0,0] * tm * inverse(matrix3 [-1,0,0] [0,0,1] [0,-1,0] [0,0,0])
					tmstring = (tm.row1.x as string)+","+ (tm.row1.y as string)+","+ (tm.row1.z as string)+"\n"+(tm.row2.x as string)+","+ (tm.row2.y as string)+","+ (tm.row2.z as string)+"\n"+(tm.row3.x as string)+","+ (tm.row3.y as string)+","+ (tm.row3.z as string)+"\n"+(tm.row4.x as string)+","+ (tm.row4.y as string)+","+ (tm.row4.z as string)+"\n"
				outputstring = outputstring + "[ACCESSORY]\n\n<NAME>\n"+((filterstring obj.name ".")[1])+"\n\n<POSITION>\n"+tmstring+"\n<INSTANCE_NAME>\n"+((filterstring obj.name ".")[1])+"\n\n<INSTANCE_COLOUR>\n255,255,255\n\n"	
	)
	outputstring
)

fn MakeMatrixFrom3Verts vertO vertX vertY upVector:[0,0,1] = (
	local yAxis = normalize ((getVert $ vertX) - (getVert $ vertO))
	local xAxis = normalize ((getVert $ vertY) - (getVert $ vertO))
	
	(matrix3 xAxis yAxis upVector [0,0,0])
)
fn MakeQuatFrom3Verts vertO vertX vertY upVector:[0,0,1] = (
	local yAxis = normalize ((getVert $ vertX) - (getVert $ vertO))
	local xAxis = normalize ((getVert $ vertY) - (getVert $ vertO))
	
	(matrix3 xAxis yAxis upVector [0,0,0]) as quat
)