FunsizeCarDetailsAttribute = attributes FunsizeCarDetailsCustAttribute attribid:#(0x9bf26d6, 0x2ce0600e) version:1
(
	parameters main rollout:FunsizeCarDetailsRollout (
		CarName type:#string ui:txt_CarName
		CarFullName type:#string ui:txt_CarFullName
		DriverName type:#string ui:txt_DriverName
		WastedName type:#string ui:txt_WastedName
		CarDescription type:#string ui:txt_CarDescription
		ShrapnelR type:#integer  min:0 max:255 default:128
		ShrapnelG type:#integer  min:0 max:255 default:128
		ShrapnelB type:#integer  min:0 max:255 default:128
		EnginePosEnabled type:#boolean ui:chk_enginePosEnabled default:false
		EnginePos type:#point3
		MaxBodyworkCrushEnabled type:#boolean ui:chk_MaxBodyworkCrushEnabled default:false
		MaxBodyworkCrush type:#point3
		GraphicalWheelLimitsEnabled type:#boolean default:false
		GraphicalWheelLimits type:#point4
		EngineNoises type:#string ui:txt_EngineNoises
		Grooves type:#string ui:txt_Grooves
		CollisionShapes type:#maxObjectTab tabsizevariable:true
		CollisionShapeText type:#string ui:txt_CollisionShapeText
		DynamicsText type:#string ui:txt_DynamicsText

		Defence type:#integer min:0 max: 10 default: 1 ui:spn_Defence
		Offence type:#integer min:0 max: 10 default: 1 ui:spn_Offence
		Power type:#integer min:0 max: 10 default:1 ui:spn_Power
		Softness type:#float default:0.7 ui:spn_Softness
		BHPperTon type:#integer min:1 max:5000 default:600 ui:spn_BHP
		TopSpeed type:#integer min:1 max:5000 default:200 ui:spn_TopSpeed
		Mass type:#integer min:1 max:20000 default:1000 ui:spn_Mass
		ShadowMask type:#string default:"shad\\ClassicCoupe" ui:txt_ShadowMask
		NaughtToSixty type:#float min:0 max:100 default:4 ui:spn_NaughtToSixty
	)

	rollout FunsizeCarDetailsRollout "Car Details"
	(
		edittext txt_CarName "Car Name"
		edittext txt_CarFullName "Car Full Name"
		edittext txt_CarDescription "Description"
		edittext txt_DriverName "Driver Name"
		edittext txt_WastedName "Wasted Message"
		colorPicker clr_Shrapnel "Shrapnel" default:(color ShrapnelR ShrapnelG ShrapnelB)
		checkbox chk_enginePosEnabled "Engine Position"
		spinner spn_EnginePosX "" across:3 type:#float default:EnginePos.x
		spinner spn_EnginePosY "" across:3 type:#float default:EnginePos.y
		spinner spn_EnginePosZ "" across:3 type:#float default:EnginePos.z
		checkbox chk_MaxBodyworkCrushEnabled "Max Bodywork Crush"
		spinner spn_MaxBodyworkCrushX "" across:3 type:#float default:MaxBodyworkCrush.x
		spinner spn_MaxBodyworkCrushY "" across:3 type:#float default:MaxBodyworkCrush.y
		spinner spn_MaxBodyworkCrushZ "" across:3 type:#float default:MaxBodyworkCrush.z
		checkbox chk_GraphicalWheelLimitsEnabled "Graphical Wheel Limits"
		spinner spn_GraphicalWheelLimitsX "" across:3 type:#float default:GraphicalWheelLimits.x
		spinner spn_GraphicalWheelLimitsY "" across:3 type:#float default:GraphicalWheelLimits.y
		spinner spn_GraphicalWheelLimitsZ "" across:3 type:#float default:GraphicalWheelLimits.z
		edittext txt_EngineNoises "Engine Noises" labelOnTop:true height:50
		edittext txt_Grooves "Grooves" labelOnTop:true height:75
		edittext txt_DynamicsText "Car Dynamics" labelOnTop:true height:75
		edittext txt_CollisionShapeText "Collision Shape" labelOnTop:true height:75


		group "Performance" (
			spinner spn_Defence "Defence" range:[0,10,1] type:#integer
			spinner spn_Offence "Offence" range:[0,10,1] type:#integer
			spinner spn_Power "Power" range:[0,10,1] type:#integer
			spinner spn_Softness "Softness" range:[0,1,0.7] type:#float
			spinner spn_BHP "BHP" range:[0,5000,1] type:#integer
			spinner spn_TopSpeed "TopSpeed" range:[0,5000,1] type:#integer
			spinner spn_Mass "Mass" range:[0,20000,1] type:#integer
			edittext txt_ShadowMask "Shadow Mask"
			spinner spn_NaughtToSixty "0 to 60 times" range:[0,100,1] type:#float
		)
		on clr_Shrapnel change value do (
			ShrapnelR = value.R
			ShrapnelG = value.G
			ShrapnelB = value.B
		)

		on chk_enginePosEnabled change value do (
			spn_EnginePosX.enabled = value
			spn_EnginePosY.enabled = value
			spn_EnginePosZ.enabled = value
		)
		on spn_EnginePosX change value do (
			EnginePos.x = value
		)

		on spn_EnginePosY change value do (
			EnginePos.y = value
		)

		on spn_EnginePosZ change value do (
			EnginePos.z = value
		)

		on chk_MaxBodyworkCrushEnabled change value do (
			spn_MaxBodyworkCrushX.enabled = value
			spn_MaxBodyworkCrushY.enabled = value
			spn_MaxBodyworkCrushZ.enabled = value
		)
		on spn_MaxBodyworkCrushX change value do (
			MaxBodyworkCrush.x = value
		)

		on spn_MaxBodyworkCrushY change value do (
			MaxBodyworkCrush.y = value
		)

		on spn_MaxBodyworkCrushZ change value do (
			MaxBodyworkCrush.z = value
		)

		on chk_GraphicalWheelLimitsEnabled change value do (
			spn_GraphicalWheelLimitsX.enabled = value
			spn_GraphicalWheelLimitsY.enabled = value
			spn_GraphicalWheelLimitsZ.enabled = value
		)
		on spn_GraphicalWheelLimitsX change value do (
			GraphicalWheelLimits.x = value
		)

		on spn_GraphicalWheelLimitsY change value do (
			GraphicalWheelLimits.y = value
		)

		on spn_GraphicalWheelLimitsZ change value do (
			GraphicalWheelLimits.z = value
		)

	)
)

fn AddFunsizeCarAttributes carRoot = (
	max modify mode
	carModifier = emptyModifier()
	
	carModifier.name = "Funsize Car"
	addModifier carRoot carModifier
	custattributes.add carModifier FunsizeCarDetailsAttribute baseObject:false
	carModifier
)

fn AddFunsizeShapeToCollisions obj car = (
	append car.modifiers["Funsize Car"].CollisionShapes (nodeTransformMonitor node:obj forwardTransformChangeMsgs:false)
) 

FunsizeHudDamageAttribute = attributes FunsizeHudDamageCustAttribute attribid:#(0x4ff9d70c, 0x465b9800) version:1
(
	parameters main rollout:FunsizeHudDamageRollout (
		Parts type:#stringTab tabsizevariable:true
		Positions type:#point4tab tabsizevariable:true
		Scales type:#point4tab tabsizevariable:true
		FlippedHorizontally type:#boolTab tabsizevariable:true
		FlippedVertically type:#boolTab tabsizevariable:true

	)
	rollout FunsizeHudDamageRollout "HUD Damage" (
		label lbl_ToDo "This shit is TO DO."	
	)
)

fn FunsizeAddHudDamageAttributes carRoot = (
	max modify mode
	HUDModifier = emptyModifier()
	
	HUDModifier.name = "Funsize HUD Damage"
	addModifier carRoot HUDModifier
	custattributes.add HUDModifier FunsizeHudDamageAttribute baseObject:false
	HUDModifier
)
fn FunsizeSetDefaultHudDamageEntries hudModifier = (
	append hudModifier.Parts "_strut"
	append hudModifier.Positions [0, 18, 32, 128]
	append hudModifier.Scales [1, 1, 0, 0]
	append hudModifier.FlippedHorizontally false
	append hudModifier.FlippedVertically false

	append hudModifier.Parts "_susp"
	append hudModifier.Positions [21, -60, 32, 32]
	append hudModifier.Scales [-1, 1, 0, 0]
	append hudModifier.FlippedHorizontally false
	append hudModifier.FlippedVertically false

	append hudModifier.Parts "_susp"
	append hudModifier.Positions [21, -60, 32, 32]
	append hudModifier.Scales [1, 1, 0, 0]
	append hudModifier.FlippedHorizontally false
	append hudModifier.FlippedVertically false

	append hudModifier.Parts "_susp"
	append hudModifier.Positions [-24, 60, 32, 32]
	append hudModifier.Scales [1, -1, 0, 0]
	append hudModifier.FlippedHorizontally false
	append hudModifier.FlippedVertically false

	append hudModifier.Parts "_susp"
	append hudModifier.Positions [24, 60, 32, 32]
	append hudModifier.Scales [-1, -1, 0, 0]
	append hudModifier.FlippedHorizontally false
	append hudModifier.FlippedVertically false

	append hudModifier.Parts "_steer"
	append hudModifier.Positions [-18, -6, 32, 64]
	append hudModifier.Scales [1, 1, 0, 0]
	append hudModifier.FlippedHorizontally false
	append hudModifier.FlippedVertically false

	append hudModifier.Parts "_10x20"
	append hudModifier.Positions [33, -60, 32, 64]
	append hudModifier.Scales [1, 1, 0, 0]
	append hudModifier.FlippedHorizontally false
	append hudModifier.FlippedVertically false

	append hudModifier.Parts "_10x20"
	append hudModifier.Positions [36, 60, 32, 64]
	append hudModifier.Scales [1, 1, 0, 0]
	append hudModifier.FlippedHorizontally false
	append hudModifier.FlippedVertically false

	append hudModifier.Parts "_10x20"
	append hudModifier.Positions [-36, 60, 32, 64]
	append hudModifier.Scales [1, 1, 0, 0]
	append hudModifier.FlippedHorizontally false
	append hudModifier.FlippedVertically false

	append hudModifier.Parts "_10x20"
	append hudModifier.Positions [-33, -60, 32, 64]
	append hudModifier.Scales [1, 1, 0, 0]
	append hudModifier.FlippedHorizontally false
	append hudModifier.FlippedVertically false

	append hudModifier.Parts "_engine"
	append hudModifier.Positions [3, -60, 64, 64]
	append hudModifier.Scales [1, 1, 0, 0]
	append hudModifier.FlippedHorizontally false
	append hudModifier.FlippedVertically false
)