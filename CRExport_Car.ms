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
	if charmod.Aerofoil2MovementUpTime_Active then str += "CVehicleCharacteristics:Set_Offence( "+(charmod.Aerofoil2MovementUpTime as string)+" )"+whiteSpaceString
	if charmod.Aerofoil2MovementDownTime_Active then str += "CVehicleCharacteristics:Set_Offence( "+(charmod.Aerofoil2MovementDownTime as string)+" )"+whiteSpaceString
	
	if charmod.CaterpillerTracks_Enabled then
	(
		for i=0 to charmod.SegmentDefinition_Name.count do
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
	if obj.modifiers["CNT Hierarchy"].NodeType == "MODL" then str += "CWeldParameters:Set_VertexColour( "+(weldMod.VertexColourR as string)+", "+(weldMod.VertexColourG as string)+", "+(weldMod.VertexColourB as string)+", "+(weldMod.VertexColourA as string)+" )"+whiteSpaceString
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