fn SetToComplicatedWheel obj = (
	wheelModifier = emptyModifier()
	wheelModifier.name = "Complicated Wheel"
	addModifier obj wheelModifier

	custAttributes.add wheelModifier ComplicatedWheelAttribute
	obj.modifiers["Complicated Wheel"]
)

fn SaveWheelLUA obj wheelfolder = (
	luaCode = "";

	wheelModifier = obj.modifiers["Complicated Wheel"]

	if wheelModifier.RotateTyre then luaCode = luaCode + "CComplicatedWheelParameters:Set_RotateTyre( true )\n"
	else luaCode = luaCode + "CComplicatedWheelParameters:Set_RotateTyre( false )\n"

	luaCode = luaCode + "CComplicatedWheelParameters:Set_ScrollTyreTiles( "+(wheelModifier.ScrollTyreTiles as string) +")\n"
	if wheelModifier.UseSkidmarkWidth then 	 luaCode = luaCode + "CComplicatedWheelParameters:Set_SkidMarkWidth( "+(wheelModifier.SkidmarkWidth as string) +" )\n"
	else luaCode = luaCode + "CComplicatedWheelParameters:Set_SkidMarkWidth( "+(wheelModifier.SkidmarkWidth as string) +" )\n"

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