
	CMDContentFolder = "d:\\Carmageddon Max Damage\\Data_Core\\Content\\" 
	CMDVehicleFolder = CMDContentFolder + "Vehicles\\" 
	HeadlightFile = CMDVehicleFolder + "eagle_r\\head_light.light" 
	BrakelightFile = CMDVehicleFolder + "eagle_r\\brake_light.light" 
	ReverselightFile = CMDVehicleFolder + "eagle_r\\reverse_light.light" 
	C2Folder = "g:\\VanillaC2\\"
	CarsFolder = "data\\cars\\"
fn RotatePivotOnly obj rotation = (
	local rotValInv=inverse (rotation as quat)
	animate off in coordsys local obj.rotation*=RotValInv
	obj.objectoffsetpos*=RotValInv
	obj.objectoffsetrot*=RotValInv
)

if loadedOtherScripts == undefined then (
	filein "Carma_ImportV19-Trent.ms"
	filein "ReincarnationTools.ms"
	loadedOtherScripts = true
)

struct PathGroove (
	ACTName,
	Centre,		--Point3
	Period,		--Float
	Delta 		--Float
)
struct RockGroove (
	ACTName,
	Period,		--Float
	Centre,		--Point3
	Axis,		--Enum
	MaxAngle 	--Float
)
struct ShearGroove (
	ACTName,
	Period,		--Float
	Centre,		--Point4
	Magnitude	--Point3
)
struct SpinGroove (
	ACTName,
	Period,		--Float
	Centre,		--Point3
	Axis		--Enum
)

fn StopNullNodesRendering = (
	for obj in objects where IsObjectANullCNT obj do ( 
		obj.castShadows=false
		obj.primaryVisibility=false
	)
)

fn LoadWAMFile file = (
	WAMClass = dotnetClass "ToxicRagers.Carmageddon2.Formats.WAM"
	WAMFile = WAMClass.Load file
	WAMFile
)

fn LoadTXTFile file = (
	TXTClass = dotNetClass "ToxicRagers.Carmageddon2.Formats.Car"
	TXTFile = TXTClass.Load file
	TXTFile
)
fn RenderHUDDamage file = (
	StopNullNodesRendering()
	makeDir (getFilenamePath file)

	cam = Freecamera pos:[0,0,9] rotation:(EulerAngles 0 0 180)
	lit = Directionallight pos:[50,50,50] rotation:(EulerAngles -25 35 0) castshadows:true
	lit.pos = [-45,-45,45]
	--ground = plane width:1000 length:1000 material:(MatteShadow())

	sceneStateMgr.Capture "PreHUDDamageGeneration" #{1..10}
	for obj in objects where (classof obj) == editable_mesh do obj.material = InkNPaint intersect_bias:10 min_ink_width:4.0  max_ink_width:4.0 self_overlap_ink_on:false self_underlap_ink_on:false smgroup_edge_ink_on:false matid_ink_on:false paint_color:(color 32 32 32)

	render camera:cam outputsize:[240,480] outputfile:file vfb:off
	
	sceneStateMgr.Restore "PreHUDDamageGeneration" #{1..10}
	sceneStateMgr.Delete "PreHUDDamageGeneration"
	delete cam
	delete lit

	--delete ground
)
fn RenderHUDOutline file = (
	StopNullNodesRendering()
	makeDir (getFilenamePath file)

	cam = Freecamera pos:[0,0,9] rotation:(EulerAngles 0 0 180)
	lit = Directionallight pos:[50,50,50] rotation:(EulerAngles -25 35 0) castshadows:true
	lit.pos = [-45,-45,45]
	--ground = plane width:1000 length:1000 material:(MatteShadow())

	sceneStateMgr.Capture "PreHUDDamageGeneration" #{1..10}
	for obj in objects where (classof obj) == editable_mesh do obj.material = InkNPaint intersect_bias:10 min_ink_width:6.0  max_ink_width:6.0 self_overlap_ink_on:false self_underlap_ink_on:false smgroup_edge_ink_on:false matid_ink_on:false paint_color:(color 32 32 32) paint_on:false color1:(color 255 255 255)

	render camera:cam outputsize:[240,480] outputfile:file vfb:off
	
	sceneStateMgr.Restore "PreHUDDamageGeneration" #{1..10}
	sceneStateMgr.Delete "PreHUDDamageGeneration"
	delete cam
	delete lit

	--delete ground
)
fn RenderTopView file = (
	StopNullNodesRendering()
	makeDir (getFilenamePath file)

	cam = Freecamera pos:[0,0,17] rotation:(EulerAngles 0 0 -90)
	lit = Directionallight pos:[50,50,50] rotation:(EulerAngles -25 35 0) castshadows:true raytracedShadows:true
	lit.shadowGenerator = Adv__Ray_Traced()
	lit.pos = [-45,-45,45]
	ground = plane width:1000 length:1000 material:(MatteShadow())
	render camera:cam outputsize:[720,360] outputfile:file vfb:off
	
	delete cam
	delete lit
	delete ground
)
fn RenderMiniMap file = (
	StopNullNodesRendering()
	makeDir (getFilenamePath file)

	cam = Freecamera pos:[0,0,17] rotation:(EulerAngles 0 0 -90)
	lit = Directionallight pos:[50,50,50] rotation:(EulerAngles -45 45 0) castshadows:true
	lit.pos = [-45,-45,45]
	
	sceneStateMgr.Capture "PreMinimapDamageGeneration" #{1..10}
	for obj in objects where (classof obj) == editable_mesh do (
		oldmat =obj.material
		if (classof oldmat) == Multimaterial then (
			for submat in obj.material do (
				obj.material.materiallist[finditem obj.material.materiallist submat] = InkNPaint intersect_bias:10 min_ink_width:6.0  max_ink_width:6.0 self_overlap_ink_on:false self_underlap_ink_on:false smgroup_edge_ink_on:false matid_ink_on:false paint_color:(color 32 32 32) paint_on:true color1:(color 255 255 255) paint_Map:submat.diffuseMap paint_map_on:true
			)
		)
		else (
			obj.material = InkNPaint intersect_bias:10 min_ink_width:6.0  max_ink_width:6.0 self_overlap_ink_on:false self_underlap_ink_on:false smgroup_edge_ink_on:false matid_ink_on:false paint_color:(color 32 32 32) paint_on:true color1:(color 255 255 255) paint_Map:oldmat.diffuseMap paint_map_on:true
		)
	)
	render camera:cam outputsize:[180,90] outputfile:file vfb:off
	
	sceneStateMgr.Restore "PreMinimapDamageGeneration" #{1..10}
	sceneStateMgr.Delete "PreMinimapDamageGeneration"
	delete cam
	delete lit

)
fn RenderSideView file = (
	StopNullNodesRendering()
	makeDir (getFilenamePath file)

	cam = Freecamera() 
 	cam.rotation = (EulerAngles -90 90 0)
	cam.pos = [-17,0,1]
	lit = Directionallight pos:[50,50,50] rotation:(EulerAngles -45 45 0) castshadows:true
	lit.pos = [-45,-45,45]
	
	sceneStateMgr.Capture "PreSideviewDamageGeneration" #{1..10}
	for obj in objects where (classof obj) == editable_mesh do (
		oldmat =obj.material
		if (classof oldmat) == Multimaterial then (
			for submat in obj.material do (
				obj.material.materiallist[finditem obj.material.materiallist submat] = InkNPaint intersect_bias:10 min_ink_width:6.0  max_ink_width:6.0 self_overlap_ink_on:false self_underlap_ink_on:false smgroup_edge_ink_on:false matid_ink_on:false paint_color:(color 32 32 32) paint_on:true color1:(color 255 255 255) paint_Map:submat.diffuseMap paint_map_on:true
			)
		)
		else (
			obj.material = InkNPaint intersect_bias:10 min_ink_width:6.0  max_ink_width:6.0 self_overlap_ink_on:false self_underlap_ink_on:false smgroup_edge_ink_on:false matid_ink_on:false paint_color:(color 32 32 32) paint_on:true color1:(color 255 255 255) paint_Map:oldmat.diffuseMap paint_map_on:true
		)
	)
	render camera:cam outputsize:[180,90] outputfile:file vfb:off
	
	sceneStateMgr.Restore "PreSideviewDamageGeneration" #{1..10}
	sceneStateMgr.Delete "PreSideviewDamageGeneration"
	
	delete cam
	delete lit

)

fn RenderUIAssets carname skinname outputfolder = (
	RenderHUDDamage (outputfolder+"hud_damage_backing.png")
	RenderHUDOutline (outputfolder+"hud_damage_outline.png")
	RenderTopView (outputfolder+carname+"_"+skinname+"_top.png")
	RenderMiniMap (outputfolder+carname+"_"+skinname+"_side.png")
	RenderSideView (outputfolder+carname+"_"+skinname+"_minimap.png")
)

fn RenderUIAssetsTest = (
	outputfolder = "d:\\testrenders\\"
	carname = "eagle3"
	skinname="default"
	RenderHUDDamage (outputfolder+"hud_damage_backing.png")
	RenderHUDOutline (outputfolder+"hud_damage_outline.png")
	RenderTopView (outputfolder+carname+"_"+skinname+"_top.png")
	RenderMiniMap (outputfolder+carname+"_"+skinname+"_side.png")
	RenderSideView (outputfolder+carname+"_"+skinname+"_minimap.png")
)

fn CreateExhaustVFX rootObject = (
	select rootObject
	for obj in selection do selectmore obj.children

	bodyMin = $.min
	bodyMax = $.max

	rlTransform = matrix3 1
	rrTransform = matrix3 1

	rlTransform.pos = [bodyMin.x + (bodyMax.x - bodyMin.x) * 0.6, bodyMax.y, bodymin.z + (bodymax.z - bodymin.z)*0.2]
	rrTransform.pos = [bodyMin.x + (bodyMax.x - bodyMin.x) * 0.4, bodyMax.y, bodymin.z + (bodymax.z - bodymin.z)*0.2]
	
	exhaustLL = CreateNewNullNode rlTransform "VFX_Exhaust_LL"
	exhaustRR = CreateNewNullNode rrTransform "VFX_Exhaust_RR"

	exhaustLL.parent = rootObject
	exhaustRR.parent = rootObject
)

fn CreateLights rootObject = (
	select rootObject
	for obj in selection do selectmore obj.children

	bodyMin = $.min
	bodyMax = $.max

	flTransform = matrix3 1
	frTransform = matrix3 1
	rlTransform = matrix3 1
	rrTransform = matrix3 1

	flTransform.pos = [bodyMin.x + (bodymax.x - bodymin.x) * 0.9, bodyMin.y, bodymin.z + (bodymax.z - bodymin.z)*0.5]
	frTransform.pos = [bodyMin.x + (bodymax.x - bodymin.x) * 0.1, bodyMin.y, bodymin.z + (bodymax.z - bodymin.z)*0.5]
	rlTransform.pos = [bodyMax.x, bodyMax.y, bodymin.z + (bodymax.z - bodymin.z)*0.5]
	rrTransform.pos = [bodyMin.x + (bodymax.x - bodymin.x) * 0.9 + (bodymax.x - bodymin.x) * 0.1, bodyMax.y, bodymin.z + (bodymax.z - bodymin.z)*0.5]
	
	bulbFL = CreateNewNullNode flTransform "Bulb_FL"
	bulbFR = CreateNewNullNode frTransform "Bulb_FR"
	bulbRL = CreateNewNullNode rlTransform "Bulb_RL"
	bulbRR = CreateNewNullNode rrTransform "Bulb_RR"

	bulbFL.parent = rootObject
	bulbFR.parent = rootObject
	bulbRL.parent = rootObject
	bulbRR.parent = rootObject

	flTransform.rotation = quat -0.606009 -0.0555831 0.0724768 0.790196
	frTransform.rotation = quat -0.606009 0.0555829 -0.0724764 0.790196
	flTransform.pos = [bodyMin.x + (bodymax.x - bodymin.x) * 0.9, bodyMin.y, bodymin.z + (bodymax.z - bodymin.z)*0.5]
	frTransform.pos = [bodyMin.x + (bodymax.x - bodymin.x) * 0.1, bodyMin.y, bodymin.z + (bodymax.z - bodymin.z)*0.5]

	headlightFL = omniLight name:"Headlight_L"
	headlightFL.transform =flTransform
	headlightFL.rotation = quat -0.606009 -0.0555831 0.0724768 0.790196
	headlightFL.pos = [bodyMin.x + (bodymax.x - bodymin.x) * 0.9, bodyMin.y, bodymin.z + (bodymax.z - bodymin.z)*0.5]
	headlightFR = omniLight name:"Headlight_R"
	headlightFR.transform =frTransform
	headlightFR.rotation =  quat -0.606009 0.0555829 -0.0724764 0.790196
	headlightFR.pos =  [bodyMin.x + (bodymax.x - bodymin.x) * 0.1, bodyMin.y, bodymin.z + (bodymax.z - bodymin.z)*0.5]

	headlightObj = CRLight()
	headlightObj.LoadLight HeadlightFile
	headlightObj.SetToLight headlightFL
	headlightObj.SetToLight headlightFR

	headlightFL.parent = bulbFL
	headlightFR.parent = bulbFR

	rlTransform.rotation = quat 0.00115909 0.584933 -0.811079 -0.00160721
	rrTransform.rotation = quat 0.00115909 0.584933 -0.811079 -0.00160721
	rlTransform.pos = [bodyMin.x + (bodymax.x - bodymin.x) * 0.9, bodyMax.y, bodymin.z + (bodymax.z - bodymin.z)*0.5 + 0.025]
	rrTransform.pos = [bodyMin.x + (bodymax.x - bodymin.x) * 0.1, bodyMax.y, bodymin.z + (bodymax.z - bodymin.z)*0.5 + 0.025]

	reverselightRL = omniLight name:"Reverselight_L"
	reverselightRL.transform =rlTransform
	reverselightRR = omniLight name:"Reverselight_R"
	reverselightRR.transform =rrTransform

	reverselightObj = CRLight()
	reverselightObj.LoadLight ReverselightFile
	reverselightObj.SetToLight reverselightRL
	reverselightObj.SetToLight reverselightRR

	reverselightRL.parent = bulbRL
	reverselightRR.parent = bulbRR

	rlTransform.pos = [bodyMin.x + (bodymax.x - bodymin.x) * 0.9, bodyMax.y, bodymin.z + (bodymax.z - bodymin.z)*0.5 - 0.025]
	rrTransform.pos = [bodyMin.x + (bodymax.x - bodymin.x) * 0.1, bodyMax.y, bodymin.z + (bodymax.z - bodymin.z)*0.5 - 0.025]

	brakelightRL = omniLight name:"Brakelight_L"
	brakelightRL.transform =rlTransform
	brakelightRR = omniLight name:"Brakelight_R"
	brakelightRR.transform =rrTransform

	brakelightObj = CRLight()
	brakelightObj.LoadLight brakelightFile
	brakelightObj.SetToLight brakelightRL
	brakelightObj.SetToLight brakelightRR

	brakelightRL.parent = bulbRL
	brakelightRR.parent = bulbRR
)

fn InsertNullAbove target nullName =
(
	newnode = CreateNewNullNode target.transform nullName
	newnode.parent =target.parent
	target.parent = newnode
)

fn FindWeldVerts detachable parent tolerance:0.0 = (
	foundVerts =#()
	numVertsInObject = getNumVerts detachable
	numVertsInParent = getNumVerts parent

	for i = 1 to numVertsInObject do (
		vertPos = getVert detachable i
		for j = 1 to numVertsInParent do (
			parentVertPos = getVert parent j
			if (length (parentVertPos - vertPos)) <= tolerance then (
				appendIfUnique foundVerts i
				j = numVertsInParent + 10
			)
		)
	)

	foundVerts
)
fn FindNearestVert detachable parent = (

	numVertsInObject = getNumVerts detachable
	numVertsInParent = getNumVerts parent
	in coordsys detachable (
		nearestVert = [0,0,0]
		shortestDistance = 9999999
		for i = 1 to numVertsInObject do (
			vertPos = getVert detachable i
			for j = 1 to numVertsInParent do (
				parentVertPos = getVert parent j
				dist =  length (vertPos - parentVertPos)
				if dist < shortestDistance then (
					shortestDistance = dist
					nearestVert = vertPos
				)
			)
		)
	)
	nearestVert
)

fn GetVertPositions obj vertInds = (
	points = #()

	for ind in vertInds do (
		append points (getVert obj ind)
	)

	points
)

struct planeDef ( Point, Normal)
fn GetPlaneFromPoints points = (
	foundPlane = undefined
	if points.count == 0 then (
		foundPlane = planeDef Point:[0,0,0] Normal: [0,0,1] 
	)
	else if points.count == 1 then (
		foundPlane = planeDef Point:points[1] Normal: [0,0,1] 
	)
	else if points.count == 2 then (
		edgeDir = normalize (points[2] - points[1])
		binormal = normalize (cross edgeDir [0,0,1])
		normal = normalize (cross binoraml edgeDir)
		foundPlane = planeDef Point:points[1] Normal: normal
	)
	else (
		sum = [0,0,0]

		for p in points do (
			sum = sum + p
		)

		centroid = sum * (1.0 / points.count)
		xx = 0
		xy = 0
		xz = 0
		yy = 0
		yz = 0
		zz = 0

		for p in points do (
			r = p - centroid
			xx = xx + r.x * r.x
			xy = xy + r.x * r.y
			xz = xz + r.x * r.z
			yy = yy + r.y * r.y
			yz = yz + r.y * r.z
			zz = zz + r.z * r.z
		)

		det_x = yy * zz - yz * yz
		det_y = xx * zz - xz * xz
		det_z = xx * yy - xy * xy

		det_max = det_x
		if det_y > det_max then det_max = det_y
		if det_z > det_max then det_max = det_z

		normal = [0,0,1]
		if det_max == det_x then (
			normal.x = det_x
			normal.y = xz * yz - xy * zz
			normal.z = xy * yz - xz * yy
		)
		else if det_max == det_y then (
			normal.x = xz * yz - xy * zz
			normal.y = det_y
			normal.z = xy * xz - yz * xx
		)
		else (
			normal.x = xy * yz - xz * yy
			normal.y = xy * xz - yz * xx
			normal.z = det_z
		)
		dirToOrigin = normalize (-centroid)
		dtoDotNorm = dot normal dirToOrigin
		if dtoDotNorm > 0 then (
			normal = -1.0 * normal
		)
		foundPlane = planeDef Point:centroid Normal: (normalize normal)
	)

	foundPlane
)

fn SetJointToHangingBall joint weakness = (
	joint.JointType = 2
	joint.JointType_Hinge = false
	joint.JointType_Ball = true
	joint.JointType_UJ = false
	joint.JointType_Slide = false
	joint.Weakness = weakness

	joint.UseLimit = true
	joint.MinLimit = 0
	joint.MaxLimit = 17
	joint.UseLimit2 = true
	joint.MinLimit2 = -1
	joint.MaxLimit2 = 0
	joint.UseTwist = true
	joint.MinTwist = -7
	joint.MaxTwist = 7

	joint.UseNormal = true
	joint.UseLocation = true

)

fn SetToHingeJoint joint weakness = (
	joint.JointType = 1
	joint.JointType_Hinge = true
	joint.JointType_Ball = false
	joint.JointType_UJ = false
	joint.JointType_Slide = false

	joint.UseLimit = true
	joint.MinLimit = 0
	joint.MaxLimit = 70

	joint.Weakness = weakness
	append joint.FlapSprings [20,20,0]
	append joint.FlapSprings [30,70,0]

	joint.UseLocation = true

)

fn BeginEditMesh obj = (

	mods = #()
	for m in obj.modifiers do (
		append mods m
	)
	for m in mods do(
		deletemodifier obj m
	)
	
	mods
)
fn EndEditMesh obj mods = (
	for m in mods do(
		addmodifier obj m
	)
	

)

fn CreateHingeJointFromPoints obj point1 point2 point3 weakness:350= (
	jointAxis = normalize (point2 - point1)
	jointNormal = normalize  (point3 - point1)
	joint = CreateJointHelper obj
	joint.transform = matrixFromNormal jointAxis
	joint.pos = point2

	SetToHingeJoint joint weakness	

	aDotX = dot jointAxis [1,0,0]
	aDotY = dot jointAxis [0,1,0]
	aDotZ = dot jointAxis [0,0,1]
	nDotX = dot jointNormal [1,0,0]
	nDotY = dot jointNormal [0,1,0]
	nDotZ = dot jointNormal [0,0,1]

	JointOnLeft 	= 	point1.x > 0
	JointOnRight	=	point1.x <= 0
	JointOnFront	=	point1.y <= 0
	JointOnBack 	=	point1.y > 0

	LatchOnLeft 	=	point3.x > 0
	LatchOnRight	=	point3.x <= 0
	LatchOnFront	=	point3.y <= 0
	LatchOnBack 	=	point3.y > 0

	jointFacingUp		= aDotZ > 0.5
	jointFacingDown 	= aDotZ < -0.5
	jointFacingLeft 	= aDotX > 0.5
	jointFacingRight	= aDotX < -0.5
	jointFacingBackward	= aDotY > 0.5
	jointFacingForward	= aDotY < -0.5

	jointNormFacingUp		= nDotZ > 0.5
	jointNormFacingDown		= nDotZ < -0.5
	jointNormFacingLeft		= nDotX > 0.5
	jointNormFacingRight	= nDotX < -0.5
	jointNormFacingBackward	= nDotY > 0.5
	jointNormFacingForward	= nDotY < -0.5

	if jointFacingUp then (
		if jointNormFacingBackward and JointOnLeft or jointNormFacingForward and JointOnRight or jointNormFacingLeft and JointOnFront or jointNormFacingRight and JointOnBack then (
			joint.MinLimit = -70
			joint.MaxLimit = 0
		)
	)
	else if jointFacingDown then (
		if jointNormFacingBackward and JointOnRight or jointNormFacingForward and JointOnLeft or jointNormFacingLeft and JointOnBack or jointNormFacingRight and JointOnFront then (
			joint.MinLimit = -70
			joint.MaxLimit = 0
		)

	)
	else if jointFacingLeft then (
		if jointNormFacingForward or jointNormFacingDown and JointOnFront then (
			joint.MinLimit = -70
			joint.MaxLimit = 0
		)
	)
	else if jointFacingRight then (
		if jointNormFacingBackward or jointNormFacingDown and JointOnBack then (
			joint.MinLimit = -70
			joint.MaxLimit = 0
		)
	)
	else if jointFacingForward then (
		if jointNormFacingDown and JointOnRight or jointNormFacingUp and JointOnLeft or jointNormFacingRight then (
			joint.MinLimit = -70
			joint.MaxLimit = 0
		)
	)
	else if jointFacingBackward then (
		if jointNormFacingDown and JointOnLeft or jointNormFacingUp and JointOnRight or jointNormFacingLeft then (
			joint.MinLimit = -70
			joint.MaxLimit = 0
		)
	)

	joint
)

fn CreateBallJointsForStubbornDetachable obj weakness: 150 = (
	weldVerts = (FindWeldVerts obj obj.parent tolerance:0.2)
	verts = GetVertPositions obj (FindWeldVerts obj obj.parent tolerance:0.2)
	foundPlane = GetPlaneFromPoints verts
	nDotUp = dot foundPlane.Normal [0,0,1]
	planeMat = matrixFromNormal foundPlane.normal
	planeMat.translation = foundPlane.Point
	j1 = undefined
	j2 = undefined
	in coordsys planeMat (
		verts = GetVertPositions obj (FindWeldVerts obj obj.parent tolerance:0.2)
		minPoint = [999,0,0]
		maxPoint = [-999,0,0]
		for v in verts do (
			if nDotUp > 0.9 or nDotUp < -0.9 then  (
				if v.x < minPoint.x then (
					minPoint = v
				)
				if v.x > maxPoint.x then (
					maxPoint = v
				)
			)
			else (
				if v.y < minPoint.y then (
					minPoint = v
				)
				if v.y > maxPoint.y then (
					maxPoint = v
				)
			)
		)
		j1 = CreateJointHelper obj
		j1.transform = planeMat
		j1.pos = minPoint
		SetJointToHangingBall j1 weakness
		j2 = CreateJointHelper obj
		j2.transform = planeMat
		j2.pos = maxPoint
		SetJointToHangingBall j2 weakness
		j2.MinLimit = -17
		j2.MaxLimit = 0
		j2.UseLimit2 = true
		j2.MinLimit2 = 0
		j2.MaxLimit2 = 1		
	)
	#(j1, j2)
)


fn ConvertCar CarName:"eagle3" = (
	
	WAM = LoadWAMFile (C2Folder+CarsFolder+CarName+"\\"+CarName+".wam")
	TXT = LoadTXTFile (C2Folder+CarsFolder+CarName+"\\"+CarName+".txt")

	carRoot = LoadC2Dat (C2Folder+CarsFolder+CarName+"\\"+CarName+".dat") &progressValue &progressText imp_mat:true imp_smth:true imp_quad:true imp_hier:true imp_group:true imp_act:true prefix:"" imp_scale69:true

	FRWheelAct = undefined
	FLWheelAct = undefined
	FRPivotAct = undefined
	FLPivotAct = undefined
	RRWheelAct = undefined
	RLWheelAct = undefined
	suspensionGrooves = #()
	otherGrooves = #()
	for i=0 to TXT.Grooves.count - 1 do (
		groove =TXT.Grooves.Item[i]
		format "\tGroove: % - #%: % - #%: %\n" groove.part groove.pathperiod (groove.PathType.ToString()) groove.animationperiod (groove.AnimationType.toString())
		if groove.PathType.ToString() == "straight" then (

		)
		if groove.AnimationType.toString() == "spin"  then (
			case groove.animationperiod of (
				2: RLWheelAct = groove.Part
				1: RRWheelAct = groove.Part
				9: FRWheelAct = groove.Part
				10: FLWheelAct = groove.Part
			)
		)
		else if groove.AnimationType.toString() == "rock" then (

			case groove.animationperiod of (
				7: FRPivotAct = groove.Part
				8: FLPivotAct = groove.Part
			)
		)
	)

	FLWheelPos = [0,0,0]
	FRWheelPos = [0,0,0]
	RLWheelPos = [0,0,0]
	RRWheelPos = [0,0,0]

	centreOfMass = [-txt.centreOfMass.item[0],txt.centreOfMass.item[2],txt.centreOfMass.item[1]] * 6.9
	for i=0 to (TXT.Wheels.count-1) do (
		wheel = TXT.Wheels.Item[i]
		rawPos = [wheel.Position.item[0],wheel.Position.item[1],wheel.Position.item[2]]
		
		wheelPos = [-rawPos.x, rawPos.z, rawPos.y] * 6.9 --+ centreOfMass

		if rawPos.z < 0 then (
			if rawPos.x < 0 then (
				FLWheelPos = wheelPos
			)
			else (
				FRWheelPos = wheelPos
			)
		)
		else  (
			if rawPos.x < 0 then (
				RLWheelPos = wheelPos
			)
			else (
				RRWheelPos = wheelPos
			)
		)
	)

	FLPivotObj = getnodebyname FLPivotAct
	FRPivotObj = getnodebyname FRPivotAct
	FLWheelObj = getnodebyname FLWheelAct
	FRWheelObj = getnodebyname FRWheelAct
	RLWheelObj = getnodebyname RLWheelAct
	RRWheelObj = getnodebyname RRWheelAct

	FLWheelObj.pivot = FLWheelObj.pivot
	FRWheelObj.pivot = FRWheelObj.pivot
	RLWheelObj.pivot = RLWheelObj.pivot
	RRWheelObj.pivot = RRWheelObj.pivot

	InsertNullAbove RRWheelObj "RRPivot"
	InsertNullAbove RLWheelObj "RLPivot"
	if FLPivotObj == undefined then (
		InsertNullAbove FLWheelObj FLPivot
	)
	else (
		FLPivotObj.pivot = FLWheelObj.pivot
	)
	if FRPivotObj == undefined then (
		InsertNullAbove FRWheelObj FRPivot
	)
	else (
		FRPivotObj.pivot = FRWheelObj.pivot

 	)

	select carRoot
	SetSelectionToCNTNodes doChildren:true

	CreateExhaustVFX carRoot
	CreateLights carRoot


	AddStructureCharacteristicsModifier carRoot
	AddVehilceCFGModifier carRoot
	AddStructurePartModifier carRoot doChildren:true

	for i = 0 to (WAM.CrushEntries.count-1) do (
		crush = WAM.CrushEntries.item[i]
		actorname = crush.Actor
		obj = getnodebyname actorname
		if obj != undefined then (
			crushtype =crush.Type.tostring()
			softness = crush.Softness.tostring()
			format "% - % %\n" actorname (crush.Type.tostring()) (crush.Softness.tostring())

				obj.modifiers["Car Structure Part"].Crushability_Set = true
				obj.modifiers["Car Structure Part"].Crushability = case softness of (
					"soft":2.0
            		"normal":1.0
            		"hard":0.75
            		"very_hard":0.5
            		"uncrushable":0
				)
			case crushtype of (
				"boring": (
				)
				"detach": (
					weldMod = AddStructureWeldModifier obj
					weldMod.WeldPartner = nodeTransformMonitor node:carRoot forwardTransformChangeMsgs:false
					weldMod.Weakness_Set = true

					easeOfDetach = crush.EaseOfDetach.toString()
					weldMod.Weakness = case easeOfDetach of (
						"very_soft": -1
	            		"very_easy": -2
	            		"easy": -3
	            		"normal": -4
	            		"hard": -6
					)
					weldVerts = FindWeldVerts obj obj.parent tolerance: 0.0001
					if weldVerts.count < 1 then (
						-- Try again with much reduced tolerance, because fuck it!
						weldVerts = FindWeldVerts obj obj.parent tolerance: 0.1
					)
					if weldVerts.count > 0 then (
						mods = BeginEditMesh obj
						for vertIndex in weldVerts do (
							setVertColor obj vertIndex (color 0 255 0 0)
						)
						EndEditMesh obj mods
					)
					else (
						weldVert = FindNearestVert obj obj.parent
						append weldMod.WeldVertexType "part"
						append weldMod.WeldVertexPosition weldVert
					)
					detachType = crush.DetachmentType.toString()
					case detachType of(
						"stubborn": (
							joints = CreateBallJointsForStubbornDetachable obj
							append weldMod.Joints joints[1]
							append weldMod.Joints joints[2]
						)
					)
				)
				"flap": (
					weldMod = AddStructureWeldModifier obj
					weldMod.WeldPartner = nodeTransformMonitor node:carRoot forwardTransformChangeMsgs:false

					weldMod2 = AddStructureWeldModifier obj
					weldMod2.WeldPartner = nodeTransformMonitor node:carRoot forwardTransformChangeMsgs:false
					weldMod2.Weakness_Set = true
					weldMod2.Weakness = -3
					weldMod2.WeldBreak_Set = true
					weldMod2.WeldBreak = 30

					hingePoint1 = crush.HingePoints.Item[0]
					hingePoint2 = crush.HingePoints.Item[1]
					latchPoint = crush.HingePoints.Item[2]
					hingeVert1 = (getVert obj hingePoint1)
					hingeVert2 = (getVert obj hingePoint2)
					latchVert = (getVert obj latchPoint)

					append weldMod.WeldVertexType "part"
					append weldMod.WeldVertexType "part"
					append weldMod.WeldVertexPosition hingeVert1 
					append weldMod.WeldVertexPosition hingeVert2

					append weldMod2.WeldVertexType "part"
					append weldMod2.WeldVertexPosition latchVert

					flapJoint = CreateHingeJointFromPoints obj hingeVert1 hingeVert2 latchVert	

				)
			)
		)
	)
)

fn SpaceOutCars = (
	lastmax = [-5,0,0]
	for obj in objects where obj.parent == undefined do (
	 
	obj.pos=[lastmax.x+5,0,0]
		select obj
		for obj2 in selection do selectmore obj2.children
		lastmax = $.max
	)
)
fn LoadAllCars = (
	format "Loading all cars from: %\n" (C2Folder + CarsFolder)
	carFolders = getDirectories "G:\\VanillaC2\\Data\\CARS\\*"
	format "Found % cars\n" carFolders.count
	x=0
	for i=1 to carFolders.count do (
		carFolder = carFolders[i]
		carName = GetFolderName carFolder
		if (getfiles (carFolder+"\\"+carName+".dat")).count != 0 then (
			x = x + 1
			LoadC2Dat (carFolder+"\\"+CarName+".dat") &progressValue &progressText imp_mat:true imp_smth:true imp_quad:true imp_hier:true imp_group:true imp_act:true prefix:"" imp_scale69:true
			if x > 4 then 
			(
				i=carFolders.count + 2
			)
		)
	)

)

fn TestPlaneDetection points = (
	foundPlane = GetPlaneFromPoints points
	planeObj = plane pos: foundPlane.Point transform:(MatrixFromNormal foundPlane.normal)
)