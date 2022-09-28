FunsizePedDetailsAttribute = attributes FunsizePedDetailsCustAttribute attribid:#(0x7a0a642d, 0x7a777b7) version:1
(
	parameters main rollout:FunsizePedDetailsRollout (
		PedType type:#string ui:txt_PedType default:"PED_1"
		InitialPoint type:#integer ui:spn_InitialPoint default:1
	)
	rollout FunsizePedDetailsRollout "Ped Details" (
		edittext txt_PedType "Ped Type"
		spinner spn_InitialPoint "Initial Point" range:[1,1000,1]

	)
)

FunsizePowerupDetailsAttribute = attributes FunsizePowwrupDetailsCustAttribute attribid:#(0x259e73ea, 0x156bb6e7) version:1
(
	parameters main rollout:FunsizePowerupDetailsRollout (
		PowerupTypes type:#stringtab tabSizeVariable:true
		RespawnTime type:#float ui:spn_RespawnTime default:0
	)
	rollout FunsizePowerupDetailsRollout "Powerup Details" (
		spinner spn_RespawnTime "Respawn Time" range:[0,1000,0]
		label lbl_PowerupType "Powerup Types"

			dotnetcontrol lv_Powerups "listview" height: 100
			button btn_DeletePowerup "Delete Selected" across:2
			button btn_AddPowerup "New" across:2
			edittext txt_PowerupName

			fn RefreshPowerupTypesList = (

				if lv_Powerups == null or lv_Powerups.items == null then (

					lv_Powerups.view  = (dotnetclass "view").details
					lv_Powerups.fullrowselect= true
					lv_Powerups.gridlines = true
					lv_Powerups.multiselect =false
					lv_Powerups.columns.add "Name" 140
				)
				
				lv_Powerups.Items.Clear()
				for i = 1 to Powerupours.count do (

					lvitem = dotNetObject "listviewitem" Powerupours[i]
					lv_Powerups.items.add lvitem
				)
			)
			on FunsizePowerupDetailsRollout opeb do (
				RefreshPowerupTypesList()
			)

			on lv_Powerups selectedindexchanged do (
				if lv_Powerups.SelectedIndices.count > 0 then (
					local i = lv_Powerups.SelectedIndices.Item[0]
					local i2 = i + 1

					txt_PowerupName.text = PowerupTypes[i2]

				)
			)
			on txt_PowerupName changed txt do (
				if lv_Powerups.SelectedIndices.Count > 0 then (
					local i = lv_Powerups.SelectedIndices.Item[0]
					PowerupTypes[i+1] = txt
				)
			)
	)
)
FunsizeCopDetailsAttribute = attributes FunsizeCopDetailsCustAttribute attribid:#(0x77f0da8, 0x67623859) version:1
(
	parameters main rollout:FunsizeCopDetailsRollout (
		CopType type:#string ui:dpdn_CopType default:"Cop_1"
	)
	rollout FunsizeCopDetailsRollout "Cop Details" (
		dropdownlist dpdn_CopType "Cop Type" items:#("NORM", "APC")
	)
)

FunsizeAccessoryPlacementAttribute = attributes FunsizeAccessoryPlacementCustAttribute attribid:#(0x1069ea6b, 0x3635a4dc) version:1
(
	parameters main rollout:FunsizeAccessoryPlacementRollout (
		AccessoryType type:#string ui:txt_Type
		InstanceName type:#string ui:txt_InstanceName
		InstanceColour type:#color ui:col_InstanceColour
	)
	rollout FunsizeAccessoryPlacementRollout "Accessory Details" (
		edittext txt_Type "Accessory Type"
		button but_loadAccessory "Load Accessory"
		edittext txt_InstanceName "Instance Name"
		colorPicker col_InstanceColour "Instance Colour"

		on but_loadAccessory pressed do (
			local deps = refs.dependents this
			local node = undefined
			format "dependents:\n"
			for dep in deps do (
				format "\t% - %  - % - %\n" dep (classof dep) (superClassOf dep) (isKindOf dep GeometryClass)
				local deps2 = refs.dependents dep

				format "\tdependents:\n"
				for dep2 in deps2 do (
					format "\t\t% - % - % - %\n" dep2 (classof dep2) (superClassOf dep2) (isKindOf dep2 GeometryClass)
					if (isKindOf dep2 ReferenceTarget) == false then node = dep2
				)
			)

			if node != undefined then (
				ReplaceWithFunsizeAccessory AccessoryType node
				format "Node has % modifiers\n" node.modifiers.count

				for modifier in node.modifiers do format "\t%\n" modifier.name
			)
		)
	)
)
FunsizeLevelInfoAttribute = attributes FunsizeLevelInfoCustAttribute attribid:#(0x5ea740db, 0x13fb809a) version:1
(
	parameters main rollout:FunsizeLevelTextRollout (
		LevelNameKey type:#string ui:txt_LevelNameKey
		LevelName type:#string ui:txt_LevelName
		LevelDescriptionKey type:#string ui:txt_LevelDescriptionKey
		LevelDescription type:#string ui:txt_LevelDescription
		LevelEnvironmentKey type:#string ui:txt_LevelEnvironmentKey
		LevelEnvironment type:#string ui:txt_LevelEnvironment
		LevelText3Key type:#string ui:txt_LevelText3Key
		LevelText3 type:#string ui:txt_LevelText3

	)
	parameters unlocks rollout:FunsizeLevelUnlocksRollout (
		TrackUnlock type:#string ui:txt_TrackUnlock default:"none"
		VehicleUnlock type:#string ui:txt_VehicleUnlock default:"none"
		EventUnlock type:#string ui:txt_EventUnlock default:"none"

		SpecialCode type:#integer ui:spn_SpecialCode default:0

		RaceType type:#string ui:txt_RaceType default:"Wrecking Racing"

		LapLength type:#float ui:spn_LapLength range:[0,10000,0]
		PedCount type:#integer ui:spn_PedCount range:[0,10000,0]
		Laps type:#integer ui:spn_Laps default:3 range:[0,100,0]
		AISkill type:#integer ui:spn_AISkill default:2 range:[0,10,0]
		AICars type:#integer ui:spn_AICars default:2 range:[0,30,0]
		NumAI type:#integer ui:spn_NumAI default:2 range:[0,30,0]

		Boss type:#string ui:txt_Boss default:"None"
	)
	parameters timeandcredits rollout:FunsizeLevelTimeCreditsRollout (
		RequiredCredits type:#integer ui:spn_RequiredCredits

		WinBonusLaps_Easy type:#integer ui:spn_WinBonusLaps_Easy
		WinBonusLaps_Medium type:#integer ui:spn_WinBonusLaps_Medium
		WinBonusLaps_Hard type:#integer ui:spn_WinBonusLaps_Hard

		WinBonusPeds_Easy type:#integer ui:spn_WinBonusPeds_Easy
		WinBonusPeds_Medium type:#integer ui:spn_WinBonusPeds_Medium
		WinBonusPeds_Hard type:#integer ui:spn_WinBonusPeds_Hard

		WinBonusWasted_Easy type:#integer ui:spn_WinBonusWasted_Easy
		WinBonusWasted_Medium type:#integer ui:spn_WinBonusWasted_Medium
		WinBonusWasted_Hard type:#integer ui:spn_WinBonusWasted_Hard

		StartTime_Easy type:#integer ui:spn_StartTime_Easy
		StartTime_Medium type:#integer ui:spn_StartTime_Medium
		StartTime_Hard type:#integer ui:spn_StartTime_Hard

	)
	rollout FunsizeLevelTextRollout "Level Text" (
		edittext txt_LevelNameKey "LevelNameKey" labelOnTop:true
		edittext txt_LevelName "LevelName" labelOnTop:true
		edittext txt_LevelDescriptionKey "LevelDescriptionKey" labelOnTop:true
		edittext txt_LevelDescription "LevelDescription" labelOnTop:true
		edittext txt_LevelEnvironmentKey "LevelEnvironmentKey" labelOnTop:true
		edittext txt_LevelEnvironment "LevelEnvironment" labelOnTop:true
		edittext txt_LevelText3Key "LevelText3Key" labelOnTop:true
		edittext txt_LevelText3 "LevelText3" labelOnTop:true
	)
	rollout FunsizeLevelUnlocksRollout "Level Unlocks & Stats" (
		edittext txt_TrackUnlock "TrackUnlock"
		edittext txt_VehicleUnlock "VehicleUnlock"
		edittext txt_EventUnlock "EventUnlock"

		spinner spn_SpecialCode "SpecialCode" type:#integer  default:0

		edittext txt_RaceType "RaceType"

		spinner spn_LapLength "LapLength" type:#float range:[0,10000,0]
		spinner spn_PedCount "PedCount" type:#integer  range:[0,10000,0]
		spinner spn_Laps "Laps" type:#integer  default:3 range:[0,100,0]
		spinner spn_AISkill "AISkill" type:#integer  default:2 range:[0,10,0]
		spinner spn_AICars "AICars" type:#integer  default:2 range:[0,30,0]
		spinner spn_NumAI "NumAI" type:#integer  default:2 range:[0,30,0]

		edittext txt_Boss "Boss"
	)
	rollout FunsizeLevelTimeCreditsRollout "Level Credits & Timer" (

		spinner spn_RequiredCredits "RequiredCredits" type:#integer 

		spinner spn_WinBonusLaps_Easy "WinBonusLaps_Easy" type:#integer 
		spinner spn_WinBonusLaps_Medium "WinBonusLaps_Medium" type:#integer 
		spinner spn_WinBonusLaps_Hard "WinBonusLaps_Hard" type:#integer 

		spinner spn_WinBonusPeds_Easy "WinBonusPeds_Easy" type:#integer 
		spinner spn_WinBonusPeds_Medium "WinBonusPeds_Medium" type:#integer 
		spinner spn_WinBonusPeds_Hard "WinBonusPeds_Hard" type:#integer 

		spinner spn_WinBonusWasted_Easy "WinBonusWasted_Easy" type:#integer 
		spinner spn_WinBonusWasted_Medium "WinBonusWasted_Medium" type:#integer 
		spinner spn_WinBonusWasted_Hard "WinBonusWasted_Hard" type:#integer 

		spinner spn_StartTime_Easy "StartTime_Easy" type:#integer 
		spinner spn_StartTime_Medium "StartTime_Medium" type:#integer 
		spinner spn_StartTime_Hard "StartTime_Hard" type:#integer 
	)
)
FunsizeLevelDetailsAttribute = attributes FunsizeLevelDetailsCustAttribute attribid:#(0x2818f431, 0x61352613) version:1
(
	parameters main rollout:FunsizeLevelDetailsRollout (
		LevelFolderName type:#string ui:txt_FolderName default: "userlevel"
		LevelFileName type:#string ui:txt_FileName default: "LEVEL_01.txt"
		LevelLayerName type:#string default: "sys_level_01"
		LevelPedLayerName type:#string default: "sys_level_01_ped"
		LevelPowerupLayerName type:#string default: "sys_level_01_powerups"
		LevelPathsLayerName type:#string default: "sys_level_01_paths"
		LevelName type:#string ui:txt_LevelName default:"User Level"
		LevelDescription type:#string ui:txt_LevelDescription default: "This is a user made level"
		Environment type:#string ui:txt_Environment default:"nyhorizn"
		EnvironmentMap type:#string ui:txt_EnvironmentMap default:"env"
		ShadowStrength type:#color default:(color 178 178 178)
		MapName type:#string ui:txt_MapName defualt:"Embankment_level"
		MapSize type:#point3
		MapCenter type:#point3
		BigMap type:#string ui:txt_BigMap
		GridHelper type:#maxObject
		MapMatrix type:#Matrix3
		FogColour type:#color ui:col_FogColour
		LightingColour type:#color ui:col_LightingColour
		Headlights type:#boolean ui:chk_Headlights
		Splash type:#string ui:txt_Splash
		AutoRecoverHeightEnabled type:#boolean ui:chk_AutoRecoverHeightenabled
		AutoRecoverHeight type:#float ui:spn_AutoRecoverHeight
		Viz type:#integer ui:spn_Viz default:435
		AIPath type:#string ui:txt_AIPath
		MatMods type:#string
		SmokeColours type:#colorTab tabSizeVariable:true

	)

	rollout FunsizeLevelDetailsRollout "Level Details" (
		group "Level Details" (
			edittext txt_FolderName "Folder Name"
			edittext txt_FileName "File Name"
			dropdownlist dpdn_LayerName "Accessory Layer"
			dropdownlist dpdn_PedLayerName "Ped Layer"
			dropdownlist dpdn_PowerupLayerName "Powerup Layer"
			edittext txt_LevelName "Level Name"
			edittext txt_LevelDescription "Level Description"
			edittext txt_Environment "Environment"
			edittext txt_EnvironmentMap "Environment Map"
			edittext txt_Splash "Splash Texture"
			checkbox chk_AutoRecoverHeightenabled "Auto Recovery Height"
			spinner spn_AutoRecoverHeight "" type:#float range:[-500,500,-100]
			spinner spn_Viz "VIZ" type:#integer range:[0,1000,435]
			edittext txt_AIPath "AI Paths File"
		)
		group "Mini Map" (
			edittext txt_MapName "Map Name"
			edittext txt_BigMap "Map Image"
			label lbl_MapSize "Map Size"
			spinner spn_MapSizeX "X" across:2 
			spinner spn_MapSizeY "Y" across:2 
			label lbl_MapCenter "Map Center"
			spinner spn_MapCenterX "X" across:2 
			spinner spn_MapCenterY "Y" across:2 
			button btn_ComputeMapsize "Calulate Size"


			label lbl_MapMatrix "Map Matrix"
			spinner spn_MapMatrixM11 "" across:3
			spinner spn_MapMatrixM12 "" across:3 
			spinner spn_MapMatrixM13 "" across:3 
			spinner spn_MapMatrixM21 "" across:3
			spinner spn_MapMatrixM22 "" across:3 
			spinner spn_MapMatrixM23 "" across:3 
			spinner spn_MapMatrixM31 "" across:3
			spinner spn_MapMatrixM32 "" across:3 
			spinner spn_MapMatrixM33 "" across:3 
			spinner spn_MapMatrixM41 "" across:3
			spinner spn_MapMatrixM42 "" across:3 
			spinner spn_MapMatrixM43 "" across:3 
			button btn_ComputeMapMatrix "Calulate Matrix"

		)
		group "Lighting" (
			colorpicker col_FogColour "Fog Colour"
			colorpicker col_LightingColour "Light Colour"
			checkbox chk_Headlights "Headlights"
		)
		group "Smoke Colours" (
			dotnetcontrol lv_SmokeCols "listview" height: 100
			button btn_DeleteSmokeCol "Delete Selected" across:2
			button btn_AddSmokeCol "New" across:2

			colorpicker col_SmokeCol "Colour"
		)
		group "Mat Mods" (

			dotnetcontrol lv_MatMods "listview" height: 100
			button btn_DeleteMatMod "Delete Selected" across:2
			button btn_AddMatMod "New" across:2

			spinner spn_WallFriction "Wall Friction"
			spinner spn_TyreFriction "Tyre Friction"
			spinner spn_DownForce "Down force"
			spinner spn_Bumpiness "Bumpiness"
			spinner spn_TyreSound "Tyre Sound" type:#integer
			spinner spn_CrashSound "Crash Sound" type:#integer
			spinner spn_ScrapeSound "Scrape Sound" type:#integer
			spinner spn_Sparks "Sparks"
			spinner spn_SmokeType "Smoke Type"
			button btn_SaveMatMod "Save"
		)

		fn refreshSmokeCols = (
			if lv_SmokeCols == null or lv_SmokeCols.items == null then (

				lv_SmokeCols.view  = (dotnetclass "view").details
				lv_SmokeCols.fullrowselect= true
				lv_SmokeCols.gridlines = true
				lv_SmokeCols.multiselect =false
				lv_SmokeCols.columns.add "Name" 140
			)
			
			lv_SmokeCols.Items.Clear()
			for i = 1 to SmokeColours.count do (

				lvitem = dotNetObject "listviewitem" (SmokeColours[i].r as string +", "+SmokeColours[i].g as string+", "+SmokeColours[i].b as string)
				lv_SmokeCols.items.add lvitem
			)
		)
		fn refreshMatMods = (
			if lv_MatMods == null or lv_MatMods.items == null then (

				lv_MatMods.view  = (dotnetclass "view").details
				lv_MatMods.fullrowselect= true
				lv_MatMods.gridlines = true
				lv_MatMods.multiselect =false
				lv_MatMods.columns.add "Name" 140
			)
			if MatMods!= undefined and MatMods.count > 0 then (
				local splitMatMods = filterstring MatMods ":"
				lv_MatMods.Items.Clear()
				for i = 0 to splitMatMods.count-1 do (

					lvitem = dotNetObject "listviewitem" ("Mat #"+(i as string))
					lv_MatMods.items.add lvitem
				)
			)
		)

		fn refreshMapData = (
			spn_MapSizeX.Value = MapSize.x
			spn_MapSizeY.Value = MapSize.y
			spn_MapCenterX.Value = MapCenter.x
			spn_MapCenterY.Value = MapCenter.y
			spn_MapMatrixM11.value = MapMatrix.row1.x
			spn_MapMatrixM12.value = MapMatrix.row1.y
			spn_MapMatrixM13.value = MapMatrix.row1.z
			spn_MapMatrixM21.value = MapMatrix.row2.x
			spn_MapMatrixM22.value = MapMatrix.row2.y
			spn_MapMatrixM23.value = MapMatrix.row2.z
			spn_MapMatrixM31.value = MapMatrix.row3.x
			spn_MapMatrixM32.value = MapMatrix.row3.y
			spn_MapMatrixM33.value = MapMatrix.row3.z
			spn_MapMatrixM41.value = MapMatrix.row4.x
			spn_MapMatrixM42.value = MapMatrix.row4.y
			spn_MapMatrixM43.value = MapMatrix.row4.z
		)
		fn refreshLayerList = (
			if (LayerManager.getLayerFromName LevelLayerName) == undefined then(
				LayerManager.newLayerFromName LevelLayerName
			)
			if (LayerManager.getLayerFromName LevelPedLayerName) == undefined then(
				LayerManager.newLayerFromName LevelPedLayerName
			)
			if (LayerManager.getLayerFromName LevelPowerupLayerName) == undefined then(
				LayerManager.newLayerFromName LevelPowerupLayerName
			)
			if (LayerManager.getLayerFromName LevelPathsLayerName) == undefined then(
				LayerManager.newLayerFromName LevelPathsLayerName
			)
			local items = #()

			for i = 1 to layerManager.count - 1 do (
				local layer = layerManager.getLayer i
				append items layer.Name

			)
			dpdn_LayerName.items = items
			dpdn_LayerName.selection = finditem dpdn_LayerName.items LevelLayerName
			dpdn_PedLayerName.items = items
			dpdn_PedLayerName.selection = finditem dpdn_PedLayerName.items LevelPedLayerName
			dpdn_PowerupLayerName.items = items
			dpdn_PowerupLayerName.selection = finditem dpdn_LayerName.items LevelPowerupLayerName
		)
		on FunsizeLevelDetailsRollout open do (

			refreshMapData()
			refreshMatMods()
			refreshSmokeCols()
			refreshLayerList()

		)

		on dpdn_LayerName selected selectedIndex do (
			LevelLayerName = dpdn_LayerName.Items[selectedIndex]
		)
		on lv_SmokeCols selectedindexchanged do (
			if lv_SmokeCols.SelectedIndices.count > 0 then (
				local i = lv_SmokeCols.SelectedIndices.Item[0]
				local i2 = i + 1

				col_SmokeCol.color = SmokeColours[i2]

			)
		)
		on col_SmokeCol changed col do (
			if lv_SmokeCols.SelectedIndices.Count > 0 then (
				local i = lv_SmokeCols.SelectedIndices.Item[0]
				SmokeColours[i+1] = col
			)
		)
		on lv_MatMods selectedindexchanged index do (
			local splitMatMods =filterstring MatMods ":"
			if lv_MatMods.SelectedIndices.count > 0 then (
				local i = lv_MatMods.SelectedIndices.Item[0]
				local i2 = i + 1
				local matModDetails = filterstring splitMatMods[i2] ";"

				spn_WallFriction.value = matModDetails[1] as float
				spn_TyreFriction.value = matModDetails[2] as float
				spn_DownForce.value = matModDetails[3] as float
				spn_Bumpiness.value = matModDetails[4] as float
				spn_TyreSound.value = matModDetails[5] as integer
				spn_CrashSound.value = matModDetails[6] as integer
				spn_ScrapeSound.value = matModDetails[7] as integer
				spn_Sparks.value = matModDetails[8] as float
				spn_SmokeType.value = matModDetails[9] as float
			)	
		)
		on btn_DeleteMatMod pressed do (

			if lv_MatMods.SelectedIndices.count > 0 then (
				local i = lv_MatMods.SelectedIndices.Item[0] + 1
				local splitMatMods =filterstring MatMods ":"
				deleteItem splitMatMods i
				refreshMatMods()
			)
		)
		on btn_AddMatMod pressed do (
			lv_MatMods.SelectedIndices.Clear()

				spn_WallFriction.value = 1.0
				spn_TyreFriction.value = 1.0
				spn_DownForce.value = 1.0
				spn_Bumpiness.value = 0.0
				spn_TyreSound.value = 0
				spn_CrashSound.value = 0
				spn_ScrapeSound.value = 0
				spn_Sparks.value = 1.0
				spn_SmokeType.value = 1.0
		)
		on btn_SaveMatMod pressed do (
			if MatMods == undefined then MatMods = ""
			local matModString = (spn_WallFriction.value as string) + ";" + (spn_TyreFriction.value as string) + ";" + (spn_DownForce.value as string) + ";" + (spn_Bumpiness.value as string) + ";" + (spn_TyreSound.value as string) + ";" + (spn_CrashSound.value as string) + ";" + (spn_ScrapeSound.value as string) + ";" + (spn_Sparks.value as string) + ";" + (spn_SmokeType.value as string)
			if lv_MatMods.SelectedIndices.count > 0 then (
				local i = lv_MatMods.SelectedIndices.Item[0] + 1
				local splitMatMods =filterstring MatMods ":"
				splitMatMods[i] = matModString
				Matmods = ""
				for i = 1 to splitMatMods.Count do (
					if i > 1 then MatMods = MatMods + ":"
					MatMods = MatMods + splitMatMods[i] + ":"
				)

			)
			else (
				MatMods = MatMods + ":" + matModString
			)

			refreshMatMods()
		)
	)

)

fn AddFunsizePedAttributes pedRoot = (
	max modify mode
	pedModifier = emptyModifier()
	
	pedModifier.name = "Funsize Ped"
	addModifier pedRoot pedModifier
	custattributes.add pedModifier FunsizePedDetailsAttribute baseObject:false
	pedModifier
)
fn AddFunsizeCopAttributes CopRoot = (
	max modify mode
	CopModifier = emptyModifier()
	
	CopModifier.name = "Funsize Cop"
	addModifier CopRoot CopModifier
	custattributes.add CopModifier FunsizeCopDetailsAttribute baseObject:false
	CopModifier
)
fn AddFunsizeAccessoryItemAttributes accRoot = (
	max modify mode
	accModifier = emptyModifier()
	
	accModifier.name = "Funsize Accessory"
	addModifier accRoot accModifier
	custattributes.add accModifier FunsizeAccessoryPlacementAttribute baseObject:false
	accModifier
)
fn AddFunsizePowerupItemAttributes pupRoot = (
	max modify mode
	pupModifier = emptyModifier()
	
	pupModifier.name = "Funsize Powerup"
	addModifier pupRoot pupModifier
	custattributes.add pupModifier FunsizePowerupDetailsAttribute baseObject:false
	pupModifier
)
fn AddFunsizeLevelAttributes levelRoot = (
	max modify mode
	levelModifier = emptyModifier()
	
	levelModifier.name = "Funsize Level Settings"
	addModifier levelRoot levelModifier
	custattributes.add levelModifier FunsizeLevelDetailsAttribute baseObject:false
	levelModifier
)
fn AddFunsizeLevelInfoAttributes levelRoot = (
	max modify mode
	levelModifier = emptyModifier()
	
	levelModifier.name = "Funsize Level Info"
	addModifier levelRoot levelModifier
	custattributes.add levelModifier FunsizeLevelInfoAttribute baseObject:false
	levelModifier
)


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