forceDummyNull = true

	loadedOtherScripts = true
	C1Folder = "g:\\Carma1\\"
	C1DataFolder = C1Folder+"data\\"
	C1CarImageFolder = C1Folder+"data\\INTRFACE\\CarImage\\"
	CarsFolder = "cars\\"
	C1OpponetsTextFile = C1DataFolder+"OPPONENT.TXT"
	MaxSaveFolder = "D:\\Work\\ReincarnationTools\\VehicleDev\\C1MobilePorts\\"
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
	filein "BeelzebubTools.ms"
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


fn LoadTXTFile file = (
	TXTClass = dotNetClass "ToxicRagers.Carmageddon.Formats.Car"
	TXTFile = TXTClass.Load file false
	TXTFile
)



fn InsertNullAbove target nullName =
(
	newnode = CreateNewNullNode target.transform nullName
	newnode.parent =target.parent
	target.parent = newnode

	newnode
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


fn ConvertAllWheels carName rootMesh TXT = (
	wheelNames = #()
	for g = 0 to (TXT.Grooves.count - 1) do (
		groove = TXT.Grooves.item[g]
		if groove.animationtype.tostring() == "spin" and groove.animationmode.tostring() == "controlled" then (
			append wheelNames (toupper groove.Part)
		)
	)

	wheels = for obj in objects where (finditem wheelNames (toupper obj.name)) > 0 collect obj
	newwheels = #()
	for wheel in wheels do (
		wheelType="Wheel_FR"

		wheel.name = (filterstring wheel.name ".")[1]
		wheel.parent = rootMesh
		tyreName = "default_"+carName+"_"+wheel.name
		if (findstring wheel.name "rr") !=undefined then wheel.name ="whlRR"
		else if (findstring wheel.name "fr")  !=undefined then wheel.name ="whlFR"
		else if (findstring wheel.name "rl")  !=undefined then wheel.name ="whlRL"
		else if (findstring wheel.name "fl")  !=undefined then wheel.name ="whlFL"
		else if (findstring wheel.name "ml")  !=undefined then wheel.name ="whlML"
		else if (findstring wheel.name "mr")  !=undefined then wheel.name ="whlMR"
		else if (findstring wheel.name "l") != undefined then wheel.name = "whlML2"
		else if (findstring wheel.name "r") != undefined then wheel.name = "whlMR2"

		append newwheels wheel
		
		
	)
	newwheels
)
fn MakeCollisionMeshes objs: singleMesh:false maxVerts:16 minHeight: = (
	collisionMeshes = #()
	if objs ==unsupplied then (
		objs = #()
		for obj in objects do (
			if (findstring obj.name "whl") != 1 then (
				append objs obj
			)
		)
	)
	format "%\n" objs
	for obj in objs where (classof obj) == Editable_mesh do (
		select obj
		collisionMesh = computeConvexHull obj pushamt:0.0 maxverts:maxVerts

		vertnum = getnumverts collisionMesh
		if vertnum < 1 then ( delete collisionMesh)
		else (
			if minHeight != unsupplied then (
				for  v = 1 to vertnum do (
					vpos = getvert collisionMesh v
					if vpos.z < minHeight then setvert collisionMesh v [vpos.x, vpos.y, minHeight]
				)
			)
			if singleMesh and collisionMeshes.count > 0 then (
				collisionMesh.pivot = [0,0,0]
				meshop.attach collisionMeshes[1]  collisionMesh
			)
			else (
				append collisionMeshes collisionMesh
			)
		)
		
	)
	if singleMesh then (
		combinedMesh = collisionMeshes[1]
		select combinedMesh
		finalCollisionMesh =computeConvexHull combinedMesh pushamt:0.0
		collisionMeshes[1] = finalCollisionMesh
		delete combinedMesh
	)

	collisionMeshes
)
fn ConvertCar C1CarName:"ivan" prefix:"C1SP" doexport:true = (
	global OpponentsTXT
	if OpponentsTXT == undefined then (
		OpponentsTXT = (dotnetclass "ToxicRagers.Carmageddon.Formats.OpponentTXT").Load C1OpponetsTextFile
	)

	additionalMatsToConvert = #()

	TXT = LoadTXTFile (C1DataFolder+CarsFolder+C1CarName+".txt")

	carRoot = LoadC1TXT  (C1DataFolder+CarsFolder+C1CarName+".txt") &progressValue &progressText imp_onlyMainMeshes:true imp_mat:true imp_smth:true imp_quad:true imp_hier:true imp_group:true imp_act:true prefix:"" imp_scale69:true
	--carShell = LoadC2Dat (C2DataFolder+CarsFolder+C2CarName+"\\"+C2CarName+"shell.dat") &progressValue &progressText imp_mat:false imp_smth:true imp_quad:true imp_hier:true imp_group:true imp_act:false prefix:"" imp_scale69:true
	delete (for obj in objects where obj.parent == undefined and obj != carRoot collect obj)
	carname=prefix+C1carname

	for obj in objects do (
		instances = #()
		InstanceMgr.GetInstances obj &instances
		InstanceMgr.MakeObjectsUnique &instances #group
		RotatePivotOnly obj (inverse obj.rotation)

		if (classof obj) == Editable_mesh then (
			SetMeshVertColoursToGrey obj
		)
		obj.pivot = obj.center
	)
	carroot.pivot = [0,0,0]
	carFolder = FunsizeLaunchInfo.DataFolder+"VEHICLES\\"+carName+"\\"
	
	format "Exporting to %\n" carFolder
	--makedir carFolder
	
	
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
		/*if groove.PathType.ToString() == "straight" then (
			if groove.PathMode.ToString() != "absolute" then (
				append otherGrooves (GrooveAnimDef PartName:groove.Part AnimType:"Oscillate" Controller:"CONSTANT" Period:groove.PathPeriod Delta:groove.PathDelta)
			)
		)*/
		if groove.AnimationType.toString() == "spin" then (
			if groove.AnimationMode.toString() == "controlled" then (		
				/*if (substring groove.Part 1 1) == "F" then (
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
				)*/
			)
			else (
				append otherGrooves (GrooveAnimDef PartName:groove.Part AnimType:"Rotate" Controller:"CONSTANT" Period:groove.AnimationPeriod Centre:groove.AnimationCentre Axis:(groove.AnimationAxis.toString()))
			)
		)
		else if groove.AnimationType.toString() == "rock" then (
			if groove.AnimationMode.toString() == "absolute" then (
				/*case groove.animationperiod of (
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
				)*/
			)
			else (
				append otherGrooves (GrooveAnimDef PartName:groove.Part AnimType:"Rock" Controller:"CONSTANT" Period:groove.AnimationPeriod Centre:groove.AnimationCentre Axis:(groove.AnimationAxis.toString()) MaxAngle:groove.RockMaxAngle)
			)
		)
		else if groove.AnimationType.toString() == "shear" then (
			shearTarget = ""
			for x = 1 to (TXT.LeftFrontSuspension.count) do (
				if TXT.LeftFrontSuspension[x] == groove.ShearPeriod.x or  TXT.LeftFrontSuspension[x] == groove.ShearPeriod.y or  TXT.LeftFrontSuspension[x] == groove.ShearPeriod.z then appendIfUnique suspensionGrooves groove.Part
			)
			for x = 1 to (TXT.RightFrontSuspension.count) do (
				if TXT.RightFrontSuspension[x] == groove.ShearPeriod.x or  TXT.RightFrontSuspension[x] == groove.ShearPeriod.y or  TXT.RightFrontSuspension[x] == groove.ShearPeriod.z then appendIfUnique suspensionGrooves groove.Part
			)
			for x = 1 to (TXT.LeftRearSuspension.count) do (
				if TXT.LeftRearSuspension[x] == groove.ShearPeriod.x or  TXT.LeftRearSuspension[x] == groove.ShearPeriod.y or  TXT.LeftRearSuspension[x] == groove.ShearPeriod.z then appendIfUnique suspensionGrooves groove.Part
			)
			for x = 1 to (TXT.RightRearSuspension.count) do (
				if TXT.RightRearSuspension[x] == groove.ShearPeriod.x or  TXT.RightRearSuspension[x] == groove.ShearPeriod.y or  TXT.RightRearSuspension[x] == groove.ShearPeriod.z then appendIfUnique suspensionGrooves groove.Part
			)
			shearAxis = "x"
			if groove.ShearPeriod.y != 0 then (
				shearAxis = "y"
			)
			else if groove.ShearPeriod.z != 0 then (
				shearAxis = "z"
			)
			--append otherGrooves (GrooveAnimDef PartName:groove.Part AnimType:"Shear" Controller:"CONSTANT" Period:groove.ShearPeriod Centre:groove.AnimationCentre Magnitude:groove.ShearMagnitude ShearTarget:shearTarget Axis:shearAxis)
		)
	)

	for groove in suspensionGrooves do (
		format "Groove name: %\n" groove
 		obj = getnodebyname groove
 		RotatePivotOnly obj (quat 0 0 0 1)
		if (findString obj.Name "fr") != undefined then (
			obj.Name = "susFR"
			obj.pivot.x = obj.max.x
		)
		if (findString obj.Name "fl") != undefined then (
			obj.Name = "susFL"
			obj.pivot.x = obj.min.x
		)
		if (findString obj.Name "rr") != undefined then (
			obj.Name = "susRR"
			obj.pivot.x = obj.max.x
		)
		if (findString obj.Name "rl") != undefined then (
			obj.Name = "susRL"
			obj.pivot.x = obj.min.x
		)
	)

	FLWheelPos = [0,0,0]
	FRWheelPos = [0,0,0]
	RLWheelPos = [0,0,0]
	RRWheelPos = [0,0,0]

	centreOfMass = [-txt.centreOfMass.item[0],txt.centreOfMass.item[2],txt.centreOfMass.item[1]] * 6.9
	/*for i=0 to (TXT.Wheels.count-1) do (
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
	)*/

	--TessellateMesh carRoot
	select carRoot
	SetSelectionToCNTNodes doChildren:true

	select carRoot
	max modify mode
	KeepMaxAlive()
	funsizeCarMod = AddFunsizeCarAttributes carRoot
	funsizeCarMod.CarName = carName
	KeepMaxAlive()
	hudMod = FunsizeAddHudDamageAttributes carRoot
	clearSelection()
	setCommandPanelTaskMode #create

 	wheels = ConvertAllWheels carname carRoot TXT

	FunsizeSetDefaultHudDamageEntries hudMod

	dynamicsText = StringStream ""
	format "CMPosY %\n" (TXT.CentreOfMass.y * 6.9) to:dynamicsText
	format "CMPosZ %\n" (TXT.CentreOfMass.z * 6.9) to:dynamicsText
	format "numgears %\n" TXT.NumberOfGears to:dynamicsText
	format "SuspDamping %\n" TXT.DampingFactor to:dynamicsText
	format "FrontSuspGive %\n" (TXT.SuspensionGive.x * 6.9) to:dynamicsText
	format "RearSuspGive %\n" (TXT.SuspensionGive.y * 6.9) to:dynamicsText
	format "tractionfactor %\n" (TXT.TractionFractionalMultiplier) to:dynamicsText
	format "FrontRoll %\n" (TXT.RollingResistance.x) to:dynamicsText
	format "RearRoll %\n" (TXT.RollingResistance.y) to:dynamicsText
	funsizeCarMod.DynamicsText = dynamicsText as string
	bodycrush = txt.Crushes.item[txt.actorlods.indexof 0]
	funsizeCarMod.Softness = bodycrush.softnessfactor
	funsizeCarMod.Mass = TXT.Mass * 1000
	funsizeCarMod.TopSpeed = TXT.TopGearRedlineSpeed
	funsizeCarMod.BHPperTon = TXT.TopGearAcceleration * 150
	funsizeCarMod.EngineNoises = ""
	for engineNoise in TXT.EngineNoises do (
		funsizeCarMod.EngineNoises = funsizeCarMod.EngineNoises + (engineNoise as string) +"\n"
	)

	KeepMaxAlive()

 	C2OpponentInfo = undefined
 	for i = 0 to OpponentsTXT.opponents.count - 1 do (
		opponent = OpponentsTXT.opponents.item[i]
 		if (toUpper opponent.CarFilename) == (toUpper TXT.Name) then (

 			funsizeCarMod.CarFullName = carName
 			funsizeCarMod.CarDescription = opponent.Bio
 			funsizeCarMod.DriverName = opponent.DriverName
 			funsizeCarMod.WastedName = opponent.DriverShortName + " Wasted"
 			funsizeCarMod.NaughtToSixty = (filterstring opponent.To60 " ")[2]
 		)
 	)

	grooveText = StringStream ""

 	for i=1 to otherGrooves.count do (
 		groove = otherGrooves[i]
 		obj = getnodebyname groove.PartName
 		groovePartName = (filterstring groove.PartName ".")[1]
 		grooveCentre = [-groove.Centre.x, groove.Centre.z, groove.Centre.y] * 6.9
 		obj.pivot = grooveCentre

 		/*
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
 		else */(
 			/*
 			animMod = AddStructureAnimationModifer obj
 			animMod.AnimationTypeSelection =finditem StructureAnimationTypes groove.AnimType
 			animMod.AnimationType =groove.AnimType
 			animMod.ControlledBy = "CONSTANT_OVER_TIME"
 			animMod.ControlledBySelection = 2*/



 			/*if groove.AnimType == "Oscillate" then (
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
 			else*/ if groove.AnimType == "Rotate" then (
 				
 				axisNum = 0
 				if groove.Axis == "y" then axisNum = 1
 				else if groove.Axis == "z" then axisNum = 2
 				format "[GROOVADELIC]\nGrooveSpin\nname %\naxis %\nspeed %\n\n" groovePartName axisNum (groove.Period * 394) to:grooveText
 				
 			)
 			else if groove.AnimType == "Rock" then (
 				axisNum = 0
 				if groove.Axis == "y" then axisNum = 1
 				else if groove.Axis == "z" then axisNum = 2
 				format "[GROOVADELIC]\nGrooveSwing\nname %\nspeed %\namplitude %\naxis %\n\n" groovePartName (groove.Period * 394) groove.MaxAngle axisNum to:grooveText
 				
 			)
 		)
 	)
 	funsizeCarMod.Grooves = grooveText as string
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

	--carShell = LoadC1TXT TXT &progressValue &progressText imp_mat:false imp_smth:true imp_quad:true imp_hier:true imp_group:true imp_act:false prefix:"" imp_scale69:true

	--format "Car Shell: %\n" carShell
	objsForCollisions = #(carRoot)

	for obj in objsForCollisions do (join objsForCollisions obj.children )
	collisionMeshes = MakeCollisionMeshes objs:objsForCollisions minHeight:carRoot.min.z singleMesh:true maxverts:24
	KeepMaxAlive()
	for collisionMesh in collisionMeshes do (
		AddFunsizeShapeToCollisions collisionMesh carRoot
		collisionMesh.isHidden = true
	)

	carRoot.name="carbody"
	carRoot.modifiers["CNT Hierarchy"].filename="carbody"
	if doexport then (
		ExportFunsizeCar carroot nolaunch:true
	)
	carMaxSaveFolder = MaxSaveFolder + C1CarName + "\\"
	makedir carMaxSaveFolder
	saveMaxFile (carMaxSaveFolder+C1CarName+".max") useNewFile:false
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
fn ConvertSPCars skip:0 maxcars:99 = (
	spCars = #("333", "BUGGIT", "DOOZER", "JAQUES", "JEEPY", "MONSTER", "MUSCLE", "NEWANNIE", "NEWEAGLE", "PARAMED", "PORK", "ROADHOG", "SEMI", "SLED", "SPAGHETI", "SUBFRAME", "TOOHORSE", "V6SHAME", "VLAD2")
	numcars = 0
	for car in spCars do (
		if skip <= numCars and maxcars > numcars then (
			ConvertCar c1carName:car
			select ObjectS

			if $ != undefined then (
				delete $
			)
			resetMaxFile #noprompt
		)
		numcars = numCars + 1
	)
	packobb()
)
fn ConvertAllCars = (
	carFolders = getFiles C1DataFolder+CarsFolder+"*.txt"
	numCars = carFolders.count
	errors= StringStream ""
	numErrors = 0
	numConverted = 0
	i = 1
	while i <= numCars do (
		carTxt = carFolders[i]
		carName = GetFolderName carTxt
		
			try (
				convertcar c1carName:carName
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
		
		i = i + 1

		if i > 100 then (
			numCars = 0
		)

	)
	format "converted % cars with % errors\n%\n" numConverted numErrors (errors as string)
)
fn CreateCarList playerCar:"blkeagle"= (
	carFolders = getFiles C1DataFolder+CarsFolder+"*.txt"
	numCars = carFolders.count
	carList = StringStream ""
	numErrors = 0
	numConverted = 0
	i = 1
	while i <= numCars do (
		i = i + 1
		carTxt = carFolders[i]
		carName = GetFilenameFile carTxt
		if carName ==playerCar then human=true
		else human =false
		format "{ human=%, car=\"C2%\" },\n" human carName
	)
	format "converted % cars with % errors\n%\n" numConverted numErrors (errors as string)
)
fn LoadAllCars = (
	format "Loading all cars from: %\n" (C2DataFolder + CarsFolder)
	carFolders = getFiles C1DataFolder+CarsFolder+"*.txt"
	format "Found % cars\n" carFolders.count
	x=0
	for i=1 to carFolders.count do (
		carTxt = carFolders[i]
		carName = getFilenameFile carTxt
		x = x + 1
		LoadC1TXT carTxt &progressValue &progressText imp_mat:true imp_smth:true imp_quad:true imp_hier:true imp_group:true imp_act:true prefix:"" imp_scale69:true
		if x > 4 then 
		(
			i=carFolders.count + 2
		)
	)

)

fn TestPlaneDetection points = (
	foundPlane = GetPlaneFromPoints points
	planeObj = plane pos: foundPlane.Point transform:(MatrixFromNormal foundPlane.normal)
)