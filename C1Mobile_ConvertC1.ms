
struct C1PathGroove (
	ACTName,
	Centre,		--Point3
	Period,		--Float
	Delta 		--Float
)
struct C1RockGroove (
	ACTName,
	Period,		--Float
	Centre,		--Point3
	Axis,		--Enum
	MaxAngle 	--Float
)
struct C1ShearGroove (
	ACTName,
	Period,		--Float
	Centre,		--Point4
	Magnitude	--Point3
)
struct C1SpinGroove (
	ACTName,
	Period,		--Float
	Centre,		--Point3
	Axis		--Enum
)


fn LoadC1TXTFile file = (
	local TXTClass = dotNetClass "ToxicRagers.Carmageddon.Formats.Car"
	TXTFile = TXTClass.Load file false
	TXTFile
)

struct C1GrooveAnimDef (
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


fn ConvertAllC1WheelsToMobile carName rootMesh TXT = (
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

fn ConvertC1CarToMobile c1txtfile C1CarName:"ivan" prefix:"C1SP" doexport:true = (
	global OpponentsTXT
	
	local splitPath = filterstring (getfilenamepath c1txtfile) "\\"
	local c1DataFolder = ""
	for i = 1 to splitPath.count - 1 do c1DataFolder = c1DataFolder + splitPath[i] + "\\"

	if OpponentsTXT == undefined then (

		local C1OpponetsTextFile = C1DataFolder + "OPPONENT.TXT"
		OpponentsTXT = (dotnetclass "ToxicRagers.Carmageddon.Formats.OpponentTXT").Load C1OpponetsTextFile
	)

	additionalMatsToConvert = #()

	local c1CarName = getfilenamefile c1txtfile
	TXT = LoadC1TXTFile c1txtfile

	carRoot = LoadC1TXT  c1txtfile &progressValue &progressText imp_onlyMainMeshes:true imp_mat:true imp_smth:true imp_quad:true imp_hier:true imp_group:true imp_act:true prefix:"" imp_scale69:true
	
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

		if groove.AnimationType.toString() == "spin" then (
			if groove.AnimationMode.toString() == "controlled" then (		
				
			)
			else (
				append otherGrooves (GrooveAnimDef PartName:groove.Part AnimType:"Rotate" Controller:"CONSTANT" Period:groove.AnimationPeriod Centre:groove.AnimationCentre Axis:(groove.AnimationAxis.toString()))
			)
		)
		else if groove.AnimationType.toString() == "rock" then (
			if groove.AnimationMode.toString() == "absolute" then (
				
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

 	wheels = ConvertAllC1WheelsToMobile carname carRoot TXT

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
			if groove.AnimType == "Rotate" then (
 				
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
	--if doexport then (
	--	ExportFunsizeCar carroot nolaunch:true
	--)
	--carMaxSaveFolder = MaxSaveFolder + C1CarName + "\\"
	--makedir carMaxSaveFolder
	--saveMaxFile (carMaxSaveFolder+C1CarName+".max") useNewFile:false
	carRoot
)

fn LoadAndConvertC1CarToMobile sender arg = (
	undo "Convert C1 Car To Mobile" on
	(
		carFileName = getopenfilename types:"C1/SP Car Text files(*.txt)|*.txt"
		ConvertC1CarToMobile carFileName
	)
)