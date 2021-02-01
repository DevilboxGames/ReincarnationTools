fn CreateCharacteristicsCDataString obj indentation:1 =
(
	
	whiteSpaceString = "\n"
	for i=1 to indentation do whiteSpaceString += "\t"
		
	charmod = obj.modifiers["Car Characteristics"]
	str = ""
	if charmod.DefenceAgainstCars_Active then str += whiteSpaceString+"CVehicleCharacteristics:Set_DefenceAgainstCars( "+(charmod.DefenceAgainstCars as string)+" )"+whiteSpaceString
	if charmod.DefenceGeneral_Active then str += "CVehicleCharacteristics:Set_DefenceGeneral( "+(charmod.DefenceGeneral as string)+" )"+whiteSpaceString
	if charmod.Offence_Active then str += "CVehicleCharacteristics:Set_Offence( "+(charmod.Offence as string)+" )"+whiteSpaceString
	if charmod.ValueFactor_Active then str += "CVehicleCharacteristics:Set_ValueFactor( "+(charmod.ValueFactor as string)+" )"+whiteSpaceString
	if charmod.WholeBodyDeformationFactor_Active then str += "CVehicleCharacteristics:Set_WholeBodyDeformationFactor( "+(charmod.WholeBodyDeformationFactor as string)+" )"+whiteSpaceString
	if charmod.ExtraFallingDamageThreshold_Active then str += "CVehicleCharacteristics:Set_ExtraFallingDamageThreshold( "+(charmod.ExtraFallingDamageThreshold as string)+" )"+whiteSpaceString
	if charmod.ExtraFallingDamageFactor_Active then str += "CVehicleCharacteristics:Set_ExtraFallingDamageFactor( "+(charmod.ExtraFallingDamageFactor as string)+" )"+whiteSpaceString
	
	if charmod.DownwardCrushingExtraOffence_Active then str += "CVehicleCharacteristics:Set_DownwardCrushingExtraOffence( "+(charmod.DownwardCrushingExtraOffence_0mph as string)+", "+ (charmod.DownwardCrushingExtraOffence_MaxMultSpeed as string)+", "+(charmod.DownwardCrushingExtraOffence_MaxMult as string)+" )"+whiteSpaceString
	if charmod.RandomCrumplingRandomMax_Active then str += "CVehicleCharacteristics:Set_Damage_RandomCrumplingRandomMax( "+(charmod.RandomCrumplingRandomMax as string)+" )"+whiteSpaceString
	if charmod.WBDRandomCrumplingRandomMax_Active then str += "CVehicleCharacteristics:Set_Damage_WBDRandomCrumplingRandomMax( "+(charmod.WBDRandomCrumplingRandomMax as string)+" )"+whiteSpaceString
	if charmod.MaxDeflectionForDamageTexture_Active then str += "CVehicleCharacteristics:Set_Damage_MaxDeflectionForDamageTexture( "+(charmod.MaxDeflectionForDamageTexture as string)+" )"+whiteSpaceString

	if charmod.ImmuneToWheelDamage_Active then str += "CVehicleCharacteristics:Set_ImmuneToWheelDamage(true)"+whiteSpaceString
	if charmod.CannotBeSplit_Active then str += "CVehicleCharacteristics:Set_CannotBeSplit(true)"+whiteSpaceString
	if charmod.AllowCOMZOutsideOfWheelbase_Active then str += "CVehicleCharacteristics:Set_AllowCOMZOutsideOfWheelbaseSet_AllowCOMZOutsideOfWheelbase(true)"+whiteSpaceString

	if charmod.WheelRadius_Active and charmod.WheelRadius_UseFactor then str += "CVehicleCharacteristics:Set_WheelRadiusFactor("+(charmod.WheelRadius as string)+")"+whiteSpaceString
	else if charmod.WheelRadius_Active then str += "CVehicleCharacteristics:Set_WheelRadius("+(charmod.WheelRadius as string)+")"+whiteSpaceString

	if charmod.GridExtraSpace_Active then str += "CVehicleCharacteristics:Set_GridExtraSpace("+(charmod.GridExtraSpace_x as string)+", "+(charmod.GridExtraSpace_y as string)+", "+(charmod.GridExtraSpace_z as string)+")"+whiteSpaceString

	if charmod.TowingPowerMultiplier_Active then str += "CVehicleCharacteristics:Set_TowingPowerMultiplier("+(charmod.TowingPowerMultiplier as string)+")"+whiteSpaceString
	if charmod.TowingTractionMultiplier_Active then str += "CVehicleCharacteristics:Set_TowingTractionMultiplier("+(charmod.TowingTractionMultiplier as string)+")"+whiteSpaceString
	if charmod.TowingSteerSpeedMultiplier_Active then str += "CVehicleCharacteristics:Set_TowingSteerSpeedMultiplier("+(charmod.TowingSteerSpeedMultiplier as string)+")"+whiteSpaceString
	
	
	for i=1 to charmod.PermanentPowerups.count do
	(
		str += "CVehicleCharacteristics:Add_PermanentPowerup( \""+(charmod.PermanentPowerups[i])+"\" )"+whiteSpaceString
	)
	
	if charmod.AerofoilOpenSound_Active then str += "CVehicleCharacteristics:Set_AerofoilOpenSound( "+(charmod.AerofoilOpenSound as string)+" )"+whiteSpaceString
	if charmod.AerofoilCloseSound_Active then str += "CVehicleCharacteristics:Set_AerofoilCloseSound( "+(charmod.AerofoilCloseSound as string)+" )"+whiteSpaceString
	if charmod.AerofoilSoundLump != undefined then str += "CVehicleCharacteristics:Set_AerofoilSoundLump( "+(charmod.AerofoilSoundLump.node.name)+" )"+whiteSpaceString
	if charmod.AirBrakeMinSpeed_Active then str += "CVehicleCharacteristics:Set_AirBrakeMinSpeed( "+(charmod.AirBrakeMinSpeed as string)+" )"+whiteSpaceString
	if charmod.AirBrakeMaxSpeed_Active then str += "CVehicleCharacteristics:Set_AirBrakeMaxSpeed( "+(charmod.AirBrakeMaxSpeed as string)+" )"+whiteSpaceString
	if charmod.AirBrakeMinParametric_Active then str += "CVehicleCharacteristics:Set_AirBrakeMinParametric( "+(charmod.AirBrakeMinParametric as string)+" )"+whiteSpaceString
	if charmod.AirBrakeMovementUpTime_Active then str += "CVehicleCharacteristics:Set_AirBrakeMovementUpTime( "+(charmod.AirBrakeMovementUpTime as string)+" )"+whiteSpaceString
	if charmod.AirBrakeMovementDownTime_Active then str += "CVehicleCharacteristics:Set_AirBrakeMovementDownTime( "+(charmod.AirBrakeMovementDownTime as string)+" )"+whiteSpaceString
	if charmod.AirBrakeDropTime_Active then str += "CVehicleCharacteristics:Set_AirBrakeDropTime( "+(charmod.AirBrakeDropTime as string)+" )"+whiteSpaceString
	if charmod.AerofoilUpSpeed_Active then str += "CVehicleCharacteristics:Set_AerofoilUpSpeed( "+(charmod.AerofoilUpSpeed as string)+" )"+whiteSpaceString
	if charmod.AerofoilDownSpeed_Active then str += "CVehicleCharacteristics:Set_AerofoilDownSpeed( "+(charmod.AerofoilDownSpeed as string)+" )"+whiteSpaceString
	if charmod.AerofoilMovementUpTime_Active then str += "CVehicleCharacteristics:Set_AerofoilMovementUpTime( "+(charmod.AerofoilMovementUpTime as string)+" )"+whiteSpaceString
	if charmod.AerofoilMovementDownTime_Active then str += "CVehicleCharacteristics:Set_AerofoilMovementDownTime( "+(charmod.AerofoilMovementDownTime as string)+" )"+whiteSpaceString
	if charmod.Aerofoil2UpSpeed_Active then str += "CVehicleCharacteristics:Set_Aerofoil2UpSpeed( "+(charmod.Aerofoil2UpSpeed as string)+" )"+whiteSpaceString
	if charmod.Aerofoil2DownSpeed_Active then str += "CVehicleCharacteristics:Set_Aerofoil2DownSpeed( "+(charmod.Aerofoil2DownSpeed as string)+" )"+whiteSpaceString
	if charmod.Aerofoil2MovementUpTime_Active then str += "CVehicleCharacteristics:Set_Aerofoil2MovementUpTime( "+(charmod.Aerofoil2MovementUpTime as string)+" )"+whiteSpaceString
	if charmod.Aerofoil2MovementDownTime_Active then str += "CVehicleCharacteristics:Set_Aerofoil2MovementDownTime( "+(charmod.Aerofoil2MovementDownTime as string)+" )"+whiteSpaceString
	
	if charmod.CaterpillerTracks_Enabled then
	(
		for i=1 to charmod.SegmentDefinition_Name.count do
		(
			str += "CVehicleCharacteristics:Set_CaterpillarTrack_SegmentDefinition("+(i as string)+", "+(charmod.SegmentDefinition_Name[i])+", \""+(charmod.SegmentDefinition_SegmentPitch as string)+"\", "+(charmod.SegmentDefinition_XOffset)+")"+whiteSpaceString
			str += "CVehicleCharacteristics:Set_CaterpillarTrack_SagHeights("+(i as string)+", "+(charmod.SagHeight_AmbientLowestPoint as string)+", "+(charmod.SagHeight_LowestAllowablePoint as string)+")"+whiteSpaceString
			str += "CVehicleCharacteristics:Set_CaterpillarTrack_DamageMode("+(i as string)+", "+(charmod.DamageMode_NumParts as string)+", "+(charmod.DamageMode_Restitution as string)+", "+(charmod.DamageMode_MassPerSegment as string)+")"+whiteSpaceString

			str += "CVehicleCharacteristics:Set_CaterpillarTrack_DamageWobble("+(i as string)+", "+(charmod.DamageWobble_SpeedForMaxWobble as string)+", "+(charmod.DamageWobble_FreqOfMaxWobble as string)+", "+(charmod.DamageWobble_AmpOfMaxWobble as string)+", "+(charmod.DamageWobble_RandomVariance as string)+")"+whiteSpaceString
			str += "CVehicleCharacteristics:Set_Damage_CaterpillarTrack_SoundClunkVolume("+(i as string)+", "+(charmod.Sound_ClunkVolume_VolumeAtZero as string)+", "+(charmod.Sound_ClunkVolume_SpeedAtSlopeChange as string)+", "+(charmod.Sound_ClunkVolume_VolumeAtSlopeChange as string)+", "+(charmod.Sound_ClunkVolume_SpeedAtMaxVolume as string)+", "+(charmod.Sound_ClunkVolume_MaxVolume as string)+")"+whiteSpaceString
			str += "CVehicleCharacteristics:Set_Damage_CaterpillarTrack_SoundHighSpeedClunkVolume("+(i as string)+", "+(charmod.Sound_ClunkVolume_VolumeAtZero as string)+", "+(charmod.Sound_ClunkVolume_SpeedAtSlopeChange as string)+", "+(charmod.Sound_ClunkVolume_VolumeAtSlopeChange as string)+", "+(charmod.Sound_ClunkVolume_SpeedAtMaxVolume as string)+", "+(charmod.Sound_ClunkVolume_MaxVolume as string)+")"+whiteSpaceString
		)
		if charmod.Damaged_FrictionFactor_Active then str += "CVehicleCharacteristics:Set_Damage_CaterpillarTrack_Damaged_FrictionFactor("+(charmod.Damaged_FrictionFactor as string)+")"+whiteSpaceString
		if charmod.Damaged_RollingResistance_Active then str += "CVehicleCharacteristics:Set_Damage_CaterpillarTrack_Damaged_RollingResistance("+(charmod.Damaged_RollingResistance as string)+")"+whiteSpaceString

		if charmod.DamagedAll_FrictionFactor_Active then str += "CVehicleCharacteristics:Set_Damage_CaterpillarTrack_AllDamaged_FrictionFactor("+(charmod.DamagedAll_FrictionFactor as string)+")"+whiteSpaceString
		if charmod.DamagedAll_RollingResistance_Active then str += "CVehicleCharacteristics:Set_Damage_CaterpillarTrack_AllDamaged_RollingResistance("+(charmod.DamagedAll_RollingResistance as string)+")"+whiteSpaceString

		if Sound_WhineVolume_Active then str += "CVehicleCharacteristics:Set_Damage_CaterpillarTrack_SoundWhineVolume("+(i as string)+", "+(charmod.Sound_WhineVolume_VolumeAtZero as string)+", "+(charmod.Sound_WhineVolume_SpeedAtSlopeChange as string)+", "+(charmod.Sound_WhineVolume_VolumeAtSlopeChange as string)+", "+(charmod.Sound_WhineVolume_SpeedAtMaxVolume as string)+", "+(charmod.Sound_WhineVolume_MaxVolume as string)+")"+whiteSpaceString
		if Sound_WhinePitch_Active then str += "CVehicleCharacteristics:Set_Damage_CaterpillarTrack_SoundWhinePitch("+(i as string)+", "+(charmod.Sound_WhinePitch_PitchAtZero as string)+", "+(charmod.Sound_WhinePitch_MaxSpeed as string)+", "+(charmod.Sound_WhinePitch_PitchAtMaxSpeed as string)+")"+whiteSpaceString
	)
	return str
)
fn CreatePartCDataSection obj isRootNode:false indentation:1 =
(
	
	whiteSpaceString = "\n"
	for i=1 to indentation do whiteSpaceString += "\t"
		
	partMod = obj.modifiers["Car Structure Part"]
	str = whiteSpaceString
	
	if partMod.RenderLevel_Set then str += "CDamageParameters:Set_RenderLevel( "+ (partMod.RenderLevel as string) +")"+whiteSpaceString
	for i=1 to partMod.LumpRenderLevel_Node.count do
	(
		str += "CDamageParameters:Add_LumpRenderLevel( \""+partMod.LumpRenderLevel_Node[i].node.name+"\", "+ (partMod.LumpRenderLevel_Value[i] as string) +")"+whiteSpaceString
	)
	
	if partMod.Crushability_Set and obj.modifiers["CNT Hierarchy"].NodeType == "MODL" then str += "CDamageParameters:Set_Crushability( "+ (partMod.Crushability as string)+")"+whiteSpaceString
	if partMod.Stiffness_Set then str += "CDamageParameters:Set_Stiffness( "+ (partMod.Stiffness as string) +")"+whiteSpaceString
	if partMod.Resiliance_Set then str += "CDamageParameters:Set_Resiliance( "+ (partMod.Resiliance as string) +")"+whiteSpaceString
	if partMod.Mass_Set then str += "CDamageParameters:Set_Mass( "+ (partMod.Mass as string) +")"+whiteSpaceString
	if partMod.Restitution_Set then str += "CDamageParameters:Set_Restitution( "+ (partMod.Restitution as string) +")"+whiteSpaceString
	if partMod.AlwaysJointed then str += "CDamageParameters:Set_AlwaysJointed( true )"+whiteSpaceString
	if partMod.ShapeType != "" then str += "CDamageParameters:Set_ShapeType( \""+ partMod.ShapeType +"\")"+whiteSpaceString
	if partMod.CollisionBoundsMultiplier_Set then str += "CDamageParameters:Set_CollisionBoundsMultiplier( "+ (partMod.CollisionBoundsMultiplier_X as string)+", "+ (partMod.CollisionBoundsMultiplier_Z as string)+","+ (partMod.CollisionBoundsMultiplier_Y as string)+")"+whiteSpaceString
	
	for i=1 to partMod.PhysicsProperties.count do
	(
		str += "CDamageParameters:Add_PhysicsProperty( \""+partMod.PhysicsProperties[i]+"\" )"+whiteSpaceString
	)
	--if isRootNode then
	
	for i=1 to partMod.DriverBoxVertexColour_R.count do
	(
		str += "CDamageParameters:Add_DriverBoxVertexColour( "+ (partMod.DriverBoxVertexColour_R[i] as string) +","+ (partMod.DriverBoxVertexColour_G[i] as string) +","+ (partMod.DriverBoxVertexColour_B[i] as string) +","+ (partMod.DriverBoxVertexColour_A[i] as string) +")"+whiteSpaceString
	)
	for i=1 to partMod.FunctionalLightType.count do
	(
		str += "CDamageParameters:Add_FunctionalLight( \""+partMod.FunctionalLightType[i]+"\", \""+partMod.FunctionalLightObject[i].node.name+"\" )"+whiteSpaceString
	)
	
	if partMod.DriverEjectionSmash then str += "CDamageParameters:Set_DriverEjectionSmash( true )"+whiteSpaceString
	for i=1 to partMod.CrushDamageMaterialLevel.count do
	(
		str += "CDamageParameters:Add_CrushDamageMaterial( "+(partMod.CrushDamageMaterialLevel[i] as string)+", \""+partMod.CrushDamageMaterialOriginalMaterial[i]+"\", \""+partMod.CrushDamageMaterialTargetMaterial[i]+"\" )"+whiteSpaceString
	)
	for i=1 to partMod.CrushDamageEmitterLevel.count do
	(
		emitterPos = ConvertToCRSpace (pretranslate (inverse obj.transform) partMod.CrushDamageEmitterPosition[i].node.position).translation
		str += "CDamageParameters:Add_CrushDamageEmitter( "+(partMod.CrushDamageEmitterLevel[i] as string)+", \""+(partMod.CrushDamageEmitterName[i] as string)+"\", "+(emitterPos.x as string)+", "+(emitterPos.y as string)+", "+(emitterPos.z as string)+" )"+whiteSpaceString
	)
	
	for i=1 to partMod.DetachPartEmitterName.count do
	(
		emitterPos = ConvertToCRSpace (pretranslate (inverse obj.transform) partMod.DetachPartEmitterPosition[i].node.position).translation
		str += "CDamageParameters:Add_DetachPartEmitter( \""+partMod.DetachPartEmitterName[i]+"\", "+(emitterPos.x as string)+", "+(emitterPos.y as string)+", "+(emitterPos.z as string)+", "+(partMod.DetachPartEmitterFactor[i] as string)+" )"+whiteSpaceString
	)
	
	for i=1 to partMod.DetachParentEmitterName.count do
	(
		emitterPos = ConvertToCRSpace (pretranslate (inverse obj.transform) partMod.DetachParentEmitterPosition[i].node.position).translation
		str += "CDamageParameters:Add_DetachParentEmitter( \""+partMod.DetachParentEmitterName[i]+"\", "+(emitterPos.x as string)+", "+(emitterPos.y as string)+", "+(emitterPos.z as string)+", "+(partMod.DetachParentEmitterFactor[i] as string)+" )"+whiteSpaceString
	)
	
	if partMod.VehicleSimpleWeapon_Set then str += "CDamageParameters:Add_VehicleSimpleWeapon( "+(partMod.VehicleSimpleWeapon as string)+" )"+whiteSpaceString
		
	for i=1 to partMod.WeaponType.count do
	(
		str+= "CDamageParameters:Add_"+partMod.WeaponType[i]+"Weapon( \""+partMod.WeaponName[i]+"\", \""+partMod.WeaponDmgType[i]+"\", "+(partMod.WeaponVector[i].x as string)+", "+(partMod.WeaponVector[i].y as string)+", "+(partMod.WeaponVector[i].z as string)+" )"+whiteSpaceString
	)
	if partMod.SoundConfigFile != "" then str += "CDamageParameters:Set_SoundConfigFile( \""+partMod.SoundConfigFile+"\" )"+whiteSpaceString
	if partMod.CrushDamageSoundSubCat != "" then str += "CDamageParameters:Set_CrushDamageSoundSubCat( \""+ partMod.CrushDamageSoundSubCat +"\")"+whiteSpaceString
	
	for i=1 to obj.modifiers.count do
	(
		objMod = obj.modifiers[i]
		if objMod.name == "Part Animation" then
		(
			oldScale = obj.scale
			obj.scale = [1,1,1]
			--format "Starting animation part - "
			prefix = ""
			namedArgs = ""
			if objMod.UseNamedObject then
			(
				prefix = "Add_PostIK_Named"
				namedArgs = ", \""+objMod.NamedObject.node.name+"\""
			)
			else if objMod.PreIK then
			(
				prefix = "Set_PreIK_"
			)
			else
			(
				prefix = "Set_PostIK_"
			)
			type = objMod.AnimationType
			axis = case objMod.Axis of
			(
				1: "X"
				2: "Y"
				3: "Z"
			)
			if type == "Vibrate" then
			(
				type = "RotateVibrate"
			)
			else
			(
				axis = "In"+axis
			)
			--format "%\n" (prefix+type+axis)
			args = ""
			if type == "Rotate" or type == "Slide" then
			(
				args = "\""+objMod.ControlledBy+"\", "+(formattedPrint objMod.Amount  format:"f") 
			)
			else if type == "Oscillate" then
			(
				args = "\""+objMod.ControlledBy+"\", "+(formattedPrint objMod.Amount  format:"f") +", "+(formattedPrint objMod.Amount2  format:"f") 
			)
			else if type == "Rock" then
			(
				args = "\""+objMod.ControlledBy+"\", "+(formattedPrint objMod.Amount  format:"f") +", "+(formattedPrint objMod.Amount2  format:"f") 
				center = ConvertToCRSpace (pretranslate (inverse obj.transform) objMod.CentreOfRotation.node.position).translation
				args += ", "+(formattedPrint center.x  format:"f")+", "+(formattedPrint center.y  format:"f")+", "+(formattedPrint center.z  format:"f")
			)
			else if type == "RotateVibrate" then
			(
				args = "\""+objMod.ControlledBy+"\", "+(formattedPrint objMod.MinFreq  format:"f") +", "+(formattedPrint objMod.MaxFreq  format:"f") +", "+(formattedPrint objMod.RandomFreq  format:"f")+", "+(formattedPrint objMod.MinAmp format:"f") +", "+(formattedPrint objMod.MaxAmp format:"f") +", "+(formattedPrint objMod.RandomAmp format:"f")
				center = ConvertToCRSpace (pretranslate (inverse obj.transform) objMod.CentreOfRotation.node.position).translation
				args += ", "+(formattedPrint center.x  format:"f")+", "+(formattedPrint center.y  format:"f")+", "+(formattedPrint center.z  format:"f")

			)
			--format "Finished part animation\n"
			obj.scale=oldScale
			str += "CDamageParameters:"+prefix+type+axis+"( "+args+namedArgs+" )"+whiteSpaceString
		)
		if objMod.name == "Point To Point Animation" then
		(
			--format "Starting Point To Point -"
			prefix = "CDamageParameters:Set_PostIK_"
			
			if objMod.PreIK and objMod.TypeOfPointToPoint_Selection != 4 then prefix = "CDamageParameters:Set_PreIK_"
				
			type = case objMod.TypeOfPointToPoint_Selection of
			(
				1: "SnapPointToPointOnOtherPart"
				2: "RotatePointToLineOnOtherPart"
				3: "RotatePointToPointOnOtherPart"
				4: "RotatePointToPointOnOtherPartWithScaling"
			)
			--format "%\n" (prefix+type)
			oldScale = obj.scale
			obj.scale = [1,1,1]
			pointOnThisObject = ConvertToCRSpace (pretranslate (inverse obj.transform) objMod.PointOnThisObject.node.position).translation
			
			--format "a\n"
			otherPart = objMod.OtherObject.node
			opOldScale = otherPart.scale
			otherPart.scale = [1,1,1]
			--format "b\n"
			pointOnOtherObject = ConvertToCRSpace (pretranslate (inverse otherPart.transform) objMod.PointOnOtherObject.node.position).translation
			--format "c\n"
			args = (formattedPrint pointOnThisObject.x format:"f")+", "+(formattedPrint pointOnThisObject.y format:"f")+", "+(formattedPrint pointOnThisObject.z format:"f")+", \""+otherPart.name+"\", "+(formattedPrint pointOnOtherObject.x format:"f")+", "+(formattedPrint pointOnOtherObject.y format:"f")+", "+(formattedPrint pointOnOtherObject.z format:"f")
			--format "d\n"
			if objMod.TypeOfPointToPoint_Selection == 2 then
			(
				lineDirection = normalize ((ConvertToCRSpace (pretranslate (inverse otherPart.transform) objMod.LineTargetObject.node.position).translation) - pointOnOtherObject)
			--format "e\n"
				args += ", "+(formattedPrint lineDirection.x format:"f")+", "+(formattedPrint lineDirection.y format:"f")+", "+(formattedPrint lineDirection.z format:"f")
			--format "f\n"
			)
			otherPart.scale = opOldScale
			obj.scale=oldScale
			str += prefix + type + "( " + args + " )"+whiteSpaceString
			--format "Finished point to point\n"
		)
		if objMod.name == "Wishbone Trailing Arm" then
		(
			format "Wishbone Trailing Arm\n"
			oldScale = obj.scale
			obj.scale = [1,1,1]
			mountPivot = ConvertToCRSpace (pretranslate (inverse obj.transform) objMod.MountPivot.node.position).translation
			axlePivot = ConvertToCRSpace (pretranslate (inverse obj.transform) objMod.AxlePivot.node.position).translation
			obj.scale=oldScale
			str += "CDamageParameters:Set_PreIK_LiveAxle_TrailingArm( "+(formattedPrint objMod.WheelIndex format:"i")+", "+(formattedPrint mountPivot.x format:"f") +", "+(formattedPrint mountPivot.y format:"f") +", "+(formattedPrint mountPivot.z format:"f") +", "+(formattedPrint axlePivot.x  format:"f") +", "+(formattedPrint axlePivot.y  format:"f") +", "+(formattedPrint axlePivot.z  format:"f") +" )"+whiteSpaceString
		)
		if objMod.name == "Wishbone Hub" then
		(
			format "Wishbone Hub\n"
			oldScale = obj.scale
			obj.scale = [1,1,1]
			funcType = case objMod.HubType of
			(
				"Wishbone Hub": "CDamageParameters:Set_PreIK_WishboneHub"
				"Strut Hub": "CDamageParameters:Set_PreIK_StrutHub"
				"Live Axle Hub": "CDamageParameters:Set_PreIK_LiveAxle_Hub"
			)
			args = objMod.wheelIndex as string
			
			if objMod.HubType != "Live Axle Hub" then
			(
				format "Not a live axle hub: %\n" objMod.HubType
				upperPivotPoint = ConvertToCRSpace (pretranslate (inverse obj.transform) objMod.UpperPivotPoint.node.position).translation
				lowerPivotPoint = ConvertToCRSpace (pretranslate (inverse obj.transform) objMod.LowerPivotPoint.node.position).translation
				args += ", "+(formattedPrint objMod.PivotAxis  format:"i")+", "+(formattedPrint upperPivotPoint.x format:"f")+", "+(formattedPrint upperPivotPoint.y format:"f")+", "+(formattedPrint upperPivotPoint.z  format:"f")+", "+(formattedPrint lowerPivotPoint.x format:"f")+", "+(formattedPrint lowerPivotPoint.y format:"f")+", "+(formattedPrint lowerPivotPoint.z  format:"f")
			)
			
			wheelPoint = ConvertToCRSpace (pretranslate (inverse obj.transform) objMod.WheelPoint.node.position).translation
			args += ", "+(formattedPrint wheelPoint.x format:"f")+", "+(formattedPrint wheelPoint.y  format:"f")+", "+(formattedPrint wheelPoint.z  format:"f")
			
			obj.scale=oldScale
			str += funcType +"( "+args+" )"+whiteSpaceString
		)
		if objMod.name == "Wishbone Mount" then
		(
			format "Whisbone Mount\n"
			oldScale = obj.scale
			obj.scale = [1,1,1]
			mountType = case objMod.MountType of
			(
				"Wishbone Lower": "CDamageParameters:Set_PreIK_WishboneMountLower"
				"Wishbone Upper": "CDamageParameters:Set_PreIK_WishboneMountUpper"
				"Strut Lower": "CDamageParameters:Set_PreIK_StrutWishboneMount"
				"Strut Upper": "CDamageParameters:Set_PreIK_StrutUpperMount"
				"Trailing Arm":  "CDamageParameters:Set_PreIK_LiveAxle_TrailingArmMount"
			)
			mountPoint = ConvertToCRSpace (pretranslate (inverse obj.transform) objMod.mountpoint.node.position).translation
			mountPointString = (formattedPrint mountPoint.x format:"f")+", "+(formattedPrint mountPoint.y  format:"f")+", "+(formattedPrint mountPoint.z format:"f")
			if objMod.MountType == "Trailing Arm" then
			(
				str += mountType+"( "+(formattedPrint objMod.MountWheel format:"i")+", "+mountPointString+" )"+whiteSpaceString
			)
			else
			(
				wheelString = case objMod.MountWheel of
				(
					0: "FL"
					1: "FR"
					2: "RL"
					3: "RR"
				)
				str += mountType+wheelString+"( "+(formattedPrint objMod.MountAxis format:"i")+", "+mountPointString+" )"+whiteSpaceString
			)
			obj.scale=oldScale
		)
		if objMod.name == "Wishbone Axle" then
		(
			format "Wishbone Axle \n"
			oldScale = obj.scale
			obj.scale = [1,1,1]
			axleType = case objMod.WishboneAxleType of
			(
				"Wishbone Upper": "CDamageParameters:Set_PreIK_WishboneUpper"
				"Wishbone Lower": "CDamageParameters:Set_PreIK_WishboneLower"
				"Strut Wishbone": "CDamageParameters:Set_PreIK_StrutWishbone"
				"Live Axle": "CDamageParameters:Set_PreIK_LiveAxle"
			)
			inboardPivotPoint = ConvertToCRSpace (pretranslate (inverse obj.transform) objMod.InboardPivotPoint.node.position).translation
			inboardPivotString = (formattedPrint inboardPivotPoint.x  format:"f")+", "+ (formattedPrint inboardPivotPoint.y format:"f")+", "+ (formattedPrint inboardPivotPoint.z format:"f")
			if objMod.WishboneAxleType == "Live Axle" then
			(
				str+= axleType+"( "+((objMod.WheelNumber as integer) as string)+", "+inboardPivotString+" )"+whiteSpaceString
			)
			else
			(
				outboardPivotPoint = ConvertToCRSpace (pretranslate (inverse obj.transform) objMod.OutboardPivotPoint.node.position).translation
				outboardPivotString = (formattedPrint outboardPivotPoint.x format:"f")+", "+ (formattedPrint outboardPivotPoint.y format:"f")+", "+ (formattedPrint outboardPivotPoint.z format:"f")
				str += axleType+"( "+(objMod.WheelNumber as string)+", "+(objMod.PivotAxis as string)+", "+inboardPivotString+", "+outboardPivotString+" )"+whiteSpaceString
			)
			obj.scale=oldScale
			format "End Wishbone Axle\n"
		)
	)
	
	return str
)
fn WriteJointTag xmlDoc obj jointObj indentation:1 = 
(
	--format "Joint Transform: %\n" jointObj.transform
	whiteSpaceString = "\n"
	for i=1 to indentation do whiteSpaceString += "\t"
		
	xmlDoc.WriteWhitespace whiteSpaceString
	xmlDoc.WriteStartElement "JOINT"
	xmlDoc.WriteWhitespace whiteSpaceString
	
	--format "Joint Tag for %\n" jointObj.name
	str=whiteSpaceString
	--jointNode = xmlDoc.createelement "JOINT"
	if jointObj.JointType_Hinge then str += "CWeldJointParameters:Set_Hinge( true )"+whiteSpaceString
	else if jointObj.JointType_Ball then str += "CWeldJointParameters:Set_BallJoint( true )"+whiteSpaceString
	else if jointObj.JointType_UJ then str += "CWeldJointParameters:Set_UJ( true )"+whiteSpaceString
	else if jointObj.JointType_Slide then str += "CWeldJointParameters:Set_Slide( true )"+whiteSpaceString

	--format "Setting Joint Weakness\n"
	
	str+= "CWeldJointParameters:Set_Weakness( "+(jointObj.Weakness as string)+")"+whiteSpaceString
	--Format "Weakness is set\n"
	
	for i=1 to jointObj.FlapSprings.count do
	(
		str += "CWeldJointParameters:Add_FlapSpring( "+(jointObj.FlapSprings[i].x as string)+", "+(jointObj.FlapSprings[i].y as string)+" )"+whiteSpaceString
	)
	
	if jointObj.UseLimit then
	(
		str += "CWeldJointParameters:Set_MinLimit( "+(jointObj.MinLimit as string)+" )"+whiteSpaceString
		str += "CWeldJointParameters:Set_MaxLimit( "+(jointObj.MaxLimit as string)+" )"+whiteSpaceString
	)
	if jointObj.UseLimit2 then
	(
		str += "CWeldJointParameters:Set_MinLimit2( "+(jointObj.MinLimit2 as string)+" )"+whiteSpaceString
		str += "CWeldJointParameters:Set_MaxLimit2( "+(jointObj.MaxLimit2 as string)+" )"+whiteSpaceString
	)
	if jointObj.UseTwist then
	(
		str += "CWeldJointParameters:Set_MinTwistLimit( "+(jointObj.MinTwist as string)+" )"+whiteSpaceString
		str += "CWeldJointParameters:Set_MaxTwistLimit( "+(jointObj.MaxTwist as string)+" )"+whiteSpaceString
	)
	
	if jointObj.UseLocation then
	(
		jointPos = ConvertToCRSpace jointObj.position
		str += "CWeldJointParameters:Set_JointLocation( "+(jointPos.x as string)+","+(jointPos.y as string)+","+(jointPos.z as string)+" )"+whiteSpaceString
	)
	--format "Before convert\n"
		jointPos = ConvertToCRSpace jointObj.transform.row1
		str += "CWeldJointParameters:Set_JointAxis( "+(jointPos.x as string)+","+(jointPos.y as string)+","+(jointPos.z as string)+" )"+whiteSpaceString
	--format "After convert\n"
	if jointObj.UseNormal then
	(
		jointPos = ConvertToCRSpace jointObj.transform.row3
		str += "CWeldJointParameters:Set_JointNormal( "+(jointPos.x as string)+","+(jointPos.y as string)+","+(jointPos.z as string)+" )"+whiteSpaceString
	)
	
	xmlDoc.WriteCData str
	xmlDoc.WriteWhitespace(whiteSpaceString)
	xmlDoc.WriteEndElement()


	--format "Post Writing - Joint Transform: %\n" jointObj.transform
	--xmlDoc.WriteWhitespace(whiteSpaceString)
	--cData = xmlDoc.createcdatasection (str)
	--jointNode.appendchild cdata
	--return jointNode
)
fn WriteWeldTag xmlDoc obj weldMod indentation:1 =
(
	--format "Starting Weld Tag\n"
	whiteSpaceString = "\n"
	for i=1 to indentation do whiteSpaceString += "\t"
		
	xmlDoc.WriteWhitespace whiteSpaceString
	--format "a\n"
	xmlDoc.WriteStartElement("WELD")
	--format "b\n"
	if weldMod.WeldName !="" then
	(
		xmlDoc.WriteAttributeString "name" weldMod.WeldName
	)
	if weldMod.WeldPartner != undefined then
	(
		xmlDoc.WriteAttributeString "partner" weldMod.WeldPartner.node.name
	)
	
	str = whiteSpaceString
	if obj.modifiers["CNT Hierarchy"].NodeType == "MODL" and weldMod.WeldVertexPosition.count < 1 then str += "CWeldParameters:Set_VertexColour( "+(weldMod.VertexColourR as string)+", "+(weldMod.VertexColourG as string)+", "+(weldMod.VertexColourB as string)+", "+(weldMod.VertexColourA as string)+" )"+whiteSpaceString
	if weldMod.Weakness_Set then str += "CWeldParameters:Set_Weakness( "+(weldMod.Weakness as string)+" )"+whiteSpaceString
	if weldMod.AbsoluteLimit_Set then str += "CWeldParameters:Set_AbsoluteLimit( "+(weldMod.AbsoluteLimit as string)+" )"+whiteSpaceString
	if weldMod.ChanceOfFailure_Set then str += "CWeldParameters:Set_ChanceOfFailure( "+(weldMod.ChanceOfFailure as string)+" )"+whiteSpaceString
	if weldMod.WeldBreak_Set then str += "CWeldParameters:Set_Break( "+(weldMod.WeldBreak as string)+" )"+whiteSpaceString
	if weldMod.GangedBreak != "" then str += "CWeldParameters:Add_GangedBreak( \""+(weldMod.GangedBreak as string)+"\" )"+whiteSpaceString
	for i=1 to weldMod.WeldVertexPosition.count do
	(
		vertPos = ConvertToCRSpace weldMod.WeldVertexPosition[i]
		if weldMod.WeldVertexType[i] == "Part" then
		(
			
			str+="CWeldParameters:Add_PartSpaceVertex( "+(vertPos.x as string)+", "+(vertPos.y as string)+", "+(vertPos.z as string)+" )"+whiteSpaceString
		)
		else
		(
			
			str+="CWeldParameters:Add_CarSpaceVertex( "+(vertPos.x as string)+", "+(vertPos.y as string)+", "+(vertPos.z as string)+" )"+whiteSpaceString
			
		)
	)
	xmlDoc.WriteWhitespace whiteSpaceString
	xmlDoc.WriteCData str
	xmlDoc.WriteWhitespace whiteSpaceString
	
	for i=1 to weldMod.Joints.count do
	(
		WriteJointTag xmlDoc obj weldMod.joints[i] indentation:(indentation+1)
	)
	xmlDoc.WriteEndElement()
	
	/*
	weldNode = xmlDoc.createelement "WELD"
	
	if weldMod.WeldName != "" then
	(
		nameAttr = xmlDoc.CreateAttribute("name")
		nameAttr.value = weldMod.WeldName
		weldNode.SetAttributeNode nameAttr
	)
	if weldMod.WeldPartner != undefined then
	(
		partnerAttr = xmlDoc.CreateAttribute "partner"
		partnerAttr.value = weldMod.WeldPartner.node.name
		weldNode.SetAttributeNode partnerAttr
	)
	
	
	str = "CWeldParameters:Set_VertexColour( "+(weldMod.VertexColour.r as string)+", "+(weldMod.VertexColour.g as string)+", "+(weldMod.VertexColour.b as string)+", "+(weldMod.VertexColour.a as string)+" )\n"
	if weldMod.Weakness_Set then str += "CWeldParameters:Set_Weakness( "+(weldMod.Weakness as string)+" )\n"
	if weldMod.AbsoluteLimit_Set then str += "CWeldParameters:Set_AbsoluteLimit( "+(weldMod.AbsoluteLimit as string)+" )\n"
	if weldMod.ChanceOfFailure_Set then str += "CWeldParameters:Set_ChanceOfFailure( "+(weldMod.ChanceOfFailure as string)+" )\n"
	if weldMod.WeldBreak_Set then str += "CWeldParameters:Break( "+(weldMod.WeldBreak as string)+" )\n"
	if weldMod.GangedBreak != "" then str += "CWeldParameters:Set_GangedBreak( \""+(weldMod.GangedBreak as string)+"\" )\n"
	
	cData = xmlDoc.createcdatasection (str)
	weldNode.appendchild cdata
	for i=1 to weldMod.Joints.count do
	(
		weldNode.appendchild (WriteJointTag xmlDoc obj weldMod.joints[i])
	)
	
	return weldNode
	*/
)

fn RecurseStructure xmlDoc obj isRootNode:false indentation:1 =
(
	whiteSpaceString = "\n"
	for i=1 to indentation do whiteSpaceString += "\t"
		
	xmlDoc.WriteWhitespace(whiteSpaceString)
	if isRootNode then xmlDoc.WriteStartElement "ROOT"
	else xmlDoc.WriteStartElement "PART"

	xmlDoc.WriteAttributeString "name" obj.name ;
	xmlDoc.WriteWhitespace(whiteSpaceString+"\t")
	
	partCData = (CreatePartCDataSection obj isRootNode:isRootNode indentation:(indentation+2))
	if (trimLeft partCData != "") then xmlDoc.WriteCData partCData
	--xmlDoc.WriteWhiteSpace(whiteSpaceString +"\t")
	
	if isRootNode == false then for i=1 to obj.modifiers.count do
	(
		if obj.modifiers[i].name == "Car Weld" then
		(
			WriteWeldTag xmlDoc obj obj.modifiers[i] indentation:(indentation+1)
		)
	)
	
	for i=1 to obj.children.count do
	(
		if (IsObjectAStructurePart obj.children[i]) then RecurseStructure xmlDoc obj.children[i] indentation:(indentation+1)
	)
	
	
	xmlDoc.WriteWhitespace(whiteSpaceString)
	xmlDoc.WriteEndElement()
	--xmlDoc.WriteWhitespace("\n")
		/*
	newNode = undefined
	if isRootNode then newNode = xmlDoc.createelement "ROOT"
	else newNode = xmlDoc.createelement "PART"
	nameAttr = xmlDoc.CreateAttribute("name")
	nameAttr.value = obj.name
	newNode.SetAttributeNode nameAttr
	cData = xmlDoc.createcdatasection (CreatePartCDataSection obj isRootNode:isRootNode)
	newNode.appendchild cdata
	
	if isRootNode == false then for i=1 to obj.modifiers.count do
	(
		if obj.modifiers[i].name == "Car Weld" then
		(
			newNode.appendchild (WriteWeldTag xmlDoc obj obj.modifiers[i])
			
		)
	)
	
	for i=1 to obj.children.count do
	(
		if (IsObjectAStructurePart obj.children[i]) then newNode.appendchild (RecurseStructure xmlDoc obj.children[i])
	)
	
	return newNode
	*/
)
fn ExportStructureXML xmlFilename obj =
(
	
	dotnet.loadAssembly "system.xml"
	try
	(
		xmlsettings = (dotnetobject "system.xml.xmlwritersettings")
		xmlsettings.indent = true
		xmlsettings.IndentChars = "\t"
		--xmlsettings.NewLineHandling = (dotnetclass "system.xml.NewLineHandling").Entitize
		--xmlwriter = (dotnetclass "system.xml.xmlwriter").create xmlfilename xmlsettings
		
		xmlwriter = dotnetobject "system.xml.xmltextwriter" xmlfilename (dotnetclass "system.text.encoding").UTF8
		--xmlwriter.Formatting = (dotnetclass "system.xml.formatting").Indented
		--xmlwriter.Indentation = 4

		--xmlDoc=dotNetObject "system.xml.xmlDocument"
		--xmlRoot = xmlDoc.createelement "STRUCTURE"
		--xmlDoc.AppendChild xmlRoot

		xmlWriter.WriteStartDocument()
		xmlWriter.WriteStartElement "STRUCTURE"
		xmlWriter.WriteWhiteSpace "\n\t"
			xmlWriter.WriteStartElement "CHARACTERISTICS"
			xmlWriter.WriteWhiteSpace "\n\t\t"
			xmlWriter.WriteCData (CreateCharacteristicsCDataString obj indendation:2)
			xmlWriter.WriteWhiteSpace "\n\t\t"
			xmlWriter.WriteEndElement()
		xmlWriter.WriteWhiteSpace "\n\t"
			xmlWriter.WriteStartElement "CUSTOM_ZONES"
			xmlWriter.WriteWhiteSpace "\n\t"
			xmlWriter.WriteEndElement()
		xmlWriter.WriteWhiteSpace "\n"
			RecurseStructure xmlWriter obj isRootNode:true indentation:1
		xmlWriter.WriteWhiteSpace "\n"
		xmlWriter.WriteEndElement()
		xmlWriter.WriteWhiteSpace "\n"
		xmlWriter.WriteEndDocument()

		--xmlDecl = xmlDoc.CreateXmlDeclaration "1.0" "" ""
		--xmlDoc.InsertBefore xmlDecl xmlRoot

		--characteristicsNode = xmlDoc.createelement "CHARACTERISTICS"
		--cdatastr = CreateCharacteristicsCDataString obj
		--characteristicsCData = xmlDoc.createcdatasection cdatastr
		--characteristicsNode.appendchild characteristicscdata
		--xmlRoot.appendchild  characteristicsNode

		--customZonesNode = xmlDoc.CreateElement "CUSTOM_ZONES" 
		--xmlRoot.appendchild customZonesNode

		--xmlRoot.Appendchild (RecurseStructure xmlDoc obj isRootNode:true)

		--xmlDoc.WriteTo (xmlwriter)
		xmlwriter.flush()
		xmlwriter.close()
	)
	catch
	(
		format "Current exception: %\n" (getCurrentException())
		if xmlwriter != undefined then xmlwriter.close()
		throw()
	)
)

fn ExportVFXAnchors filename carRoot = (
)
fn ExportSystemsDamageXML filename carRoot = (
)

fn ExportCarVehicleCFG filename cfgMod = (
	cfg = dotNetObject "ToxicRagers.CarmageddonReincarnation.Formats.VehicleSetupConfig"

	cfg.AIScript = cfgMod.AIScript
	cfg.DriverSuffix = cfgMod.DriverSuffix
	cfg.SmallDriver = cfgMod.SmallDriver
	cfg.EjectDriver = cfgMod.EjectDriver
	for driver in cfgMod.Drivers do (
		cfg.Drivers.Add(driver)
	)
	if cfgMod.GarageCameraOffset_x != 0 or cfgMod.GarageCameraOffset_y != 0 or cfgMod.GarageCameraOffset_z != 0 then
	(
		cfg.GarageCameraOffset.x = -cfgMod.GarageCameraOffset_x
		cfg.GarageCameraOffset.y = cfgMod.GarageCameraOffset_z
		cfg.GarageCameraOffset.z = -cfgMod.GarageCameraOffset_y
	)
	cfg.InCarCamOffset.x = -cfgMod.InCarCameraPos_x
	cfg.InCarCamOffset.y = cfgMod.InCarCameraPos_z
	cfg.InCarCamOffset.z = -cfgMod.InCarCameraPos_y

	for i = 1 to cfgMod.PaintJobNames.count do (
		matMap = dotnetobject "ToxicRagers.CarmageddonReincarnation.Formats.VehicleMaterialMap"
		matMap.Name = cfgMod.PaintJobNames[i]
		matMap.Localisation = cfgMod.PaintJobLocalisedNames[i]
		matMap.Shrapnel.x = cfgMod.ShrapneColours[i].x
		matMap.Shrapnel.y = cfgMod.ShrapneColours[i].y
		matMap.Shrapnel.z = cfgMod.ShrapneColours[i].z
		replacements = filterstring cfgMod.MatReplacements[i] ";"
		for replacement in replacements do (
			matMap.Substitutions.Add replacement[1] replacement[2]
		)
		cfg.MaterialMaps.Add(matMap)
	)

	for i = 1 to cfgMod.WheelNames.count do (
		wheelMap = dotnetobject "ToxicRagers.CarmageddonReincarnation.Formats.VehicleWheelMap"
		wheelMap.Name = cfgMod.WheelNames[i]
		wheelMap.Localisation = cfgMod.WheelLocalisedNames[i]
		wheelEntries = dotnetobject "ToxicRagers.CarmageddonReincarnation.Formats.VehicleAttachmentComplicatedWheels"
		wheelEntries.FLWheel = cfgMod.FLWheelFolderNames[i]
		wheelEntries.FRWheel = cfgMod.FRWheelFolderNames[i]
		wheelEntries.RLWheel = cfgMod.RLWheelFolderNames[i]
		wheelEntries.RRWheel = cfgMod.RRWheelFolderNames[i]
		wheelEntries.D4 = cfgMod.D4WheelFolderNames[i]
		wheelEntries.D5 = cfgMod.D5WheelFolderNames[i]
		wheelEntries.D6 = cfgMod.D6WheelFolderNames[i]
		wheelEntries.D7 = cfgMod.D7WheelFolderNames[i]
		wheelEntries.D8 = cfgMod.D8WheelFolderNames[i]
		wheelEntries.D9 = cfgMod.D9WheelFolderNames[i]
		wheelEntries.D10 = cfgMod.D10WheelFolderNames[i]
		wheelEntries.D11 = cfgMod.D11WheelFolderNames[i]
		wheelMap.Wheels = wheelEntries
		cfg.WheelMaps.Add(wheelMap)
	)

	stats = dotnetobject "ToxicRagers.CarmageddonReincarnation.Formats.VehicleStats"
	stats.TopSpeed = cfgMod.TopSpeed
	stats.Time = cfgMod.To60Time
	stats.Toughness = cfgMod.Toughness
	stats.Weight = cfgMod.Weight
	stats.UnlockLevel = cfgMod.UnlockLevel

	cfg.stats = stats
	if cfgMod.MaxCompression_Active or cfgMod.MaxExtension_Active or cfgMod.RideHeight_Active or cfgMod.MaxSteeringLock_Active  then (

		suspFactors = dotnetobject "ToxicRagers.CarmageddonReincarnation.Formats.VehicleSuspensionFactors"
		if cfgMod.MaxCompression_Active then (
			suspFactors.MaxCompression = cfgMod.MaxCompression
		)
		if cfgMod.MaxExtension_Active then (
			suspFactors.MaxExtension = cfgMod.MaxExtension
		)
		if cfgMod.RideHeight_Active then (
			suspFactors.RightHeight = cfgMod.RideHeight
		)
		if cfgMod.MaxSteeringLock_Active then (
			suspFactors.MaxSteeringLock = cfgMod.MaxSteeringLock
		)

		cfg.SuspensionFactors = suspFactors;
	)
	attachTypeClass = dotNetClass "ToxicRagers.CarmageddonReincarnation.Formats.VehicleAttachment+AttachmentType"
	wheelModuleTypeClass = dotNetClass "ToxicRagers.CarmageddonReincarnation.Formats.VehicleWheelModule+WheelModuleType"
	dynWheelAttachment = dotnetobject "ToxicRagers.CarmageddonReincarnation.Formats.VehicleAttachment"
	dynWheelAttachment.Type = attachTypeClass.DynamicsWheels
	cfg.Attachments.add dynWheelAttachment

	attachments = dotnetobject "ToxicRagers.CarmageddonReincarnation.Formats.VehicleAttachment"
	attachments.Type = attachTypeClass.ExhaustParticles
	exhaustVFX = dotNetObject "ToxicRagers.CarmageddonReincarnation.Formats.VehicleAttachmentExhaust"
	exhaustVFX.VFX = cfgMod.ExhaustParticleVFX
	exhaustVFX.UnderwaterVFX = cfgMod.ExhaustParticleUnderwaterVFX
	exhaustVFX.Anchor = cfgMod.ExhaustAnchor
	exhaustVFX.Multiplier = cfgMod.ExhaustMultiplier
	exhaustVFX.NeutralMultiplier = cfgMod.ExhaustNeutralMultiplier
	attachments.Exhaust = exhaustVFX
	cfg.Attachments.add attachments

	if cfgMod.HornSound != "" do (
		attachments = dotnetobject "ToxicRagers.CarmageddonReincarnation.Formats.VehicleAttachment"
		attachments.Type =attachTypeClass.Horn
		attachments.Horn = cfgMod.HornSound
		cfg.Attachments.add attachments
	)
	if cfgMod.ReverseLightSound != "" do (
		attachments = dotnetobject "ToxicRagers.CarmageddonReincarnation.Formats.VehicleAttachment"
		attachments.Type =attachTypeClass.ReverseLightSound
		attachments.ReverseLightSound = cfgMod.ReverseLightSound
		cfg.Attachments.add attachments
	)
	if cfgMod.ContinuousSound != "" do (
		attachments = dotnetobject "ToxicRagers.CarmageddonReincarnation.Formats.VehicleAttachment"
		attachments.Type =attachTypeClass.ContinuousSound
		attachments.ContinuousSound = cfgMod.ContinuousSound
		attachments.ContinuousSoundLump = cfgMod.ContinuousSound_Lump
		cfg.Attachments.add attachments
	)
	if cfgMod.SkidMarksImage != "" do (
		wheelmodule = dotnetobject "ToxicRagers.CarmageddonReincarnation.Formats.VehicleWheelModule"
		wheelmodule.type = wheelModuleTypeClass.SkidMarks
		wheelmodule.SkidMarkImage = cfgMod.SkidMarksImage
		wheelmodule.OnlyTrails = cfgMod.OnlyTrails
		cfg.WheelModules.add wheelmodule
	)
	if cfgMod.TyreParticlesVFX != "" do (
		wheelmodule = dotnetobject "ToxicRagers.CarmageddonReincarnation.Formats.VehicleWheelModule"
		wheelmodule.type = wheelModuleTypeClass.TyreParticles
		wheelmodule.TyreParticleVFX = cfgMod.TyreParticlesVFX
		cfg.WheelModules.add wheelmodule

	)
	if cfgMod.SkidNoises != "" or cfgMod.UseScrapeSounds == true do (
		wheelmodule = dotnetobject "ToxicRagers.CarmageddonReincarnation.Formats.VehicleWheelModule"
		wheelmodule.type = wheelModuleTypeClass.SkidNoise
		wheelModule.UseScrapeSounds = cfgMod.UseScrapeSounds
		wheelModule.Volume = cfgMod.volume
		wheelModule.ScrapeSoundIndex =cfgMod.ScrapeIndex
		wheelModule.SkidNoiseSound = cfgMod.SkidNoises
		
		cfg.WheelModules.add wheelmodule

	)

	for trailer in cfgMod.HumanTrailers do (
		cfg.HumanTrailer.add trailer
	)
 	
	for trailer in cfgMod.AITrailers do (
		cfg.AITrailer.add trailer
	)
 	
	for trailer in cfgMod.MPTrailers do (
		cfg.MPTrailer.add trailer
	)

	attachments = dotnetobject "ToxicRagers.CarmageddonReincarnation.Formats.VehicleAttachment"
	fmodengine = dotnetobject "ToxicRagers.CarmageddonReincarnation.Formats.VehicleAttachmentFModEngine"
	attachments.Type =attachTypeClass.DynamicsFmodEngine
	fmodengine.RPMSmooth = cfgMod.FMODEngine_RPMSmooth
	fmodengine.OnLoadSmooth = cfgMod.FMODEngine_OnLoadSmooth
	fmodengine.OffLoadSmooth = cfgMod.FMODEngine_OffLoadSmooth
	fmodengine.LoadMin = cfgMod.FMODEngine_LoadMin
	fmodengine.MaxSpeed = cfgMod.FMODEngine_MaxSpeed
	fmodengine.MinRevs = cfgMod.FMODEngine_MinRevs
	fmodengine.MaxRevs = cfgMod.FMODEngine_MaxRevs
	fmodengine.Engine = cfgMod.FMODEngine
	attachments.FModEngine = fmodengine
	cfg.Attachments.add attachments

	cfg.Save filename
)
fn ExportCarSetupLUA filename setupMod = (
	setupFile = dotnetobject "ToxicRagers.CarmageddonReincarnation.Formats.Setup" 
	setupFile.Settings = dotNetObject "ToxicRagers.CarmageddonReincarnation.Formats.VehicleSetupCode"

	setupFile.Settings.SetParameterForMethod "CollisionEffect" "Effect"  setupMod.CollisionEffect_Name
setupFile.Settings.SetParameterForMethod "CollisionEffect" "Value"  setupMod.CollisionEffect_Strength

setupFile.Settings.SetParameterForMethod "PowerMultiplier" "Value" setupMod.PowerMultiplier
setupFile.Settings.SetParameterForMethod "TractionFactor" "Factor" setupMod.TractionFactor
setupFile.Settings.SetParameterForMethod "FinalDrive" "Value" setupMod.FinalDrive
setupFile.Settings.SetParameterForMethod "RearGrip" "Value" setupMod.RearGrip
setupFile.Settings.SetParameterForMethod "FrontGrip" "Value" setupMod.FrontGrip
setupFile.Settings.SetParameterForMethod "CMPosY" "Value" setupMod.CMPosY
setupFile.Settings.SetParameterForMethod "CMPosZ" "Value" setupMod.CMPosZ
setupFile.Settings.SetParameterForMethod "FrontDownforce" "Value" setupMod.FrontDownforce
setupFile.Settings.SetParameterForMethod "RearDownforce" "Value" setupMod.RearDownforce
setupFile.Settings.SetParameterForMethod "FrontRoll" "Value" setupMod.FrontRoll
setupFile.Settings.SetParameterForMethod "RearRoll" "Value" setupMod.RearRoll
setupFile.Settings.SetParameterForMethod "FrontCriticalAngle" "Value" setupMod.FrontCriticalAngle
setupFile.Settings.SetParameterForMethod "RearCriticalAngle" "Value" setupMod.RearCriticalAngle
setupFile.Settings.SetParameterForMethod "FrontSuspGive" "Value" setupMod.FrontSuspGive
setupFile.Settings.SetParameterForMethod "RearSuspGive" "Value" setupMod.RearSuspGive
setupFile.Settings.SetParameterForMethod "SuspDamping" "Value" setupMod.SuspDamping
setupFile.Settings.SetParameterForMethod "SuspensionRollFactor" "Value" setupMod.SuspensionRollFactor
setupFile.Settings.SetParameterForMethod "SuspensionPitchFactor" "Value" setupMod.SuspensionPitchFactor
setupFile.Settings.SetParameterForMethod "MomentOfInertiaMultiplier" "Value" setupMod.MomentOfInertiaMultiplier
setupFile.Settings.SetParameterForMethod "SteerSpeed1" "Value" setupMod.SteerSpeed1
setupFile.Settings.SetParameterForMethod "SteerSpeed2" "Value" setupMod.SteerSpeed2
setupFile.Settings.SetParameterForMethod "SteerSpeedVel" "Value" setupMod.SteerSpeedVel
setupFile.Settings.SetParameterForMethod "SteerCentreMultiplier" "Value" setupMod.SteerCentreMultiplier
setupFile.Settings.SetParameterForMethod "MaxSteeringAngle" "Value" setupMod.MaxSteeringAngle
setupFile.Settings.SetParameterForMethod "BrakeBalance" "Value" setupMod.BrakeBalance
setupFile.Settings.SetParameterForMethod "BrakeForce" "Value" setupMod.BrakeForce
setupFile.Settings.SetParameterForMethod "HandBrakeStrength" "Value" setupMod.HandBrakeStrength
setupFile.Settings.SetParameterForMethod "TorqueSplit" "Value" setupMod.TorqueSplit
setupFile.Settings.SetParameterForMethod "LSDThresholdF" "Value" setupMod.LSDThresholdF
setupFile.Settings.SetParameterForMethod "LSDThresholdR" "Value" setupMod.LSDThresholdR
setupFile.Settings.SetParameterForMethod "LSDThresholdM" "Value" setupMod.LSDThresholdM
setupFile.Settings.SetParameterForMethod "ReversePowerMulitplier" "Value" setupMod.ReversePowerMulitplier
setupFile.Settings.SetParameterForMethod "WheelMass" "Value" setupMod.WheelMass
setupFile.Settings.SetParameterForMethod "DragCoefficient" "Value" setupMod.DragCoefficient
setupFile.Settings.SetParameterForMethod "SteerLimit1" "Value" setupMod.SteerLimit1
setupFile.Settings.SetParameterForMethod "SteerLimit2" "Value" setupMod.SteerLimit2
setupFile.Settings.SetParameterForMethod "SteerLimitSpeed" "Value" setupMod.SteerLimitSpeed
setupFile.Settings.SetParameterForMethod "CastorSpeed1" "Value" setupMod.CastorSpeed1
setupFile.Settings.SetParameterForMethod "CastorSpeed2" "Value" setupMod.CastorSpeed2
setupFile.Settings.SetParameterForMethod "CastorSpeedVel" "Value" setupMod.CastorSpeedVel
setupFile.Settings.SetParameterForMethod "SteerGyroscope" "Value" setupMod.SteerGyroscope
setupFile.Settings.SetParameterForMethod "BrakeAttack" "Value" setupMod.BrakeAttack
setupFile.Settings.SetParameterForMethod "HandBrakeAttack" "Value" setupMod.HandBrakeAttack
setupFile.Settings.SetParameterForMethod "SlideSpinRecovery" "Value" setupMod.SlideSpinRecovery
setupFile.Settings.SetParameterForMethod "RollingResistance" "Value" setupMod.RollingResistance
setupFile.Settings.SetParameterForMethod "DriveMI" "Value" setupMod.DriveMI
setupFile.Settings.SetParameterForMethod "EngineMI" "Value" setupMod.EngineMI
setupFile.Settings.SetParameterForMethod "RedLine" "Value" setupMod.RedLine
setupFile.Settings.SetParameterForMethod "MaxRevs" "Value" setupMod.MaxRevs
setupFile.Settings.SetParameterForMethod "LimitRevs" "Value" setupMod.LimitRevs
setupFile.Settings.SetParameterForMethod "ConstantEngineFriction" "Value" setupMod.ConstantEngineFriction
setupFile.Settings.SetParameterForMethod "LinearEngineFriction" "Value" setupMod.LinearEngineFriction
setupFile.Settings.SetParameterForMethod "QuadraticEngineFriction" "Value" setupMod.QuadraticEngineFriction
setupFile.Settings.SetParameterForMethod "ConstantDriveFriction" "Value" setupMod.ConstantDriveFriction
setupFile.Settings.SetParameterForMethod "LinearDriveFriction" "Value" setupMod.LinearDriveFriction
setupFile.Settings.SetParameterForMethod "QuadraticDriveFriction" "Value" setupMod.QuadraticDriveFriction
setupFile.Settings.SetParameterForMethod "EngineBrakeDelay" "Value" setupMod.EngineBrakeDelay
setupFile.Settings.SetParameterForMethod "EngineBrakeAttack" "Value" setupMod.EngineBrakeAttack
setupFile.Settings.SetParameterForMethod "ClutchDelay" "Value" setupMod.ClutchDelay
setupFile.Settings.SetParameterForMethod "Mass" "Value" setupMod.Mass
setupFile.Settings.SetParameterForMethod "NumGears" "Value" setupMod.NumGears
setupFile.Settings.SetParameterForMethod "StabilityGripChange" "Value" setupMod.StabilityGripChange
setupFile.Settings.SetParameterForMethod "StabilityThreshold" "Value" setupMod.StabilityThreshold
setupFile.Settings.SetParameterForMethod "GearRatios" "Count" 10
for i = 1 to setupMod.GearRatios.count do (
	setupFile.Settings.SetParameterForMethod "GearRatios" (i as string) setupMod.GearRatios[i]
)
setupFile.Settings.SetParameterForMethod "TorqueCurve" "Count" 20
for i = 1 to setupMod.TorqueCurve.count do (
	setupFile.Settings.SetParameterForMethod "TorqueCurve" (i as string) setupMod.TorqueCurve[i]
)
/*
setupFile.Settings.SetParameterForMethod "PowerMultiplier" "Value" 1.5
setupFile.Settings.SetParameterForMethod "TractionFactor" "Factor" 1.2
setupFile.Settings.SetParameterForMethod "FinalDrive" "Value" 1
setupFile.Settings.SetParameterForMethod "RearGrip" "Value" 1.6
setupFile.Settings.SetParameterForMethod "FrontGrip" "Value" 1.7
setupFile.Settings.SetParameterForMethod "CMPosY" "Value" carRoot.min.z
setupFile.Settings.SetParameterForMethod "CMPosZ" "Value" (carRoot.min.y + (carRoot.max.y - carRoot.min.y) * 0.5)
setupFile.Settings.SetParameterForMethod "FrontDownforce" "Value" 20
setupFile.Settings.SetParameterForMethod "RearDownforce" "Value" 20
setupFile.Settings.SetParameterForMethod "FrontRoll" "Value" 0.4
setupFile.Settings.SetParameterForMethod "RearRoll" "Value" 0.3
setupFile.Settings.SetParameterForMethod "FrontCriticalAngle" "Value" 6
setupFile.Settings.SetParameterForMethod "RearCriticalAngle" "Value" 6
setupFile.Settings.SetParameterForMethod "FrontSuspGive" "Value" 0.1
setupFile.Settings.SetParameterForMethod "RearSuspGive" "Value" 0.08
setupFile.Settings.SetParameterForMethod "SuspDamping" "Value" 1
setupFile.Settings.SetParameterForMethod "SuspensionRollFactor" "Value" 1
setupFile.Settings.SetParameterForMethod "SuspensionPitchFactor" "Value" 1
setupFile.Settings.SetParameterForMethod "MomentOfInertiaMultiplier" "Value" 1
setupFile.Settings.SetParameterForMethod "SteerSpeed1" "Value" 1
setupFile.Settings.SetParameterForMethod "SteerSpeed2" "Value" 0.5
setupFile.Settings.SetParameterForMethod "SteerSpeedVel" "Value" 150
setupFile.Settings.SetParameterForMethod "SteerCentreMultiplier" "Value" 2
setupFile.Settings.SetParameterForMethod "MaxSteeringAngle" "Value" 40
setupFile.Settings.SetParameterForMethod "BrakeBalance" "Value" 60
setupFile.Settings.SetParameterForMethod "BrakeForce" "Value" 60
setupFile.Settings.SetParameterForMethod "HandBrakeStrength" "Value" 10
setupFile.Settings.SetParameterForMethod "TorqueSplit" "Value" 65
setupFile.Settings.SetParameterForMethod "LSDThresholdF" "Value" 10
setupFile.Settings.SetParameterForMethod "LSDThresholdR" "Value" 10
setupFile.Settings.SetParameterForMethod "LSDThresholdM" "Value" 10
setupFile.Settings.SetParameterForMethod "ReversePowerMulitplier" "Value" 1
setupFile.Settings.SetParameterForMethod "WheelMass" "Value" 10
setupFile.Settings.SetParameterForMethod "DragCoefficient" "Value" 0.4
setupFile.Settings.SetParameterForMethod "SteerLimit1" "Value" 0
setupFile.Settings.SetParameterForMethod "SteerLimit2" "Value" 0
setupFile.Settings.SetParameterForMethod "SteerLimitSpeed" "Value" 0
setupFile.Settings.SetParameterForMethod "CastorSpeed1" "Value" 0
setupFile.Settings.SetParameterForMethod "CastorSpeed2" "Value" 1
setupFile.Settings.SetParameterForMethod "CastorSpeedVel" "Value" 100
setupFile.Settings.SetParameterForMethod "SteerGyroscope" "Value" 1
setupFile.Settings.SetParameterForMethod "BrakeAttack" "Value" 1
setupFile.Settings.SetParameterForMethod "HandBrakeAttack" "Value" 0.1
setupFile.Settings.SetParameterForMethod "SlideSpinRecovery" "Value" 1
setupFile.Settings.SetParameterForMethod "RollingResistance" "Value" 0.018
setupFile.Settings.SetParameterForMethod "DriveMI" "Value" 2.2
setupFile.Settings.SetParameterForMethod "EngineMI" "Value" 0.06
setupFile.Settings.SetParameterForMethod "RedLine" "Value" 6500
setupFile.Settings.SetParameterForMethod "MaxRevs" "Value" 8000
setupFile.Settings.SetParameterForMethod "LimitRevs" "Value" true
setupFile.Settings.SetParameterForMethod "ConstantEngineFriction" "Value" 833
setupFile.Settings.SetParameterForMethod "LinearEngineFriction" "Value" 0
setupFile.Settings.SetParameterForMethod "QuadraticEngineFriction" "Value" 0.0023
setupFile.Settings.SetParameterForMethod "ConstantDriveFriction" "Value" 9.1
setupFile.Settings.SetParameterForMethod "LinearDriveFriction" "Value" 0
setupFile.Settings.SetParameterForMethod "QuadraticDriveFriction" "Value" 0.0008
setupFile.Settings.SetParameterForMethod "EngineBrakeDelay" "Value" 0.5
setupFile.Settings.SetParameterForMethod "EngineBrakeAttack" "Value" 0.28
setupFile.Settings.SetParameterForMethod "ClutchDelay" "Value" 0
setupFile.Settings.SetParameterForMethod "Mass" "Value" 1300
setupFile.Settings.SetParameterForMethod "NumGears" "Value" 5
setupFile.Settings.SetParameterForMethod "StabilityGripChange" "Value" 0.4
setupFile.Settings.SetParameterForMethod "StabilityThreshold" "Value" 0.5
 */
	setupFile.Save filename
)
fn ExportCarVehicleSetupLUA filename luaMod = (
	lua = stringstream ""
	format "module( ... )\n\n" to:lua
	format "camera_distance = %\n" luaMod.camera_distance to:lua
	format "camera_extra_tilt_angle = %\n" luaMod.camera_extra_tilt_angle to:lua
	format "default = %\n" luaMod.default to:lua
	format "dev = %\n" luaMod.dev to:lua
	format "cop = %\n" luaMod.cop to:lua
	format "eagle = %\n" luaMod.eagle to:lua
	format "tier = %\n" luaMod.tier to:lua
	format "progress = %\n" luaMod.progress to:lua
	format "shipped = %\n" luaMod.shipped to:lua
	format "leaderboard_id = %\n" luaMod.leaderboard_id to:lua
	format "unlock_node = %\n" luaMod.unlock_node to:lua
	format "class_rounded = %\n" luaMod.class_rounded to:lua
	format "class_speedy = %\n" luaMod.class_speedy to:lua
	format "class_smashy = %\n" luaMod.class_smashy to:lua
	format "barred_from_easy_on_ramp = %\n" luaMod.barred_from_easy_on_ramp to:lua
	format "hawk = %\n" luaMod.hawk to:lua
	format "suppressor = %\n" luaMod.suppressor to:lua
	format "product_id = %\n" luaMod.product_id to:lua
	format "consider_in_stats = %\n" luaMod.consider_in_stats to:lua
	format "override_vehicle_name = \"%\"\n" (substituteString  luaMod.override_vehicle_name "\"" "\\\"") to:lua
	format "override_driver_name = \"%\"\n" (substituteString  luaMod.override_driver_name "\"" "\\\"") to:lua
	format "override_bio = \"%\"\n" (substituteString  luaMod.override_bio "\"" "\\\"") to:lua
	format "hud_damage_levels = \n{\n" to:lua
	for damageLevel in luaMod.hud_damage_levels do (
		format "%," damageLevel to:lua
	)
	format "\n}" to:lua


	if filename != undefined then (

		f = openfile filename mode:"w"
		format "%" (lua as string) to:f
		close f
	)
)

fn ExportCarPaperworkButtonPressed sender arg =
(
	if (selection as array).count == 0 then
	(
		messageBox "Please select the root object to export (e.g. the car body)" title:"No objects selected!"
	)
	else if (selection as array).count > 1 then
	(
		messageBox "Please select JUST the root object to export (e.g. the car body)" title:"Too many objects selected!"
	)
	else
	(
			
		undo "Save C:R Car Structure.xml" on
		(
			if sender.parent.controls.Item["ExportStructureCheckbox"].checked then
			(
				struct_name = GetSaveFileName filename:"structure.xml" caption:"Save CNT As" types:"structure.XML|structure.xml"
				if struct_name != undefined do
				(
					--structureXmlFile = (getFilenamePath cnt_name)+"structure.xml"
					ExportStructureXML struct_name selection[1]
					messageBox ("Export Structure.xml to "+struct_name+" completed!") title:"Export Finished!"
				)
			)
		)
	)
)

fn ExportCarButtonPressed sender arg=
(
	if (selection as array).count == 0 then
	(
		messageBox "Please select the root object to export (e.g. the car body)" title:"No objects selected!"
	)
	else if (selection as array).count > 1 then
	(
		messageBox "Please select JUST the root object to export (e.g. the car body)" title:"Too many objects selected!"
	)
	else
	(
			
		undo "Export C:R Car" on
		(

			cnt_name = GetSaveFileName filename:"car.cnt" caption:"Save CNT As" types:"Car.CNT|car.cnt"
			if cnt_name != undefined do
			(
				exportTexturesChecked = sender.parent.controls.Item["ExportTexturesCheckbox"].checked
				exportMatsChecked = sender.parent.controls.Item["CreateMaterialsCheckbox"].checked
				global MaterialsToExport=#()
				mdl_path = getFilenamePath cnt_name
				ExportMDL mdl_path true true exportMats:exportMatsChecked exportTextures:exportTexturesChecked
				ExportCNT cnt_name selection[1]
				ExportMaterialsAndTextures mdl_path exportMats:exportMatsChecked exportTextures:exportTexturesChecked
				PrintArrayInFull MaterialsToExport "MaterialsToExport"
				
				structureXmlFile = (getFilenamePath cnt_name)+"structure.xml"
				ExportStructureXML structureXmlFile selection[1]
				messageBox ("Export Car to "+mdl_path+" completed!") title:"Export Finished!"
			)
		)
	)
)