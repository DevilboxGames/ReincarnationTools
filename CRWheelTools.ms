

fn SetToComplicatedWheel obj = (
	wheelModifier = emptyModifier()
	wheelModifier.name = "Complicated Wheel"
	addModifier obj wheelModifier

	custAttributes.add wheelModifier ComplicatedWheelAttribute
	obj.modifiers["Complicated Wheel"]
)

fn GetComplicatedWheel obj = (
	if obj.modifiers["Complicated Wheel"] != undefined then obj.modifiers["Complicated Wheel"]
	else SetToComplicatedWheel obj
)

fn NornalizeWheelSize rim tyreWidth: 0.335 tyreRadius: 0.709 = (
	local wheelModifier = if rim != undefined then rim.modifiers["Complicated Wheel"] else undefined
	if wheelModifier == undefined then (

		messageBox "Please select the wheel rim object to resize" title:"No objects selected!"
	)
	else (
		local tyreMesh = if wheelModifier.BaseTyre_Object != undefined then wheelModifier.BaseTyre_Object.node else undefined

		if tyreMesh != undefined or (queryBox "You have no tyre mesh is set on the wheel modifier. The tyre mesh is used to calculate the scaling ratio of the wheel. Do you want to use the rim mesh instad? \nNote: This is not recommended for rims with blades poking out as it will throw off the width.") then (
			local obj = if tyreMesh != undefined then tyreMesh else rim
			--obj.pivot = obj.center
			wheelPos = obj.pos
			wheelRot = quat 1
			flipWheelNode = false

			-- Reset rotation and rotate pivot 180 if left wheel
			if obj.pos.x > 0 then (
				--RotatePivotOnly obj (EulerAngles 0 0 180)
				--obj.scale.x = obj.scale.x * -1
				WorldAlignPivot obj
				obj.rotation = (eulerangles 0 0 180) as quat
				WorldAlignPivot obj
				obj.rotation = (eulerangles 0 0 180) as quat
			)
			wheelRot = obj.rotation
			extents = obj.max - obj.min
			obj.rotation = quat 1
			obj.pos = [0,0,0]
			obj.scale = [tyreWidth / extents.x, tyreRadius / extents.y, tyreRadius / extents.y]
			obj.modifiers["CNT Hierarchy"].BakeScaleIntoMesh = true
			obj.modifiers["CNT Hierarchy"].Filename = "Rim"
	
		)
	)
)

fn LoadWheelLUA obj luaPath = (

	luaFilename = luaPath
	if ((dotnetclass "System.IO.Path").GetFilename luaFilename) == "" then (
		luaFilename = (dotnetclass "System.IO.Path").Combine ((dotnetclass "System.IO.Path").GetDirectoryName luaPath) "CComplicatedWheelParameters.lua"
	)
	
	if ((dotnetclass "System.IO.File").Exists luaFilename) == false then (
		luaFilename = (dotnetclass "System.IO.Path").ChangeExtension luaFilename ".lol"
	)

	if ((dotnetclass "System.IO.File").Exists luaFilename) then (
		local f = stringstream (DecodeLOLFile luaFilename)
		seek f #eof
		endOfFile = filePos f
		seek f 0
		wheelModifier = GetComplicatedWheel obj
		do (
			skipToString f ":"
			local luamethod = readDelimitedString f "("
			local args = trimleft (trimright (readDelimitedString f ")"))
			format "parsing lua method: % \n\twith args: %\n" luamethod args
			case luamethod of (
				"Set_RotateTyre": (
					wheelModifier.RotateTyre = (args as BooleanClass) == true
				)
				"Set_ScrollTyreTiles": (
					wheelModifier.ScrollTyreTiles = args as  integer
				)
				"Set_SkidMarkWidth": (
					wheelModifier.UseSkidmarkWidth = true
					wheelModifier.SkidmarkWidth = args as float
				)
				"Add_PuncturedStage": (
					local splitArgs = filterstring args " ,\"\t"
					append wheelModifier.PunctureStage_Value (splitArgs[1] as integer)
					append wheelModifier.PunctureStage_Mesh splitArgs[2]
					append wheelModifier.PunctureStage_Object (nodeTransformMonitor forwardTransformChangeMsgs:false Node:obj)
				)
				"Set_MaterialName_Tyre": (
					wheelModifier.TyreMaterial = substituteString  args "\"" ""
				)
				"Set_MaterialName_Tyre_Punctured": (
					wheelModifier.TyrePuncturedMaterial =  substituteString  args "\"" ""
				)
				"Set_MaterialName_Tyre_Derimmed": (
					wheelModifier.TyreDerimmedMaterial =  substituteString  args "\"" ""
				)
				"Set_MaterialName_Tyre_Detached": (
					wheelModifier.TyreDetachedMaterial =  substituteString  args "\"" ""
				)
				"Set_Blades": (
					wheelModifier.HasBlades =  (args as BooleanClass) == true
				)
				"Set_Blades_Distinct": (
					wheelModifier.HasDistinctBlades =  (args as BooleanClass) == true
				)
				"Set_Blades_Radius": (
					wheelModifier.BladeRadius = args as float
				)
				"Set_VehicleSimpleWeapon": (
					wheelModifier.HasSimpleWeapon =  true
					wheelModifier.SimpleWeapon = args as integer
				)
				"Set_VehicleWeapon": (
					wheelModifier.HasVehicleWeapon =  true
					local splitArgs = filterstring args " ,\"\t"
					
					wheelModifier.VehicleWeaponScript = args[1]
					wheelModifier.VehicleWeaponVariable = args[2]
					wheelModifier.VehicleWeaponMultiplier = args[3]
					wheelModifier.VehicleWeaponMin = args[4]
					wheelModifier.VehicleWeaponMax = args[5]
				)
				"Set_PedWeapon": (
					wheelModifier.HasPedWeapon =  true
					local splitArgs = filterstring args " ,\"\t"
					
					wheelModifier.PedWeaponScript = args[1]
					wheelModifier.PedWeaponVariable = args[2]
					wheelModifier.PedWeaponMultiplier = args[3]
					wheelModifier.PedWeaponMin = args[4]
					wheelModifier.PedWeaponMax = args[5]
				)
				"Set_AccessoryWeapon": (
					wheelModifier.HasAccessoryWeapon =  true
					local splitArgs = filterstring args " ,\"\t"
					
					wheelModifier.AccessoryWeaponScript = args[1]
					wheelModifier.AccessoryWeaponVariable = args[2]
					wheelModifier.AccessoryWeaponMultiplier = args[3]
					wheelModifier.AccessoryWeaponMin = args[4]
					wheelModifier.AccessoryWeaponMax = args[5]
				)
				"Set_WheelBoundsXFactor": (
					wheelModifier.WheelBoundsXFactor = args as float
				)
				"Set_WheelBoundsYZFactor": (
					wheelModifier.WheelBoundsYZFactor = args as float
				)
				"Set_WheelDamageWeldThreshold": (
					wheelModifier.WheelDamageWeldThreshold = args as float
				)
				"Set_TyreDamageWeldThreshold": (
					wheelModifier.TyreDamageWeldThreshold = args as float
				)
				"Set_TyreDamageWeldMax": (
					wheelModifier.TyreDamageWeldMax = args as float
				)
				"Set_PuncturedHeightPercentage": (
					wheelModifier.PuncturedHeightPercentage = args as float
				)
				"Set_DerimmedHeightPercentage": (
					wheelModifier.DerimmedHeightPercentage = args as float
				)
				"Set_DerimmedTyrePenetrationPercentage": (
					wheelModifier.DerimmedTyrePenetrationPercentage = args as float
				)
				"Set_DerimmedTyreTopPenetrationPercentage": (
					wheelModifier.DerimmedTyreTopPenetrationPercentage = args as float
				)
				"Set_Punctured_RollingResistance": (
					wheelModifier.Punctured_RollingResistance = args as float
				)
				"Set_Punctured_FrictionFactor": (
					wheelModifier.Punctured_FrictionFactor = args as float
				)
				"Set_Derimmed_RollingResistance": (
					wheelModifier.Derimmed_RollingResistance = args as float
				)
				"Set_Derimmed_FrictionFactor": (
					wheelModifier.Derimmed_FrictionFactor = args as float
				)
				"Set_TyreDetached_RollingResistance": (
					wheelModifier.TyreDetached_RollingResistance = args as float
				)
				"Set_TyreDetached_FrictionFactor": (
					wheelModifier.TyreDetached_FrictionFactor = args as float
				)
				"Set_SteeringBroken_RollingResistance": (
					wheelModifier.SteeringBroken_RollingResistance = args as float
				)
				"Set_SteeringBroken_FrictionFactor": (
					wheelModifier.SteeringBroken_FrictionFactor = args as float
				)
				"Set_Damaged_Tyre_Rim_Offset": (
					wheelModifier.Damaged_Tyre_Rim_Offset = args as float
				)
				"Set_Derimmed_MaxSpinSpeedBeforeSlipping": (
					wheelModifier.Derimmed_MaxSpinSpeedBeforeSlipping = args as float
				)
				"Set_Derimmed_SpinSpeedSlipPower": (
					wheelModifier.Derimmed_SpinSpeedSlipPower = args as float
				)
				"Set_Derimmed_SlipAngleFactor": (
					wheelModifier.Derimmed_SlipAngleFactor = args as float
				)
				"Set_Derimmed_MinSpeedForYWobble": (
					wheelModifier.Derimmed_MinSpeedForYWobble = args as float
				)
				"Set_Derimmed_MaxSpeedForYWobble": (
					wheelModifier.Derimmed_MaxSpeedForYWobble = args as float
				)
				"Set_Derimmed_YWobbleMaxAmplitude": (
					wheelModifier.Derimmed_YWobbleMaxAmplitude = args as float
				)
				"Set_Derimmed_YWobbleMaxRate": (
					wheelModifier.Derimmed_YWobbleMaxRate = args as float
				)
				"Set_Derimmed_YWobbleMaxAngle": (
					wheelModifier.Derimmed_YWobbleMaxAngle = args as float
				)
				"Set_Derimmed_MaxZSpeed": (
					wheelModifier.Derimmed_MaxZSpeed = args as float
				)
				"Set_Derimmed_ZShiftFactor": (
					wheelModifier.Derimmed_ZShiftFactor = args as float
				)
				"Set_Derimmed_MaxXSpeed": (
					wheelModifier.Derimmed_MaxXSpeed = args as float
				)
				"Set_Derimmed_MinXShift": (
					wheelModifier.Derimmed_MinXShift = args as float
				)
				"Set_Derimmed_MaxXShift": (
					wheelModifier.Derimmed_MaxXShift = args as float
				)
				"Set_BentAxle_MaxAngle": (
					wheelModifier.BentAxle_MaxAngle = args as float
				)
				"Set_BentAxle_XOffset": (
					wheelModifier.BentAxle_XOffset = args as float
				)
				"Set_BentAxle_DerimmedTyreFactor": (
					wheelModifier.BentAxle_DerimmedTyreFactor = args as float
				)
				"Set_Physics_TyreMass": (
					wheelModifier.Physics_TyreMass = args as float
				)
				"Set_Physics_TyreRestitution": (
					wheelModifier.Physics_TyreRestitution = args as float
				)
				"Set_Physics_TyreDetachUpOffset": (
					wheelModifier.Physics_TyreDetachUpOffset = args as float
				)
				"Set_Physics_TyreDetachUpThrust": (
					wheelModifier.Physics_TyreDetachUpThrust = args as float
				)
				"Set_Physics_TyreDetachOutThrust": (
					wheelModifier.Physics_TyreDetachOutThrust = args as float
				)
				"Set_Physics_RimMass": (
					wheelModifier.Physics_RimMass = args as float
				)
			)
		) while (filePos f) != endOfFile 

		close f
		wheelModifier
	)
	
)

fn SaveWheelLUA obj wheelfolder = (
	luaCode = "";

	wheelModifier = obj.modifiers["Complicated Wheel"]

	if wheelModifier.RotateTyre then luaCode = luaCode + "CComplicatedWheelParameters:Set_RotateTyre( true )\n"
	else luaCode = luaCode + "CComplicatedWheelParameters:Set_RotateTyre( false )\n"

	luaCode = luaCode + "CComplicatedWheelParameters:Set_ScrollTyreTiles( "+(wheelModifier.ScrollTyreTiles as string) +")\n"
	if wheelModifier.UseSkidmarkWidth then 	 luaCode = luaCode + "CComplicatedWheelParameters:Set_SkidMarkWidth( "+(wheelModifier.SkidmarkWidth as string) +" )\n"
	--else luaCode = luaCode + "CComplicatedWheelParameters:Set_SkidMarkWidth( "+(wheelModifier.SkidmarkWidth as string) +" )\n"

	for i = 1 to wheelModifier.PunctureStage_Value.count do (
		stage = wheelModifier.PunctureStage_Value[i]
		cnt = wheelModifier.PunctureStage_Mesh[i]
		luaCode = luaCode + "CComplicatedWheelParameters:Add_PuncturedStage( "+(stage as string) + ", \""+cnt+"\")\n"
	)

	luaCode = luaCode + "CComplicatedWheelParameters:Set_MaterialName_Tyre( \""+wheelModifier.TyreMaterial+"\" );"
	luaCode = luaCode + "CComplicatedWheelParameters:Set_MaterialName_Tyre_Punctured( \""+wheelModifier.TyrePuncturedMaterial+"\" );"
	luaCode = luaCode + "CComplicatedWheelParameters:Set_MaterialName_Tyre_Derimmed( \""+wheelModifier.TyreDerimmedMaterial+"\" );"
	luaCode = luaCode + "CComplicatedWheelParameters:Set_MaterialName_Tyre_Detached( \""+wheelModifier.TyreDetachedMaterial+"\" );"


	if wheelModifier.HasBlades then (
		luaCode = luaCode + "CComplicatedWheelParameters:Set_Blades( true )\n"

		if wheelModifier.HasDistinctBlades then (
			luaCode = luaCode + "CComplicatedWheelParameters:Set_Blades_Distinct( true )\n"	
		)
		luaCode = luaCode + "CComplicatedWheelParameters:Set_Blades_Radius( "+(wheelModifier.BladeRadius as string)+" )\n"
	)

	if wheelModifier.HasSimpleWeapon then (
		luaCode = luaCode + "CComplicatedWheelParameters:Set_VehicleSimpleWeapon( "+(wheelModifier.SimpleWeapon as string)+" )\n"
	)

	if wheelModifier.HasVehicleWeapon then (
		luaCode = luaCode + "CComplicatedWheelParameters:Set_VehicleWeapon( \""+wheelModifier.VehicleWeaponScript+"\", \""+wheelModifier.VehicleWeaponVariable+"\","+(wheelModifier.VehicleWeaponMultiplier as string)+","+(wheelModifier.VehicleWeaponMin as string)+","+(wheelModifier.VehicleWeaponMax as string)+" )\n"
	)

	if wheelModifier.HasPedWeapon then (
		luaCode = luaCode + "CComplicatedWheelParameters:Set_PedWeapon( \""+wheelModifier.PedWeaponScript+"\", \""+wheelModifier.PedWeaponVariable+"\","+(wheelModifier.PedWeaponMultiplier as string)+","+(wheelModifier.PedWeaponMin as string)+","+(wheelModifier.PedWeaponMax as string)+" )\n"
	)

	if wheelModifier.HasAccessoryWeapon then (
		luaCode = luaCode + "CComplicatedWheelParameters:Set_AccessoryWeapon( \""+wheelModifier.AccessoryWeaponScript+"\", \""+wheelModifier.AccessoryWeaponVariable+"\","+(wheelModifier.AccessoryWeaponMultiplier as string)+","+(wheelModifier.AccessoryWeaponMin as string)+","+(wheelModifier.AccessoryWeaponMax as string)+" )\n"
	)

	luaCode = luaCode + "CComplicatedWheelParameters:Set_WheelBoundsXFactor( "+(wheelModifier.WheelBoundsXFactor as string)+" )\n"
	luaCode = luaCode + "CComplicatedWheelParameters:Set_WheelBoundsYZFactor( "+(wheelModifier.WheelBoundsYZFactor as string)+" )\n"
	--luaCode = luaCode + "CComplicatedWheelParameters:Set_WheelDamageMaxRandom( "+(wheelModifier.WheelDamageMaxRandom as string)+" )\n"
	luaCode = luaCode + "CComplicatedWheelParameters:Set_WheelDamageWeldThreshold( "+(wheelModifier.WheelDamageWeldThreshold as string)+" )\n"
	luaCode = luaCode + "CComplicatedWheelParameters:Set_TyreDamageWeldThreshold( "+(wheelModifier.TyreDamageWeldThreshold as string)+" )\n"
	luaCode = luaCode + "CComplicatedWheelParameters:Set_TyreDamageWeldMax( "+(wheelModifier.TyreDamageWeldMax as string)+" )\n"
	luaCode = luaCode + "CComplicatedWheelParameters:Set_PuncturedHeightPercentage( "+(wheelModifier.PuncturedHeightPercentage as string)+" )\n"
	luaCode = luaCode + "CComplicatedWheelParameters:Set_DerimmedHeightPercentage( "+(wheelModifier.DerimmedHeightPercentage as string)+" )\n"
	luaCode = luaCode + "CComplicatedWheelParameters:Set_DerimmedTyrePenetrationPercentage( "+(wheelModifier.DerimmedTyrePenetrationPercentage as string)+" )\n"
	luaCode = luaCode + "CComplicatedWheelParameters:Set_DerimmedTyreTopPenetrationPercentage( "+(wheelModifier.DerimmedTyreTopPenetrationPercentage as string)+" )\n"
	luaCode = luaCode + "CComplicatedWheelParameters:Set_Punctured_RollingResistance( "+(wheelModifier.Punctured_RollingResistance as string)+" )\n"
	luaCode = luaCode + "CComplicatedWheelParameters:Set_Punctured_FrictionFactor( "+(wheelModifier.Punctured_FrictionFactor as string)+" )\n"
	luaCode = luaCode + "CComplicatedWheelParameters:Set_Derimmed_RollingResistance( "+(wheelModifier.Derimmed_RollingResistance as string)+" )\n"
	luaCode = luaCode + "CComplicatedWheelParameters:Set_Derimmed_FrictionFactor( "+(wheelModifier.Derimmed_FrictionFactor as string)+" )\n"
	luaCode = luaCode + "CComplicatedWheelParameters:Set_TyreDetached_RollingResistance( "+(wheelModifier.TyreDetached_RollingResistance as string)+" )\n"
	luaCode = luaCode + "CComplicatedWheelParameters:Set_TyreDetached_FrictionFactor( "+(wheelModifier.TyreDetached_FrictionFactor as string)+" )\n"
	luaCode = luaCode + "CComplicatedWheelParameters:Set_SteeringBroken_RollingResistance( "+(wheelModifier.SteeringBroken_RollingResistance as string)+" )\n"
	luaCode = luaCode + "CComplicatedWheelParameters:Set_SteeringBroken_FrictionFactor( "+(wheelModifier.SteeringBroken_FrictionFactor as string)+" )\n"
	luaCode = luaCode + "CComplicatedWheelParameters:Set_Damaged_Tyre_Rim_Offset( "+(wheelModifier.Damaged_Tyre_Rim_Offset as string)+" )\n"
	--luaCode = luaCode + "CComplicatedWheelParameters:Set_Damage_WheelOnTime( "+(wheelModifier.Damage_WheelOnTime as string)+" )\n"
	luaCode = luaCode + "CComplicatedWheelParameters:Set_Derimmed_MaxSpinSpeedBeforeSlipping( "+(wheelModifier.Derimmed_MaxSpinSpeedBeforeSlipping as string)+" )\n"
	luaCode = luaCode + "CComplicatedWheelParameters:Set_Derimmed_SpinSpeedSlipPower( "+(wheelModifier.Derimmed_SpinSpeedSlipPower as string)+" )\n"
	luaCode = luaCode + "CComplicatedWheelParameters:Set_Derimmed_SlipAngleFactor( "+(wheelModifier.Derimmed_SlipAngleFactor as string)+" )\n"
	luaCode = luaCode + "CComplicatedWheelParameters:Set_Derimmed_MinSpeedForYWobble( "+(wheelModifier.Derimmed_MinSpeedForYWobble as string)+" )\n"
	luaCode = luaCode + "CComplicatedWheelParameters:Set_Derimmed_MaxSpeedForYWobble( "+(wheelModifier.Derimmed_MaxSpeedForYWobble as string)+" )\n"
	luaCode = luaCode + "CComplicatedWheelParameters:Set_Derimmed_YWobbleMaxAmplitude( "+(wheelModifier.Derimmed_YWobbleMaxAmplitude as string)+" )\n"
	luaCode = luaCode + "CComplicatedWheelParameters:Set_Derimmed_YWobbleMaxRate( "+(wheelModifier.Derimmed_YWobbleMaxRate as string)+" )\n"
	luaCode = luaCode + "CComplicatedWheelParameters:Set_Derimmed_YWobbleMaxAngle( "+(wheelModifier.Derimmed_YWobbleMaxAngle as string)+" )\n"
	luaCode = luaCode + "CComplicatedWheelParameters:Set_Derimmed_MaxZSpeed( "+(wheelModifier.Derimmed_MaxZSpeed as string)+" )\n"
	luaCode = luaCode + "CComplicatedWheelParameters:Set_Derimmed_ZShiftFactor( "+(wheelModifier.Derimmed_ZShiftFactor as string)+" )\n"
	luaCode = luaCode + "CComplicatedWheelParameters:Set_Derimmed_MaxXSpeed( "+(wheelModifier.Derimmed_MaxXSpeed as string)+" )\n"
	luaCode = luaCode + "CComplicatedWheelParameters:Set_Derimmed_MinXShift( "+(wheelModifier.Derimmed_MinXShift as string)+" )\n"
	luaCode = luaCode + "CComplicatedWheelParameters:Set_Derimmed_MaxXShift( "+(wheelModifier.Derimmed_MaxXShift as string)+" )\n"
	luaCode = luaCode + "CComplicatedWheelParameters:Set_BentAxle_MaxAngle( "+(wheelModifier.BentAxle_MaxAngle as string)+" )\n"
	luaCode = luaCode + "CComplicatedWheelParameters:Set_BentAxle_XOffset( "+(wheelModifier.BentAxle_XOffset as string)+" )\n"
	luaCode = luaCode + "CComplicatedWheelParameters:Set_BentAxle_DerimmedTyreFactor( "+(wheelModifier.BentAxle_DerimmedTyreFactor as string)+" )\n"
	luaCode = luaCode + "CComplicatedWheelParameters:Set_Physics_TyreMass( "+(wheelModifier.Physics_TyreMass as string)+" )\n"
	luaCode = luaCode + "CComplicatedWheelParameters:Set_Physics_TyreRestitution( "+(wheelModifier.Physics_TyreRestitution as string)+" )\n"
	luaCode = luaCode + "CComplicatedWheelParameters:Set_Physics_TyreDetachUpOffset( "+(wheelModifier.Physics_TyreDetachUpOffset as string)+" )\n"
	luaCode = luaCode + "CComplicatedWheelParameters:Set_Physics_TyreDetachUpThrust( "+(wheelModifier.Physics_TyreDetachUpThrust as string)+" )\n"
	luaCode = luaCode + "CComplicatedWheelParameters:Set_Physics_TyreDetachOutThrust( "+(wheelModifier.Physics_TyreDetachOutThrust as string)+" )\n"
	luaCode = luaCode + "CComplicatedWheelParameters:Set_Physics_RimMass( "+(wheelModifier.Physics_RimMass as string)+" )\n"
	--luaCode = luaCode + "CComplicatedWheelParameters:Set_Wheels_MaxCompressionRate( "+(wheelModifier.Wheels_MaxCompressionRate as string)+" )\n"
	--luaCode = luaCode + "CComplicatedWheelParameters:Set_Wheels_MaxExtensionRate( "+(wheelModifier.Wheels_MaxExtensionRate as string)+" )\n"


	if wheelfolder != undefined then (

		f = openfile (wheelfolder+"CComplicatedWheelParameters.lua") mode:"w"
		format "%" luaCode to:f
		close f
	)
)
fn ExportFullWheel file rootObject = (
	exportTexturesChecked = true
	exportMatsChecked = true
	exportMTLChecked = false
	exportOctreeChecked = false
	global MaterialsToExport
	MaterialsToExport=#()
	mdl_path = getFilenamePath file
	selectedModel = selection[1]
	ExportMDL mdl_path true true exportMats:exportMatsChecked exportTextures:exportTexturesChecked funsizeExport:exportMTLChecked createOctree:exportOctreeChecked
	ExportCNT file selectedModel
	ExportMaterialsAndTextures mdl_path exportMats:exportMatsChecked exportTextures:exportTexturesChecked funsizeExport:exportMTLChecked createOctree:exportOctreeChecked
	SaveWheelLUA rootObject mdl_path

	local wheelMod = obj.modifiers["Complicated Wheel"]

	if wheelMod != undefined and wheelMod.PunctureStage_Object != undefined and wheelModifier.PunctureStage_Object.Count > 0 then (

		for i = 1 to wheelMod.PunctureStage_Object.count do (
			local tyreModel = wheelMod.PunctureStage_Object[t].node
			local TyreName = wheelMod.PunctureStage_Mesh[t]
			select tyreModel
			ExportMDL mdl_path true true exportMats:exportMatsChecked exportTextures:exportTexturesChecked funsizeExport:exportMTLChecked createOctree:exportOctreeChecked
			ExportCNT (mdl_path + TyreName + ".cnt") tyreModel
			ExportMaterialsAndTextures mdl_path exportMats:exportMatsChecked exportTextures:exportTexturesChecked funsizeExport:exportMTLChecked createOctree:exportOctreeChecked
			
		)
	)
)
fn ImportFullWheel cnt_name = (

	global CarmaSettings

	local importTextures = CarmaSettings.ImportSettings.importTextures
	local forcePrep = CarmaSettings.ImportSettings.UsePrepData
	local useTriStrips = CarmaSettings.ImportSettings.UseTriStrips
	local mergeSplits = CarmaSettings.ImportSettings.MergeSplits	

	local tyrePath = (getFileNamePath cnt_name)+"tyre.cnt"
	local rootMesh = ImportCNT cnt_name importTextures:importTextures forcePREP:forcePREP useTriStrips:useTriStrips mergeMDLs:false mergeSplits:mergeSplits  SpawnOctree:SpawnOctree
	local tyreMesh = ImportCNT tyrePath importTextures:importTextures forcePREP:forcePREP useTriStrips:useTriStrips mergeMDLs:false mergeSplits:mergeSplits  SpawnOctree:SpawnOctree
	LoadWheelLUA rootMesh (getFilenamePath cnt_name)

	local wheelModifier = GetComplicatedWheel rootMesh
	wheelModifier.BaseTyre_Object = nodeTransformMonitor node:tyreMesh forwardTransformChangeMsgs:false

	if wheelModifier != undefined then (
		format "Loading % tyre punctured stages\n" wheelModifier.PunctureStage_Mesh.count
		if wheelModifier.PunctureStage_Mesh.count > 0 then (
			for i = 1 to wheelModifier.PunctureStage_Mesh.count do (
				format "Loading punctured tyre %\n" wheelModifier.PunctureStage_Mesh[i]
				tyrePath = (getFileNamePath cnt_name)+wheelModifier.PunctureStage_Mesh[i]+".cnt"

				local punctureMesh = ImportCNT tyrePath importTextures:importTextures forcePREP:forcePREP useTriStrips:useTriStrips mergeMDLs:false mergeSplits:mergeSplits  SpawnOctree:SpawnOctree
				wheelModifier.PunctureStage_Object[i] = nodeTransformMonitor  forwardTransformChangeMsgs:false Node:punctureMesh
			)

		)
	)
)