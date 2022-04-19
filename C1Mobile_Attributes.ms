FunsizeCarDetailsAttribute = attributes FunsizeCarDetailsCustAttribute attribid:#(0x9bf26d6, 0x2ce0600e) version:1
(
	parameters main rollout:FunsizeCarDetailsRollout (
		CarName type:#string ui:txt_CarName
		CarFullName type:#string ui:txt_CarFullName
		DriverName type:#string ui:txt_DriverName
		WastedName type:#string ui:txt_WastedName
		CarDescription type:#string ui:txt_CarDescription
		Shrapnel type:#color default:(color 128 128 128) ui:clr_Shrapnel
		ShrapnelR type:#integer  min:0 max:255 default:128
		ShrapnelG type:#integer  min:0 max:255 default:128
		ShrapnelB type:#integer  min:0 max:255 default:128
		EnginePosEnabled type:#boolean ui:chk_enginePosEnabled default:false
		EnginePos type:#point3
		MaxBodyworkCrushEnabled type:#boolean ui:chk_MaxBodyworkCrushEnabled default:false
		MaxBodyworkCrush type:#point3
		GraphicalWheelLimitsEnabled type:#boolean default:false ui:chk_GraphicalWheelLimitsEnabled
		GraphicalWheelLimits type:#point4
		EngineNoises type:#string ui:txt_EngineNoises
		Grooves type:#string ui:txt_Grooves
		CollisionShapes type:#maxObjectTab tabsizevariable:true
		CollisionShapeText type:#string
		DynamicsText type:#string ui:txt_DynamicsText
		RideHeightEnabled type:#boolean default:false ui:chk_RideHeightEnabled
		RideHeight type:#float ui:spn_RideHeight
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
		colorPicker clr_Shrapnel "Shrapnel"
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
		checkbox chk_RideHeightEnabled "Ride Height"
		spinner spn_RideHeight ""  type:#float default:RideHeight
		group "Collision Shapes"(
			dotnetcontrol lv_shapes "listview" height: 200
			pickbutton pck_AddCollisionShape "Add" across:3
			button btn_SelectCollisionShape "Select" across:3
			button btn_DeleteCollisionShape "Delete"
		)

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

		fn refreshShapesList = (
			if lv_shapes == null or lv_shapes.items == null then (

				lv_shapes.view  = (dotnetclass "view").details
				lv_shapes.fullrowselect= true
				lv_shapes.gridlines = true
				lv_shapes.multiselect =false
				lv_shapes.columns.add "Name" 140
			)
			lv_shapes.Items.clear()
			for shape in collisionshapes do (
				lvItem = dotnetobject "listviewitem" shape.node.name
				lv_shapes.Items.add lvitem
			)
		)
		fn AddCollisionShape obj= (
			
			existingShape = for oldshape in CollisionShapes where oldshape.node == obj collect oldshape

			if(existingShape == undefined or existingShape.count == 0) then
			(
				append CollisionShapes (NodeTransformMonitor node:obj forwardTransformChangeMsgs:false)
			)
		)

		on pck_AddCollisionShape picked obj do (
			AddCollisionShape obj
			refreshShapesList()
		)
		on btn_SelectCollisionShape pressed do (
			if lv_shapes.SelectedIndices.count > 0 then
			(
				selectedIndex = lv_shapes.SelectedIndices.Item[0]
				select CollisionShapes[selectedIndex+1].node
				
			)
		)
		on btn_DeleteCollisionShape pressed do (
			if lv_shapes.SelectedIndices.count > 0 then
			(
				selectedIndex = lv_shapes.SelectedIndices.Item[0]
				deleteItem CollisionShapes (selectedIndex+1)
				refreshShapesList()
			)
		)

		on FunsizeCarDetailsRollout open do (
			--clr_Shrapnel.color = (color ShrapnelR ShrapnelG ShrapnelB)
			spn_EnginePosX.value = EnginePos.x
			spn_EnginePosY.value = EnginePos.y
			spn_EnginePosZ.value = EnginePos.z
			spn_MaxBodyworkCrushX.value = MaxBodyworkCrush.x
			spn_MaxBodyworkCrushY.value = MaxBodyworkCrush.y
			spn_MaxBodyworkCrushZ.value = MaxBodyworkCrush.z

			spn_GraphicalWheelLimitsX.value = GraphicalWheelLimits.x
			spn_GraphicalWheelLimitsY.value = GraphicalWheelLimits.y
			spn_GraphicalWheelLimitsZ.value = GraphicalWheelLimits.z
			spn_GraphicalWheelLimitsX.enabled = GraphicalWheelLimitsEnabled
			spn_GraphicalWheelLimitsY.enabled = GraphicalWheelLimitsEnabled
			spn_GraphicalWheelLimitsZ.enabled = GraphicalWheelLimitsEnabled
			spn_RideHeight.enabled = RideHeightEnabled

			lv_shapes.view  = (dotnetclass "view").details
			lv_shapes.fullrowselect= true
			lv_shapes.gridlines = true
			lv_shapes.multiselect =false
			lv_shapes.columns.add "Name" 140
			refreshShapesList()
		)

		on clr_Shrapnel changed value do (
			ShrapnelR = value.R
			ShrapnelG = value.G
			ShrapnelB = value.B
		)

		on chk_enginePosEnabled changed value do (
			spn_EnginePosX.enabled = value
			spn_EnginePosY.enabled = value
			spn_EnginePosZ.enabled = value
		)
		on spn_EnginePosX changed value do (
			EnginePos.x = value
		)

		on spn_EnginePosY changed value do (
			EnginePos.y = value
		)

		on spn_EnginePosZ changed value do (
			EnginePos.z = value
		)

		on chk_MaxBodyworkCrushEnabled changed value do (
			spn_MaxBodyworkCrushX.enabled = value
			spn_MaxBodyworkCrushY.enabled = value
			spn_MaxBodyworkCrushZ.enabled = value
		)
		on spn_MaxBodyworkCrushX changed value do (
			MaxBodyworkCrush.x = value
		)

		on spn_MaxBodyworkCrushY changed value do (
			MaxBodyworkCrush.y = value
		)

		on spn_MaxBodyworkCrushZ changed value do (
			MaxBodyworkCrush.z = value
		)

		on chk_RideHeightEnabled changed value do (
			spn_RideHeight.enabled = value
		)

		on chk_GraphicalWheelLimitsEnabled changed value do (
			spn_GraphicalWheelLimitsX.enabled = value
			spn_GraphicalWheelLimitsY.enabled = value
			spn_GraphicalWheelLimitsZ.enabled = value
		)
		on spn_GraphicalWheelLimitsX changed value do (
			GraphicalWheelLimits.x = value
		)

		on spn_GraphicalWheelLimitsY changed value do (
			GraphicalWheelLimits.y = value
		)

		on spn_GraphicalWheelLimitsZ changed value do (
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

fn QuickSetupMobileCar = (
	local carRoot = selection[1]
	AddFunsizeCarAttributes carRoot
	hudModifier = FunsizeAddHudDamageAttributes carRoot
	FunsizeSetDefaultHudDamageEntries hudModifier
)