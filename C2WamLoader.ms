forceDummyNull = true
	CMDContentFolder = "d:\\Steam\\steamapps\\common\\Carmageddon Max Damage\\Data_Core\\Content\\" 
	CMDVehicleFolder = CMDContentFolder + "Vehicles\\" 
	HeadlightFile = CMDVehicleFolder + "eagle_r\\head_light.light" 
	BrakelightFile = CMDVehicleFolder + "eagle_r\\brake_light.light" 
	ReverselightFile = CMDVehicleFolder + "eagle_r\\reverse_light.light" 
	C2Folder = "g:\\VanillaC2\\"
	C2DataFolder = C2Folder+"data\\"
	C2CarImageFolder = C2Folder+"data\\INTRFACE\\CarImage\\"
	CarsFolder = "cars\\"
	C2OpponetsTextFile = C2DataFolder+"OPPONENT.TXT"
	MaxSaveFolder = "D:\\Work\\ReincarnationTools\\VehicleDev\\C2Ports\\"
fn RotatePivotOnly obj rotation = (
	local rotValInv=inverse (rotation as quat)
	animate off in coordsys local obj.rotation*=RotValInv
	obj.objectoffsetpos*=RotValInv
	obj.objectoffsetrot*=RotValInv
)
struct filechanges (file, modifieddate)
if scriptChanges == undefined then (
	scriptChanges = #()
)
fn CheckScriptChanges = (
	global scriptChanges
	thisScript = getThisScriptFilename()
	scriptPath = getFilenamePath thisScript
	msFiles = getFiles (scriptPath+"*.ms")
	format "Loading % and checking % files for changes\n" thisScript msFiles.count
	for msFile in msFiles where msFile != thisScript and (findstring msFile "Test_") != 1 do (
		format "Checking file %\n" msFile
		changedDate = getFileModDate msFile
		matchedFiles = for f in scriptChanges where f.file == msFile collect f
		if matchedFiles.count > 0 then (
			if matchedFiles[1].modifieddate != changedDate then (
				ind = finditem scriptChanges matchedFiles[1]
				scriptChanges[ind].modifieddate = changedDate
				loadedOtherScripts = false
				format "script % changed\n" msFile
			)
		)
		else (
			append scriptChanges (filechanges file:msFile modifieddate:changedDate)

				loadedOtherScripts = false
				format "script % changed\n" msFile
		)
	)
)
CheckScriptChanges()
if loadedOtherScripts != true then (
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
			diffuseMap = undefined
			if oldmat != undefined then diffuseMap = oldmat.diffuseMap
			obj.material = InkNPaint intersect_bias:10 min_ink_width:6.0  max_ink_width:6.0 self_overlap_ink_on:false self_underlap_ink_on:false smgroup_edge_ink_on:false matid_ink_on:false paint_color:(color 32 32 32) paint_on:true color1:(color 255 255 255) paint_Map:diffuseMap paint_map_on:true
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
			diffuseMap = undefined
			if oldmat != undefined then diffuseMap = oldmat.diffuseMap
			obj.material = InkNPaint intersect_bias:10 min_ink_width:6.0  max_ink_width:6.0 self_overlap_ink_on:false self_underlap_ink_on:false smgroup_edge_ink_on:false matid_ink_on:false paint_color:(color 32 32 32) paint_on:true color1:(color 255 255 255) paint_Map:diffuseMap paint_map_on:true
		)
	)
	render camera:cam outputsize:[180,90] outputfile:file vfb:off
	
	sceneStateMgr.Restore "PreSideviewDamageGeneration" #{1..10}
	sceneStateMgr.Delete "PreSideviewDamageGeneration"
	
	delete cam
	delete lit

)

fn RenderUIAssets carname skinname outputfolder = (
	makedir outputfolder
	RenderHUDDamage (outputfolder+"hud_damage_backing.png")
	RenderHUDOutline (outputfolder+"hud_damage_outline.png")
	RenderTopView (outputfolder+carname+"_"+skinname+"_top.png")
	RenderMiniMap (outputfolder+carname+"_"+skinname+"_minimap.png")
	RenderSideView (outputfolder+carname+"_"+skinname+"_side.png")

	ConvertTDX = dotnetClass "Gibbed.Stainless.TDXConvertLib.ConvertTDX"
	ConvertTDX.Convert (outputfolder+"hud_damage_backing.png") outputFolder 5
	ConvertTDX.Convert (outputfolder+"hud_damage_outline.png") outputFolder 5
	ConvertTDX.Convert (outputfolder+carname+"_"+skinname+"_top.png") outputFolder 5
	ConvertTDX.Convert (outputfolder+carname+"_"+skinname+"_side.png") outputFolder 5
	ConvertTDX.Convert (outputfolder+carname+"_"+skinname+"_minimap.png") outputFolder 5
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

	SetCollectionToCNTNodes #(bulbRR, bulbRL, bulbFR, bulbFL) doChildren:true
)

fn InsertNullAbove target nullName =
(
	newnode = CreateNewNullNode target.transform nullName
	newnode.parent =target.parent
	target.parent = newnode

	newnode
)

fn FindWeldVerts detachable parent tolerance:0.0 = (
	foundVerts =#()
	numVertsInObject = getNumVerts detachable
	parentMesh = parent
	while (classof parent) != Editable_mesh and parent != undefined do (
		parentMesh = parent.parent
	)

	if parentMesh != undefined then (
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
fn RotatePivotOnly obj rotation = (
	local rotValInv=inverse (rotation as quat)
	animate off in coordsys local obj.rotation*=RotValInv
	obj.objectoffsetpos*=RotValInv
	obj.objectoffsetrot*=RotValInv
)

fn flipWheel obj = (
	oldMods = BeginEditMesh obj
	numVerts = getNumVerts obj
	in coordsys obj (
	for i =1 to numverts do (
		v = getvert obj i
		v.x = -v.x
		setvert obj i v
	)
	
	numfaces = getnumfaces obj
	for i = 1 to numfaces do (
		f = getface obj i
		v1 = f.x
		f.x = f.y
		f.y = v1
		setface obj i f
		tvf = gettvface obj i
		v1 = tvf.x
		tvf.x = tvf.y
		tvf.y = v1
		settvface obj i tvf
	)
	
	)	
	update obj
	EndEditMesh obj oldMods
	
)

fn ConvertToNullNodeAndMakeTyreMesh obj wheelType tyreName tyreWidth: 0.335 tyreRadius: 0.709 = (
	obj.pivot = obj.center
	wheelPos = obj.pos
	wheelRot = quat 1
	flipWheelNode = false
	if obj.pos.x > 0 then (
		--RotatePivotOnly obj (EulerAngles 0 0 180)
		--obj.scale.x = obj.scale.x * -1
		flipWheelNode = true
		wheelRot = (eulerangles 0 0 180) as quat
		flipWheel obj
		obj.pivot = obj.center
	)
	extents = obj.max - obj.min
	obj.rotation = quat 1
	obj.pos = [0,0,0]
	obj.scale = [tyreWidth / extents.x, tyreRadius / extents.y, tyreRadius / extents.y]
	obj.modifiers["CNT Hierarchy"].BakeScaleIntoMesh = true
	obj.modifiers["CNT Hierarchy"].Filename = "Rim"
	
	SetToComplicatedWheel obj
	wheelmod = obj.modifiers["Complicated Wheel"]
	wheelmod.RotateTyre = false
	wheelmod.TyreMaterial = "INVISIBLE"
	wheelmod.TyrePuncturedMaterial = "INVISIBLE"
	wheelmod.TyreDerimmedMaterial = "INVISIBLE"
	wheelmod.TyreDetachedMaterial = "INVISIBLE"

	obj.pos = [0,0,0]
	--select obj
	--KeepMaxAlive()

	--		completeRedraw ()
	folder_name = CMDVehicleFolder + "Wheels\\"+tyreName+"\\"
	makedir folder_name
	global MaterialsToExport
	MaterialsToExport=#()
	oldparent = obj.parent
obj.parent = undefined
	--format "wheel % transform = %\n" obj.name obj.transform
	ExportMDL folder_name false true exportMats:true exportTextures:true funsizeExport:false createOctree:false nodes:#(obj)
	ExportCNT (folder_name+"Rim.cnt") obj
	ExportMaterialsAndTextures folder_name exportMats:true exportTextures:true funsizeExport:false createOctree:false
	tyre = copy obj
	tyre.name="Tyre"
	tyre.modifiers["CNT Hierarchy"].Filename = "Tyre"
	tyre.modifiers["CNT Hierarchy"].BakeScaleIntoMesh = true
	--tyre.scale = [0.1,0.1,0.1]
	ExportMDL folder_name false true  exportMats:true exportTextures:true funsizeExport:false createOctree:false nodes:#(tyre)
	ExportCNT (folder_name+"Tyre.cnt") tyre
	ExportCNT (folder_name+"Tyre_Derimmed.cnt") tyre
	ExportCNT (folder_name+"TYRE_PUNCTURED100.cnt") tyre
	ExportMaterialsAndTextures folder_name exportMats:true exportTextures:true funsizeExport:false createOctree:false
	delete tyre
	SaveWheelLUA obj folder_name

obj.parent = oldparent
	newWheelNode = ConvertToWheelNode obj wheelType deleteOldMesh:false wheelName:tyreName
	newWheelNode.rotation = wheelRot
	newWheelNode.pos = wheelPos
	newWheelNode.scale = [extents.x / tyreWidth, extents.y / tyreRadius, extents.y / tyreRadius]

obj.parent = undefined
	newWheelNode
)
fn ConvertAllWheels carName rootMesh = (
	wheels = for obj in objects where (findstring obj.name "wheel") != undefined collect obj
	newwheels = #()
	for wheel in wheels do (
		wheelType="Wheel_FR"

		wheel.name = (filterstring wheel.name ".")[1]
		tyreName = "default_"+carName+"_"+wheel.name
		if (findstring wheel.name "rr") !=undefined then wheelType="Wheel_RR"
		else if (findstring wheel.name "fr")  !=undefined then wheelType="Wheel_FR"
		else if (findstring wheel.name "rl")  !=undefined then wheelType="Wheel_RL"
		else if (findstring wheel.name "fl")  !=undefined then wheelType="Wheel_FL"
		else (
			wheelType = "Wheel_"
			if wheel.pos.y > 0 then wheelType = wheelType+"R"
			else  wheelType = wheelType+"F"
			if wheel.pos.x > 0 then wheelType = wheelType+"L"
			else  wheelType = wheelType+"R"
			--wheelType="Wheel_MX"
		)
		newwheel = ConvertToNullNodeAndMakeTyreMesh wheel wheelType tyreName
		append newwheels newwheel
		case wheeltype of (
			"Wheel_FR":
				rootMesh.modifiers["vehicle_setup.cfg"].FRWheelFolderNames[1] = tyreName
			"Wheel_FL":
				rootMesh.modifiers["vehicle_setup.cfg"].FLWheelFolderNames[1] = tyreName
			"Wheel_RR":
				rootMesh.modifiers["vehicle_setup.cfg"].RRWheelFolderNames[1] = tyreName
			"Wheel_RL":
				rootMesh.modifiers["vehicle_setup.cfg"].RLWheelFolderNames[1] = tyreName
			default:
			(
				if rootMesh.modifiers["vehicle_setup.cfg"].D4WheelFolderNames[1] == "" then
					rootMesh.modifiers["vehicle_setup.cfg"].D4WheelFolderNames[1] = tyreName
				else if rootMesh.modifiers["vehicle_setup.cfg"].D5WheelFolderNames[1] == "" then
					rootMesh.modifiers["vehicle_setup.cfg"].D5WheelFolderNames[1] = tyreName
				else if rootMesh.modifiers["vehicle_setup.cfg"].D6WheelFolderNames[1] == "" then
					rootMesh.modifiers["vehicle_setup.cfg"].D6WheelFolderNames[1] = tyreName
				else if rootMesh.modifiers["vehicle_setup.cfg"].D7WheelFolderNames[1] == "" then
					rootMesh.modifiers["vehicle_setup.cfg"].D7WheelFolderNames[1] = tyreName
				else if rootMesh.modifiers["vehicle_setup.cfg"].D8WheelFolderNames[1] == "" then
					rootMesh.modifiers["vehicle_setup.cfg"].D8WheelFolderNames[1] = tyreName
				else if rootMesh.modifiers["vehicle_setup.cfg"].D9WheelFolderNames[1] == "" then
					rootMesh.modifiers["vehicle_setup.cfg"].D9WheelFolderNames[1] = tyreName
				else if rootMesh.modifiers["vehicle_setup.cfg"].D10WheelFolderNames[1] == "" then
					rootMesh.modifiers["vehicle_setup.cfg"].D10WheelFolderNames[1] = tyreName
				else if rootMesh.modifiers["vehicle_setup.cfg"].D11WheelFolderNames[1] == "" then
					rootMesh.modifiers["vehicle_setup.cfg"].D11WheelFolderNames[1] = tyreName
			)
		)
		
	)
	newwheels
)
fn CreateHingeJointFromPoints obj p1 p2 p3 doFlaps:true weakness:350 carRoot:undefined= (
	jointAxis = normalize (p2 - p1)
	jointNormal = normalize  (p3 - p1)
	jointUp = cross jointAxis jointNormal
	jointNormal = cross jointUp jointAxis
	joint = CreateJointHelper obj
	--joint.pos = p1

	SetToHingeJoint joint weakness	

	joint.transform = matrix3 jointAxis jointNormal jointUp p1

	aDotX = dot jointAxis [1,0,0]
	aDotY = dot jointAxis [0,1,0]
	aDotZ = dot jointAxis [0,0,1]
	nDotX = dot jointNormal [1,0,0]
	nDotY = dot jointNormal [0,1,0]
	nDotZ = dot jointNormal [0,0,1]

	JointOnLeft 	= 	p1.x > carRoot.center.x
	JointOnRight	=	p1.x <= carRoot.center.x
	JointOnFront	=	p1.y <= carRoot.center.y
	JointOnBack 	=	p1.y > carRoot.center.y
	JointOnTop		=	p1.z > carRoot.center.z
	JointOnBottom	=	p1.z <= carRoot.center.z


	LatchOnLeft 	=	p3.x > p2.x
	LatchOnRight	=	p3.x <= p2.x
	LatchOnFront	=	p3.y <= p2.y
	LatchOnBack 	=	p3.y > p2.y
	LatchOnTop		=	p3.z > p2.z
	LatchOnBottom	=	p3.z <= p2.z

	jointFacingUp		= aDotZ > 0.5
	jointFacingDown 	= aDotZ < -0.5
	jointFacingLeft 	= aDotX > 0.5
	jointFacingRight	= aDotX < -0.5
	jointFacingBackward	= aDotY < 0.5
	jointFacingForward	= aDotY > -0.5

	jointNormFacingUp		= nDotZ > 0.5
	jointNormFacingDown		= nDotZ < -0.5
	jointNormFacingLeft		= nDotX > 0.5
	jointNormFacingRight	= nDotX < -0.5
	jointNormFacingBackward	= nDotY < 0.5
	jointNormFacingForward	= nDotY > -0.5

	--format "\nCreating Hinge Joint for % using \n\tHinge Points:% - %\n\tLatch Point: %\n\tJointAxis: %\n\tJointNormal: %\n\tJointUp: %\n\tTransform: %" obj.name p1 p2 p3 jointAxis jointNormal jointUp joint.transform
	--format "\n\tJointOnTop: %\n\tJointOnBottom: %\n\tJointOnLeft: %\n\tJointOnRight: %\n\tJointOnFront: %\n\tJointOnBack: %" JointOnTop JointOnBottom JointOnLeft JointOnRight JointOnFront JointOnBack
	--format "\n\tLatchOnTop: %\n\tLatchOnBottom: %\n\tLatchOnLeft: %\n\tLatchOnRight: %\n\tLatchOnFront: %\n\tLatchOnBack: %" LatchOnTop LatchOnBottom LatchOnLeft LatchOnRight LatchOnFront LatchOnBack
	--format "\n\tjointFacingUp: %\n\tjointFacingDown: %\n\tjointFacingLeft: %\n\tjointFacingRight: %\n\tjointFacingForward: %\n\tjointFacingBackward: %"  jointFacingUp jointFacingDown jointFacingLeft jointFacingRight jointFacingForward jointFacingBackward
	--format "\n\tjointNormFacingUp: %\n\tjointNormFacingDown: %\n\tjointNormFacingLeft: %\n\tjointNormFacingRight: %\n\tjointNormFacingForward: %\n\tjointNormFacingBackward: %\n"  jointNormFacingUp jointNormFacingDown jointNormFacingLeft jointNormFacingRight jointNormFacingForward jointNormFacingBackward
	--format "FlapSprings:%\n" joint.flapSprings
	flipped = false
	if jointFacingUp then (
		if jointNormFacingBackward and JointOnLeft or jointNormFacingForward and JointOnRight or jointNormFacingLeft and JointOnFront or jointNormFacingRight and JointOnBack then (
			flipped = true
		)
	)
	else if jointFacingDown then (
		if jointNormFacingBackward and JointOnRight or jointNormFacingForward and JointOnLeft or jointNormFacingLeft and JointOnBack or jointNormFacingRight and JointOnFront then (
			flipped=true
		)

	)
	else if jointFacingLeft then (
		if jointNormFacingForward or jointNormFacingDown and JointOnFront then (
			flipped=true
		)
	)
	else if jointFacingRight then (
		if jointNormFacingBackward or jointNormFacingDown and JointOnBack then (
			flipped=true
		)
	)
	else if jointFacingForward then (
		if jointNormFacingDown and JointOnRight or jointNormFacingUp and JointOnLeft or jointNormFacingRight then (
			flipped=true
		)
	)
	else if jointFacingBackward then (
		if jointNormFacingDown and JointOnLeft or jointNormFacingUp and JointOnRight or jointNormFacingLeft then (
			flipped=true
		)
	)

	if flipped then (
		joint.MinLimit = -70
		joint.MaxLimit = 0
		deleteItem joint.flapSprings 1
		deleteItem joint.flapSprings 1
		append joint.FlapSprings [20,-20,0]
		append joint.FlapSprings [30,-70,0]
		--format "Flipping joint!\n"
	)
	--format "FlapSprings:%\n" joint.flapSprings
	joint
)

fn ExportC2Car carName rootObj = (

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

fn WeldParts obj partner weakness = (
	weldMod = AddStructureWeldModifier obj
	weldMod.WeldPartner = nodeTransformMonitor node:partner forwardTransformChangeMsgs:false
	weldMod.Weakness_Set = true

	weldMod.Weakness = weakness
	weldVerts = #()
	if ((classOf obj) == Editable_mesh or (classOf obj) == Editable_poly) and ((classOf partner) == Editable_mesh or (classOf partner) == Editable_poly) then (
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
	)
	else (
		weldVert = [0,0,0]
		append weldMod.WeldVertexType "part"
		append weldMod.WeldVertexPosition weldVert
	)
	
)

fn TessellateMesh obj = (
	if (classof obj) == Editable_mesh then (
		tessMod = Tessellate itterations:2 tension:0
		addModifier obj tessMod
		collapseStack  obj
	)
	for child in obj.children do (
		TessellateMesh child
	)
)
struct GrooveAnimDef (
	PartName,
	AnimType,	-- defined by StructureAnimationTypes
	Controller, -- defined by StructureAnimationControllers
	Centre,
	Period,
	Delta,
	Axis,
	Magnitude,
	MaxAngle,
	ShearTarget
)


fn ConvertCar C2CarName:"eagle3" = (
	global OpponentsTXT
	if OpponentsTXT == undefined then (
		OpponentsTXT = (dotnetclass "ToxicRagers.Carmageddon2.Formats.OpponentsTXT").Load C2OpponetsTextFile
	)

	additionalMatsToConvert = #()

	WAM = LoadWAMFile (C2DataFolder+CarsFolder+C2CarName+"\\"+C2CarName+".wam")
	TXT = LoadTXTFile (C2DataFolder+CarsFolder+C2CarName+"\\"+C2CarName+".txt")

	carRoot = LoadC2Dat (C2DataFolder+CarsFolder+C2CarName+"\\"+C2CarName+".dat") &progressValue &progressText imp_mat:true imp_smth:true imp_quad:true imp_hier:true imp_group:true imp_act:true prefix:"" imp_scale69:true
	--carShell = LoadC2Dat (C2DataFolder+CarsFolder+C2CarName+"\\"+C2CarName+"shell.dat") &progressValue &progressText imp_mat:false imp_smth:true imp_quad:true imp_hier:true imp_group:true imp_act:false prefix:"" imp_scale69:true

	carname="C2"+C2carname

	carFolder = CMDVehicleFolder+carName+"\\"
	
	format "Exporting to %\n" carFolder
	makedir carFolder
	
	RenderUIAssets carname "default" (carFolder+"ui_assets\\")

	

	FRWheelAct = undefined
	FLWheelAct = undefined
	RRWheelAct = undefined
	RLWheelAct = undefined

	FRPivotAct = undefined
	FLPivotAct = undefined
	RRPivotAct = undefined
	RLPivotAct = undefined

	suspensionGrooves = #()
	otherGrooves = #()

	for i=0 to TXT.Grooves.count - 1 do (
		groove =TXT.Grooves.Item[i]
		--format "\tGroove: % - #%: % - #%: %\n" groove.part groove.pathperiod (groove.PathType.ToString()) groove.animationperiod (groove.AnimationType.toString())
		if groove.PathType.ToString() == "straight" then (
			if groove.PathMode.ToString() != "absolute" then (
				append otherGrooves (GrooveAnimDef PartName:groove.Part AnimType:"Oscillate" Controller:"CONSTANT" Period:groove.PathPeriod Delta:groove.PathDelta)
			)
		)
		if groove.AnimationType.toString() == "spin" then (
			if groove.AnimationMode.toString() == "controlled" then (		
				if (substring groove.Part 1 1) == "F" then (
					if (substring groove.Part 2 1) == "L" then (
						FLWheelAct = groove.Part
					)
					else (
						FRWheelAct = groove.Part
					)
				)
				else (
					if (substring groove.Part 2 1) == "L" then (
						RLWheelAct = groove.Part
					)
					else (
						RRWheelAct = groove.Part
					)
				)
			)
			else (
				append otherGrooves (GrooveAnimDef PartName:groove.Part AnimType:"Rotate" Controller:"CONSTANT" Period:groove.AnimationPeriod Centre:groove.AnimationCentre Axis:(groove.AnimationAxis.toString()))
			)
		)
		else if groove.AnimationType.toString() == "rock" then (
			if groove.AnimationMode.toString() == "absolute" then (
				case groove.animationperiod of (
					7: (
						if groove.Part == "RRPIVOT.ACT" then (
							RRPivotAct = groove.Part
							rightSteerAct = groove.Part
						)
						else (
							FRPivotAct = groove.Part
							rightSteerAct = groove.Part
						)
					)
					8: (
						if groove.Part == "RLPIVOT.ACT" then (
							RLPivotAct = groove.Part
							leftSteerAct = groove.Part
						)
						else (
							FLPivotAct = groove.Part
							leftSteerAct = groove.Part
						)
					)
				)
			)
			else (
				append otherGrooves (GrooveAnimDef PartName:groove.Part AnimType:"Rock" Controller:"CONSTANT" Period:groove.AnimationPeriod Centre:groove.AnimationCentre Axis:(groove.AnimationAxis.toString()) MaxAngle:groove.RockMaxAngle)
			)
		)
		else if groove.AnimationType.toString() == "shear" then (
			shearTarget = ""
			for x = 1 to (TXT.LeftFrontSuspension.count) do (
				if TXT.LeftFrontSuspension[x] == groove.ShearPeriod.x or  TXT.LeftFrontSuspension[x] == groove.ShearPeriod.y or  TXT.LeftFrontSuspension[x] == groove.ShearPeriod.z then shearTarget = "Wheel_FL"
			)
			for x = 1 to (TXT.RightFrontSuspension.count) do (
				if TXT.RightFrontSuspension[x] == groove.ShearPeriod.x or  TXT.RightFrontSuspension[x] == groove.ShearPeriod.y or  TXT.RightFrontSuspension[x] == groove.ShearPeriod.z then shearTarget = "Wheel_FR"
			)
			for x = 1 to (TXT.LeftRearSuspension.count) do (
				if TXT.LeftRearSuspension[x] == groove.ShearPeriod.x or  TXT.LeftRearSuspension[x] == groove.ShearPeriod.y or  TXT.LeftRearSuspension[x] == groove.ShearPeriod.z then shearTarget = "Wheel_RL"
			)
			for x = 1 to (TXT.RightRearSuspension.count) do (
				if TXT.RightRearSuspension[x] == groove.ShearPeriod.x or  TXT.RightRearSuspension[x] == groove.ShearPeriod.y or  TXT.RightRearSuspension[x] == groove.ShearPeriod.z then shearTarget = "Wheel_RR"
			)
			shearAxis = "x"
			if groove.ShearPeriod.y != 0 then (
				shearAxis = "y"
			)
			else if groove.ShearPeriod.z != 0 then (
				shearAxis = "z"
			)
			append otherGrooves (GrooveAnimDef PartName:groove.Part AnimType:"Shear" Controller:"CONSTANT" Period:groove.ShearPeriod Centre:groove.AnimationCentre Magnitude:groove.ShearMagnitude ShearTarget:shearTarget Axis:shearAxis)
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

	if FLPivotAct != undefined then 
	(
		FLPivotObj = getnodebyname FLPivotAct
		leftSteerAct = FLPivotAct
	)
	if FRPivotAct != undefined then 
	(
		FRPivotObj = getnodebyname FRPivotAct
		rightSteerAct = FRPivotAct
	)
	if RLPivotAct != undefined then 
	(
		RLPivotObj = getnodebyname RLPivotAct
		leftSteerAct = RLPivotAct
	)
	if RRPivotAct != undefined then 
	(
		RRPivotObj = getnodebyname RRPivotAct
		rightSteerAct = RRPivotAct
	)

	format "FRWheel: %\tFRPivot:%\n" FRWheelAct FRPivotAct
	format "FLWheel: %\tFLPivot:%\n" FLWheelAct FLPivotAct
	format "RRWheel: %\tRRPivot:%\n" RRWheelAct RRPivotAct
	format "RRWheel: %\tRRPivot:%\n" RRWheelAct RRPivotAct
	format "Left Steer Act: %\t Right Steer Act: %" leftSteerAct rightSteerAct
	FLWheelObj = getnodebyname FLWheelAct
	FRWheelObj = getnodebyname FRWheelAct
	RLWheelObj = getnodebyname RLWheelAct
	RRWheelObj = getnodebyname RRWheelAct

	FLWheelObj.pivot = FLWheelObj.center
	FRWheelObj.pivot = FRWheelObj.center
	RLWheelObj.pivot = RLWheelObj.center
	RRWheelObj.pivot = RRWheelObj.center

	--RRPivotObj = InsertNullAbove RRWheelObj "RRPivot"
	--RLPivotObj = InsertNullAbove RLWheelObj "RLPivot"
	if FLPivotObj == undefined then (
		FLPivotObj = InsertNullAbove FLWheelObj "FLPivot"
	)
	else (
		FLPivotObj.pivot = FLWheelObj.pivot
	)
	if FRPivotObj == undefined then (
		FRPivotObj = InsertNullAbove FRWheelObj "FRPivot"
	)
	else (
		FRPivotObj.pivot = FRWheelObj.pivot

 	)
	if RLPivotObj == undefined then (
		RLPivotObj = InsertNullAbove RLWheelObj "RLPivot"
	)
	else (
		RLPivotObj.pivot = RLWheelObj.pivot
	)
	if RRPivotObj == undefined then (
		RRPivotObj = InsertNullAbove RRWheelObj "RRPivot"
	)
	else (
		RRPivotObj.pivot = RRWheelObj.pivot

 	)


	originalWamMeshes = #()
	originalWamMeshIndices = #()
	originalWamMeshVerts = #()
	for i = 0 to (WAM.CrushEntries.count-1) do (

		crush = WAM.CrushEntries.item[i]
		actorname = crush.Actor
		obj = getnodebyname actorname
		if obj != undefined then (
			append originalWamMeshes obj
			numObjVerts = getNumVerts obj
			append originalWamMeshVerts (for i = 1 to numObjVerts collect getVert obj i)
			append originalWamMeshIndices (buildcarmaindicesarray obj)
		)
	)

	TessellateMesh carRoot
	select carRoot
	SetSelectionToCNTNodes doChildren:true

	select carRoot
	max modify mode
	KeepMaxAlive()
	characteristicsMod = AddStructureCharacteristicsModifier carRoot
	KeepMaxAlive()
	cfgMod = AddVehilceCFGModifier carRoot
	KeepMaxAlive()
	vehicleSetupLUAMod = AddVehilceSetupLUAModifier carRoot
	KeepMaxAlive()
	handlingSetupLUAMod = AddHandlingSetupLUAModifier carRoot
	KeepMaxAlive()
	clearSelection()
	setCommandPanelTaskMode #create
	KeepMaxAlive()
	AddStructurePartModifier carRoot doChildren:true
 	wheels = ConvertAllWheels carname carRoot

	CreateExhaustVFX carRoot
	CreateLights carRoot

	characteristicsMod.ImmuneToWheelDamage_Active=true
	characteristicsMod.WholeBodyDeformationFactor=3

	handlingSetupLUAMod.CMPosY = TXT.CentreOfMass.y * 6.9
	cm_DistFromRearWheel = (TXT.CentreOfMass.z - (-RLWheelObj.pos.y))
	distFromRearWheelToFrontWheel = (-FLWheelObj.pos.y) - (-RLWheelObj.pos.y)
	handlingSetupLUAMod.CMPosZ = (cm_DistFromRearWheel/distFromRearWheelToFrontWheel) * 2 - 1

	handlingSetupLUAMod.NumGears = TXT.NumberOfGears
	handlingSetupLUAMod.Mass = TXT.Mass



	KeepMaxAlive()
	--select carRoot
 	for wheel in wheels do (
 		--format "% -> %\n" wheel.parent wheel.name
 		case wheel.name of (
 			"Wheel_FR": FRWheelObj = wheel
 			"Wheel_FL": FLWheelObj = wheel
 			"Wheel_RR": RRWheelObj = wheel
 			"Wheel_RL": RLWheelObj = wheel
		)
	)
 	append FLPivotObj.modifiers["Car Structure Part"].PhysicsProperties "FRONT_LEFT_POINT_OF_SUSPENSION"
 	if leftSteerAct == FLPivotAct then (
 		append FLPivotObj.modifiers["Car Structure Part"].PhysicsProperties "FRONT_LEFT_POINT_OF_STEERING"
 	)
 	append FLWheelObj.modifiers["Car Structure Part"].PhysicsProperties "FRONT_LEFT_POINT_OF_ROTATION"
 	append FLWheelObj.modifiers["Car Structure Part"].ShapeType "TIC_TAC_X"

 	append FRPivotObj.modifiers["Car Structure Part"].PhysicsProperties "FRONT_RIGHT_POINT_OF_SUSPENSION"
 	if rightSteerAct == FRPivotAct then (
 		append FRPivotObj.modifiers["Car Structure Part"].PhysicsProperties "FRONT_RIGHT_POINT_OF_STEERING"
 	)
 	append FRWheelObj.modifiers["Car Structure Part"].PhysicsProperties "FRONT_RIGHT_POINT_OF_ROTATION"
 	append FRWheelObj.modifiers["Car Structure Part"].ShapeType "TIC_TAC_X"
	
	if leftSteerAct == RLPivotAct then (
 		append RLPivotObj.modifiers["Car Structure Part"].PhysicsProperties "REAR_LEFT_POINT_OF_STEERING"
 	)
 	append RLPivotObj.modifiers["Car Structure Part"].PhysicsProperties "REAR_LEFT_POINT_OF_SUSPENSION"
 	append RLWheelObj.modifiers["Car Structure Part"].PhysicsProperties "REAR_LEFT_POINT_OF_ROTATION"
 	append RLWheelObj.modifiers["Car Structure Part"].ShapeType "TIC_TAC_X"

	if rightSteerAct == RLPivotAct then (
 		append RRPivotObj.modifiers["Car Structure Part"].PhysicsProperties "REAR_RIGHT_POINT_OF_STEERING"
 	)
 	append RRPivotObj.modifiers["Car Structure Part"].PhysicsProperties "REAR_RIGHT_POINT_OF_SUSPENSION"
 	append RRWheelObj.modifiers["Car Structure Part"].PhysicsProperties "REAR_RIGHT_POINT_OF_ROTATION"
 	append RRWheelObj.modifiers["Car Structure Part"].ShapeType "TIC_TAC_X"

 	WeldParts FLWheelObj FLPivotObj -4
 	WeldParts RLWheelObj RLPivotObj -4
 	WeldParts FRWheelObj FRPivotObj -4
 	WeldParts RRWheelObj RRPivotObj -4
 	WeldParts FLPivotObj carRoot -4
 	WeldParts RLPivotObj carRoot -4
 	WeldParts FRPivotObj carRoot -4
 	WeldParts RRPivotObj carRoot -4

	ConvertTDX = dotnetClass "Gibbed.Stainless.TDXConvertLib.ConvertTDX"
 	C2OpponentInfo = undefined
 	for i = 0 to OpponentsTXT.opponents.count - 1 do (
		opponent = OpponentsTXT.opponents.item[i]
 		if (toUpper opponent.CarFilename) == (toUpper TXT.Name) then (

 			vehicleSetupLUAMod.override_vehicle_name = opponent.CarName
 			vehicleSetupLUAMod.override_driver_name = opponent.DriverName
 			vehicleSetupLUAMod.override_bio = opponent.Bio
 			driverPortrait = C2CarImageFolder + c2carName+"CI\\tiffrgb\\"+opponent.DriverShortName+"64.tif"
 			ConvertTDX.Convert driverPortrait (carFolder+"ui_assets\\") 5
 			renameFile   (carFolder+"ui_assets\\"+opponent.DriverShortName+"64.tdx") (carFolder+"ui_assets\\"+carName+"_driver.tdx")
 			if opponent.NetworkAvailability == "eagle" then (
 				vehicleSetupLUAMod.eagle = true
 			)
 			regex = dotnetObject "System.Text.RegularExpressions.Regex" "[^:]+:[\s]*([0-9\.]+)[\s]*[a-zA-Z]+"
 			cfgMod.TopSpeed = (regex.replace opponent.TopSpeed "$1") as integer
 			cfgMod.Weight = (regex.replace opponent.KerbWeight "$1") as float
 			cfgMod.To60Time = (regex.replace opponent.To60 "$1") as float
 			cfgMod.Toughness = opponent.StrengthRating as float
 		)
 	)

	for i = 0 to (WAM.CrushEntries.count-1) do (
		crush = WAM.CrushEntries.item[i]
		actorname = crush.Actor
		obj = getnodebyname actorname
		

		if obj != undefined then (
			structMod = obj.modifiers["Car Structure Part"]
			for s = 0 to (crush.SmashEntries.count - 1) do (
				smash = crush.SmashEntries.item[s]
				matToReplace = smash.Trigger
				intactMat = (filterstring  smash.IntactMaterial ".")[1]
				for t = 0 to (smash.Levels.count - 1) do (
					texLevel = smash.Levels.item[t]
					replacementMat = (filterstring texLevel.pixelmaps.item[0] ".")[1]
					append structMod.CrushDamageMaterialLevel -(t+1)
					append structMod.CrushDamageMaterialOriginalMaterial matToReplace
					append structMod.CrushDamageMaterialTargetMaterial replacementMat
					append additionalMatsToConvert replacementMat
					connotations = smash.Levels.item[t].connotations
					for shrapId = 0 to (connotations.Shrapnel.count - 1) do (
						shrapnel = connotations.Shrapnel.item[shrapId]
						if shrapnel.ShrapnelType.toString() == "shards" then (
							append structMod.CrushDamageEmitterLevel -(t+1)
							append structMod.CrushDamageEmitterName "F_glasssmall"
 							CrushDamageEmitterTargetHelper = point prefix:("Position_Helper_"+obj.name) position:obj.pos
							append structMod.CrushDamageEmitterPosition ((nodeTransformMonitor node:CrushDamageEmitterTargetHelper forwardTransformChangeMsgs:false))
						)
					)
				)
			)
			crushtype =crush.Type.tostring()
			softness = crush.Softness.tostring()
			--format "% - % %\n" actorname (crush.Type.tostring()) (crush.Softness.tostring())

				obj.modifiers["Car Structure Part"].Crushability_Set = true
				obj.modifiers["Car Structure Part"].Crushability = case softness of (
					"soft":2.0
            		"normal":1.1
            		"hard":0.9
            		"very_hard":0.75
            		"uncrushable":0
				)
			case crushtype of (
				"boring": (
					if obj != carRoot then (
						parent = obj.parent
						if parent == undefined then parent = carRoot
						weldMod = AddStructureWeldModifier obj
						weldMod.WeldPartner = nodeTransformMonitor node:parent forwardTransformChangeMsgs:false
						weldMod.Weakness_Set = true

						weldMod.Weakness = 0
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
					)
				)
				"detach": (
						parent = obj.parent
						if parent == undefined then parent = carRoot
						--weldMod = AddStructureWeldModifier obj
					weldMod = AddStructureWeldModifier obj
					weldMod.WeldPartner = nodeTransformMonitor node:parent forwardTransformChangeMsgs:false
					weldMod.Weakness_Set = true

					easeOfDetach = crush.EaseOfDetach.toString()
					weldMod.Weakness = case easeOfDetach of (
						"very_soft": -1
	            		"very_easy": -1
	            		"easy": -2
	            		"normal": -3
	            		"hard": -4
					)
					weldVerts = FindWeldVerts obj parent tolerance: 0.0001
					if weldVerts.count < 1 then (
						-- Try again with much reduced tolerance, because fuck it!
						weldVerts = FindWeldVerts obj parent tolerance: 0.1
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
						"stubborn": (j
							weldMod.weakness_set = false
							joints = CreateBallJointsForStubbornDetachable obj
							append weldMod.Joints joints[1]
							append weldMod.Joints joints[2]
						)
					)
				)
				"flap": (
						parent = obj.parent
						if parent == undefined then parent = carRoot
						--weldMod = AddStructureWeldModifier obj
					weldMod = AddStructureWeldModifier obj
					weldMod.weakness_set = false
					weldMod.WeldPartner = nodeTransformMonitor node:parent forwardTransformChangeMsgs:false

					weldMod2 = AddStructureWeldModifier obj
					weldMod2.WeldPartner = nodeTransformMonitor node:parent forwardTransformChangeMsgs:false
					weldMod2.Weakness_Set = true
					weldMod2.Weakness = -3
					weldMod2.WeldBreak_Set = true
					weldMod2.WeldBreak = 30

					originalWamMeshIndex = finditem originalWamMeshes obj
					originalMeshVerts = originalWamMeshVerts[originalWamMeshIndex]
					originalMeshIndicies = originalWamMeshIndices[originalWamMeshIndex]

					hingePoint1 = crush.HingePoints.Item[0]+1
					hingePoint2 = crush.HingePoints.Item[1]+1
					latchPoint = crush.HingePoints.Item[2]+1
					
					hingeVert1 = originalMeshVerts[hingePoint1]
					hingeVert2 = originalMeshVerts[hingePoint2]
					latchVert = originalMeshVerts[latchPoint]

					append weldMod.WeldVertexType "part"
					append weldMod.WeldVertexType "part"
					append weldMod.WeldVertexPosition hingeVert1 
					append weldMod.WeldVertexPosition hingeVert2

					append weldMod2.WeldVertexType "part"
					append weldMod2.WeldVertexPosition latchVert

					flapJoint = CreateHingeJointFromPoints obj hingeVert1 hingeVert2 latchVert	carRoot:carRoot
					--format "Flap joint transform: %\n" flapJoint.transform
					append weldMod.Joints flapJoint

				)
			)
		)
	)

 	for i=1 to otherGrooves.count do (
 		groove = otherGrooves[i]
 		obj = getnodebyname groove.PartName

 		if groove.AnimType == "Shear" then (
 			shearCentre = [-groove.Centre.x, -groove.Centre.z, groove.Centre.y] * 6.9
 			shearCentre = obj.center
 			format "Shear axis: %\n" groove.Axis
 			if groove.Centre.x != 0 then shearCentre.x = -groove.Centre.x * 6.9
 			else if groove.Centre.z != 0 then shearCentre.y = -groove.Centre.z * 6.9
 			else if groove.Centre.y != 0 then shearCentre.z = groove.Centre.y * 6.9
 			pointToPointMod =AddStructurePointToPointModifer obj
 			pointToPointMod.TypeOfPointToPoint_Selection = 1
 			pointToPointMod.TypeOfPointToPoint = StructurePointToPointValues[1]
 			pointOnThisObjectHelper = point prefix:("Position_Helper_"+obj.name) position:shearCentre

 			pointToPointMod.PointOnThisObject = nodeTransformMonitor node:pointOnThisObjectHelper forwardTransformChangeMsgs:false
 			pointToPointMod.PointOnOtherObject = nodeTransformMonitor node:pointOnThisObjectHelper forwardTransformChangeMsgs:false
 			pointToPointMod.OtherObject = nodeTransformMonitor node:carRoot forwardTransformChangeMsgs:false

 			pointToPointModWithScaling = AddStructurePointToPointModifer obj
 			pointToPointModWithScaling.TypeOfPointToPoint_Selection = 4
 			pointToPointModWithScaling.TypeOfPointToPoint = StructurePointToPointValues[4]
 			shearTargetObject = getnodebyname groove.ShearTarget
 			pointOnThisObjectScalingTargetHelper = point prefix:("Position_Helper_"+obj.name) position:shearTargetObject.pos
 			pointToPointModWithScaling.PointOnThisObject = nodeTransformMonitor node:pointOnThisObjectScalingTargetHelper forwardTransformChangeMsgs:false
 			pointToPointModWithScaling.PointOnOtherObject = nodeTransformMonitor node:pointOnThisObjectScalingTargetHelper forwardTransformChangeMsgs:false
 			pointToPointModWithScaling.OtherObject = nodeTransformMonitor node:shearTargetObject forwardTransformChangeMsgs:false

 		)
 		else (
 			animMod = AddStructureAnimationModifer obj
 			animMod.AnimationTypeSelection =finditem StructureAnimationTypes groove.AnimType
 			animMod.AnimationType =groove.AnimType
 			animMod.ControlledBy = "CONSTANT_OVER_TIME"
 			animMod.ControlledBySelection = 2
 			if (tolower groove.axis) == "x" then (
 				animMod.axis = 1
  			)
  			else if (tolower groove.axis) == "y" then (
 				animMod.axis = 2
  			)
  			else (
  				animMod.axis = 3
  			)
  			format "Groove.axis: %\t\tAnimMod.axis: %\n" groove.axis animMod.axis

 			if groove.AnimType == "Oscillate" then (
 				animMod.Amount = groove.Period
 				animMod.Amount2 = length [groove.Delta.x,groove.Delta.y,groove.Delta.z] * 6.9
 				if groove.delta.x == 0 and groove.delta.y == 0 then (
 					animMod.axis = 1
 				)
 				else if groove.delta.x == 0 and groove.delta.z == 0 then (
 					animMod.axis =  2
 				)
 				else if groove.delta.z == 0 and groove.delta.y == 0 then (
 					animMod.axis = 3
 				)
 				else (
 					-- non axis aligned animation, create parent null
 					animAxis = normalize groove.delta
 					animAxis = [-animAxis.x, -animAxis.z, animAxis.y]
 					trans = matrixFromNormal animAxis
 					trans.pos = obj.pos
 					offsetNode = CreateNewNullNode trans (obj.name+"_offset")
 					offsetNode.parent = obj.parent
 					AddStructurePartModifier offsetNode
 					obj.parent = offsetNode
 					animMod.axis = 3
  				)

 			)
 			else if groove.AnimType == "Rotate" then (
 				animMod.Amount = groove.period * 6.9

 				if groove.Centre.x != 0 or  groove.Centre.y != 0 or  groove.Centre.z != 0 then (
 					offsetCentre = [-groove.Centre.x, -groove.Centre.z, groove.Centre.y] * 6.9
 					trans = obj.transform
 					trans.pos = trans.pos + offsetCentre
 					offsetNode = CreateNewNullNode trans (obj.name+"_offset")
 					offsetNode.parent = obj.parent
 					AddStructurePartModifier offsetNode
 					obj.parent = offsetNode
 					deleteModifier obj animMod
 					addModifier offsetNode animMod

 				)
 			)
 			else if groove.AnimType == "Rock" then (
 				animMod.Amount = groove.period
 				animMod.Amount2 = groove.MaxAngle

 				pointOnThisObjectScalingTargetHelper = point prefix:("Position_Helper_"+obj.name) position:[-groove.Centre.x, -groove.Centre.z, groove.Centre.y]
 				animMod.CentreOfRotation = (nodeTransformMonitor node:pointOnThisObjectScalingTargetHelper forwardTransformChangeMsgs:false) 
 			)
 		)
 	)

	for obj in objects do (
		splitname = filterstring obj.name "."
		if splitname.count > 1 and ((toupper splitname[2]) == "DAT" or (toupper splitname[2]) == "ACT") then (
			obj.name = splitname[1]
		)
	)
	for mat in scenematerials do  (
		if (classof mat) == Multimaterial then ( 
			for submat in mat.material do (
				if submat != undefined then (
				splitname = filterstring submat.name "."
				submat.name = splitname[1]
				)
			)
		)
		else (
				splitname = filterstring mat.name "."
				mat.name = splitname[1]
		)
	)

	carShell = LoadC2Dat (C2DataFolder+CarsFolder+C2CarName+"\\"+C2CarName+"shell.dat") &progressValue &progressText imp_mat:false imp_smth:true imp_quad:true imp_hier:true imp_group:true imp_act:false prefix:"" imp_scale69:true

	--format "Car Shell: %\n" carShell
	collisionMesh = computeConvexHull carShell
	KeepMaxAlive()
	select collisionMesh
	setNumTVerts collisionMesh ((getNumFaces $) * 3)
	buildTVFaces collisionMesh

	SetSelectionToCNTNodes doChildren:true
	collisionMesh.scale=[1.1,1.1,1]
	collisionMesh.modifiers["CNT Hierarchy"].BakeScaleIntoMesh=true
	collisionMesh.modifiers["CNT Hierarchy"].filename="c_body_collision"
	collisionMesh.name = "c_Body"
	ExportMDL carFolder false true exportMats:true exportTextures:true funsizeExport:false createOctree:false nodes:#(collisionMesh)
	ExportCNT (carFolder+"collision.cnt") collisionMesh
	
	delete carShell

	carRoot.name="c_Body"
	carRoot.modifiers["CNT Hierarchy"].filename="c_Body"

	carFolder = CMDVehicleFolder+carName+"\\"
	if (classof carRoot.material) == Multimaterial then (
		carRoot.material.material[1].name = "Paint"
	)
	else (
		carRoot.material.name="Paint"
	)
	format "Exporting to %\n" carFolder
	makedir carFolder
	ExportCarVehicleSetupLUA (carFolder+"vehicle_setup.lua") vehicleSetupLUAMod
	ExportCarVehicleCFG (carFolder) cfgMod
	ExportCarSetupLUA (carFolder) handlingSetupLUAMod
	ExportStructureXML (carFolder+"structure.xml") carRoot

	global MaterialsToExport
	MaterialsToExport=#()

		currentScriptFileName = getThisScriptFilename()
		currentScriptFolder = getFilenamePath currentScriptFileName
	ExportMDL carFolder false true exportMats:true exportTextures:true funsizeExport:false createOctree:false nodes:#(carRoot)
	ExportCNT (carFolder+"car.cnt") carRoot
	for i = 1 to MaterialsToExport.count do (

		actualMat = MaterialsToExport[i][2]
		bitmapFileName = undefined
		oppactiyMapFileName = undefined

		if actualMat != undefined and actualMat.diffuseMap != undefined and (classof actualMat.diffuseMap) == bitmaptexture then
		(
			bitmapFileName = actualMat.diffuseMap.filename
		)
		if actualMat != undefined and actualMat.OpacityMap != undefined and (classof actualMat.OpacityMap) == bitmaptexture then
		(
			MaterialsToExport[i][3] = #(
				(OtherTexturesDef Alias:"Spec_Map" TextureName:"spec"),
				(OtherTexturesDef Alias:"Normal_Map" TextureName:"normal")
			)
		)
		else (
			MaterialsToExport[i][3] = #(
				(OtherTexturesDef Alias:"Side1_Spec_Map2" TextureName:"spec"),
				(OtherTexturesDef Alias:"Side1_Normal_Map2" TextureName:"normal"),
				(OtherTexturesDef Alias:"Side1_Spec_Map1" TextureName:"spec"),
				(OtherTexturesDef Alias:"Side1_Normal_Map1" TextureName:"normal"),
				(OtherTexturesDef Alias:"Side1_DiffuseColour1" TextureName:bitmapFileName),
				(OtherTexturesDef Alias:"Side2_Spec_Map" TextureName:"spec"),
				(OtherTexturesDef Alias:"Side2_Normal_Map" TextureName:"normal"),
				(OtherTexturesDef Alias:"Side2_DiffuseColour" TextureName:bitmapFileName)
			)

		)

			MaterialsToExport[i][3] = #(
				(OtherTexturesDef Alias:"Spec_Map" TextureName:"spec"),
				(OtherTexturesDef Alias:"Normal_Map" TextureName:"normal")
			)
	)
	ExportMaterialsAndTextures carFolder exportMats:true exportTextures:true funsizeExport:false createOctree:false baseMaterial:"simple_norm_spec_env_base" baseTransparentMaterial:"simple_norm_spec_env_base_A" alphaTextureName:(currentScriptFolder+"\\near-black-alpha.png") diffuseAlias:"DiffuseColour"
	for mat in additionalMatsToConvert do (
		mat = (filterstring mat ".")[1]
		bmpFolder = C2DataFolder+CarsFolder+C2CarName+"\\tiffrgb\\"
		bmp =  (openbitmap (bmpFolder + mat + ".tif"))
		if bmp == undefined then (
			bmpFolder = C2DataFolder+"\\REG\\PIXELMAP\\tiffrgb\\"
			bmp =  (openbitmap (bmpFolder + mat + ".tif"))
		)
		if bmp != undefined then (
			baseMat = "simple_norm_spec_env_base"
			alphaImage = (currentScriptFolder+"\\near-black-alpha.png")
			diffuseAlias = "DiffuseColour"
			otherTextures = #(
				(OtherTexturesDef Alias:"Side1_Spec_Map2" TextureName:"spec"),
				(OtherTexturesDef Alias:"Side1_Normal_Map2" TextureName:"normal"),
				(OtherTexturesDef Alias:"Side1_Spec_Map1" TextureName:"spec"),
				(OtherTexturesDef Alias:"Side1_Normal_Map1" TextureName:"normal"),
				(OtherTexturesDef Alias:"Side1_DiffuseColour1" TextureName:mat),
				(OtherTexturesDef Alias:"Side2_Spec_Map" TextureName:"spec"),
				(OtherTexturesDef Alias:"Side2_Normal_Map" TextureName:"normal"),
				(OtherTexturesDef Alias:"Side2_DiffuseColour" TextureName:mat)
			)
			if bmp.hasAlpha then (
				baseMat = "simple_norm_spec_env_base_A"
				alphaImage = ""
				diffuseAlias = "DiffuseColour"
				otherTextures = #(
					(OtherTexturesDef Alias:"Spec_Map" TextureName:"spec"),
					(OtherTexturesDef Alias:"Normal_Map" TextureName:"normal")
				)
			)
				otherTextures = #(
					(OtherTexturesDef Alias:"Spec_Map" TextureName:"spec"),
					(OtherTexturesDef Alias:"Normal_Map" TextureName:"normal")
				)
			ExportMaterial carFolder mat mat baseMaterial:baseMat alphaImage:alphaImage diffuseAlias:diffuseAlias otherTextures: otherTextures


			ConvertTDX.Convert bmp.filename	carFolder 5 alphaImage
		)
	)
	carMaxSaveFolder = MaxSaveFolder + C2CarName + "\\"
	makedir carMaxSaveFolder
	saveMaxFile (carMaxSaveFolder+C2CarName+".max") useNewFile:false
	carRoot
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
fn ConvertAllCars = (
	carFolders = getDirectories "G:\\VanillaC2\\Data\\CARS\\*"
	numCars = carFolders.count
	errors= StringStream ""
	numErrors = 0
	numConverted = 0
	i = 1
	while i <= numCars do (
		carFolder = carFolders[i]
		carName = GetFolderName carFolder
		if (getfiles (carFolder+"\\"+carName+".dat")).count != 0 then (
			
			try (
				convertcar c2carName:carName
				numConverted = numConverted + 1
			)
			catch (
				numErrors = numErrors + 1
				format "Failed to convert %\n" carname to:errors
				KeepMaxAlive()
				CompleteRedraw()
			)
			select objects
			if $ != undefined then
			(
				delete $
			)
			resetMaxFile #noprompt
		)
		i = i + 1

		if i > 100 then (
			numCars = 0
		)

	)
	format "converted % cars with % errors\n%\n" numConverted numErrors (errors as string)
)
fn CreateCarList playerCar:"eagle3"= (
	carFolders = getDirectories "G:\\VanillaC2\\Data\\CARS\\*"
	numCars = carFolders.count
	carList = StringStream ""
	numErrors = 0
	numConverted = 0
	i = 1
	while i <= numCars do (
		i = i + 1
		carFolder = carFolders[i]
		carName = GetFolderName carFolder
		if (getfiles (carFolder+"\\"+carName+".dat")).count != 0 and (getfiles (carFolder+"\\"+carName+".wam")).count != 0 then (
			if carName ==playerCar then human=true
			else human =false
			format "{ human=%, car=\"C2%\" },\n" human carName
		)
	)
	format "converted % cars with % errors\n%\n" numConverted numErrors (errors as string)
)
fn LoadAllCars = (
	format "Loading all cars from: %\n" (C2DataFolder + CarsFolder)
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