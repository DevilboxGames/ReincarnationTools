fn PlaceGridHelper location orientation = (
	local gridMeshPath = (dotnetclass "System.IO.Path").Combine #((getFileNamePath (getThisScriptFilename())), "MDLs", "grid", "grid.cnt")

	local gridNull = CreateNewNULLNode (matrix3 1) (instanceName as string) addAttributes:true nodeType:"IGNORE"
	local gridHelper = QuickImportCnt gridMeshPath mergeMdls:true

	gridHelper.rotation = EulerAngles 0 0 -(orientation - 90)
	gridHelper.position = location
	
	gridNull.rotation = EulerAngles 0 0 -(orientation - 90)
	gridNull.position = location
	
	SetCNTNodeType gridHelper "IGNORE"
	gridNull.name = "GRID_HELPER"
	gridHelper.parent = gridNull
	gridHelper
)

fn PlacePowerup trans pupNames respawnTime = (
	
	local pupNull = CreateNewNULLNode trans (instanceName as string) addAttributes:true nodeType:"IGNORE"
	local pupMeshPath = (dotnetclass "System.IO.Path").Combine #((getFileNamePath (getThisScriptFilename())), "MDLs\\pup", "pup.cnt")


	local pupHelper = QuickImportCnt pupMeshPath mergeMdls:true
	

	pupHelper.transform = trans
	pupNull.transform = trans
	
	SetCNTNodeType pupHelper "IGNORE"
	pupNull.name = "pup_HELPER_" + pupNames[1]
	pupHelper.parent = pupNull

	local pupMod = AddFunsizePowerupItemAttributes pupNull
	pupMod.PowerupTypes = pupNames
	pupMod.RespawnTime = respawnTime
	pupNull
)

fn PlaceCopHelper copType location = (
	
	local copNull = CreateNewNULLNode (matrix3 1) (instanceName as string) addAttributes:true nodeType:"IGNORE"
	local copMeshPath = (dotnetclass "System.IO.Path").Combine #((getFileNamePath (getThisScriptFilename())), "MDLs\\cops", copType, "carbody.cnt")


	local copHelper = QuickImportCnt copMeshPath mergeMdls:true
	

	copHelper.position = location
	copNull.position = location
	
	copNull.name = "COP_HELPER"

	SetCNTNodeType copHelper "IGNORE"
	local copMod = AddFunsizeCopAttributes copNull
	copMod.CopType = copType
	copHelper.parent = copNull
	copNull
)

fn PlacePed pedType pedPoints loopCount = (

	local pedspline = SplineShape()
	pedspline.pos = pedPoints[1]
	if pedPoints.count > 1 then (
		addNewSpline  pedspline

		for pos in pedPoints do (
			addKnot pedspline 1 #corner #line pos
		)

		updateShape pedspline
	)
	local pedMod = AddFunsizePedAttributes pedspline
	pedMod.PedType = pedType
	pedMod.LoopCount = LoopCount

	local pedNull = CreateNewNULLNode (matrix3 1) (pedType as string) addAttributes:true nodeType:"IGNORE"
	pedNull.pos = pedPoints[1]
	pedSpline.parent = pedNull
	pedNull
)

fn PlaceMobileAccessory trans accessoryName instanceName instanceColour = (

	local accNull = CreateNewNULLNode trans (instanceName as string) addAttributes:true nodeType:"IGNORE"
	local accMod = AddFunsizeAccessoryItemAttributes accNull

	accMod.InstanceColour = instanceColour
	if instanceName != undefined then (
		accMod.InstanceName = instanceName
	)
	accMod.AccessoryType = accessoryName

	ReplaceWithFunsizeAccessory accessoryName accNull

)

fn CreateLevelInfo = (

	local levelNum = (for n in objects where (findstring n.name "sys_RaceInfo_") == 1 collect n).count + 1
	local levelNumString = levelNum as string

	if levelNum < 10 then levelNumString = "0"+levelNumString
	
	local LevelLayerName = "sys_level_"+(levelNumString)
	local LevelPedLayerName = LevelLayerName + "_ped"
	local LevelPowerupLayerName = LevelLayerName + "_powerups"
	local LevelPathsLayerName = "sys_LevelRoutes_" + levelNumString

	
	local raceInfoNull = CreateNewNULLNode (matrix3 1) ("sys_RaceInfo_"+levelNumString) addAttributes:true nodeType:"IGNORE"
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

	(layerManager.getLayerFromName LevelLayerName).current = true

	
	local levelModifier = raceInfoNull.modifiers["Funsize Level Settings"] 
	local levelInfoModifier = raceInfoNull.modifiers["Funsize Level Info"] 

	if levelModifier == undefined then (
		levelModifier = AddFunsizeLevelAttributes raceInfoNull
	)

	if levelInfoModifier == undefined then (
		levelInfoModifier = AddFunsizeLevelInfoAttributes raceInfoNull
	)

	levelInfoModifier.LevelRaceNum = levelNum
	levelModifier.LevelFileName = "level_"+(levelNumString)+".txt"
	levelModifier.LevelLayerName = LevelLayerName
	levelModifier.LevelPedLayerName = LevelPedLayerName
	levelModifier.LevelPowerupLayerName = LevelPowerupLayerName
	levelModifier.LevelPathsLayerName = LevelPathsLayerName
	levelModifier.AIPath = "paths_"+(levelNumString)+".txt"
)

fn SetFunsizeLevelSettingsFromTXT levelRoot levelTxt careersTxt textXml folderName levelNum = (
	local levelModifier = levelRoot.modifiers["Funsize Level Settings"] 
	local levelInfoModifier = levelRoot.modifiers["Funsize Level Info"] 

	if levelModifier == undefined then (
		levelModifier = AddFunsizeLevelAttributes levelRoot
	)

	if levelInfoModifier == undefined then (
		levelInfoModifier = AddFunsizeLevelInfoAttributes levelRoot
	)

	local levelNumString = (levelNum as string)

	if levelNum < 10 then levelNumString = "0"+levelNumString
	local levelCareerInfo = careersTxt.FindLevel folderName ("level_"+levelNumString+".txt")

	if levelCareerInfo != undefined then (
		levelInfoModifier.LevelCareerNum = careersTxt.Items.IndexOf levelCareerInfo
		levelInfoModifier.LevelRaceNum = levelNum
		local levelNameKey = (toupper folderName) + "_" + levelNumString
		local levelDescriptionKey = "CM_TEXT_1_"+(levelInfoModifier.LevelCareerNum as string)
		local levelEnvironmentKey = (toupper folderName) + "_LOCATION"
		--levelInfoModifier.LevelNameKey = levelCareerInfo.LevelNameKey
		--levelInfoModifier.LevelDescriptionKey = levelCareerInfo.LevelDescriptionKey
		--levelInfoModifier.LevelEnvironmentKey = levelCareerInfo.EnvironmentNameKey
		--levelInfoModifier.LevelText3Key = levelCareerInfo.LocalisationTextKey4
		if textXml.KeyExists levelCareerInfo.LevelNameKey then (
			levelInfoModifier.LevelName = textXml.GetText levelCareerInfo.LevelNameKey
		)
		if textXml.KeyExists levelCareerInfo.LevelDescriptionKey then (
			levelInfoModifier.LevelDescription = textXml.GetText levelCareerInfo.LevelDescriptionKey
		)
		if textXml.KeyExists levelCareerInfo.EnvironmentNameKey then (
			levelInfoModifier.LevelEnvironment = textXml.GetText levelCareerInfo.EnvironmentNameKey
		)
		if textXml.KeyExists levelCareerInfo.LocalisationTextKey4 then (
			levelInfoModifier.LevelText3 = textXml.GetText levelCareerInfo.LocalisationTextKey4
		)

		levelInfoModifier.TrackUnlock = levelCareerInfo.TrackUnlock
		levelInfoModifier.VehicleUnlock = levelCareerInfo.VehicleUnlock
		levelInfoModifier.EventUnlock = levelCareerInfo.EventUnlock
		levelInfoModifier.SpecialCode = levelCareerInfo.SpecialCode

		levelInfoModifier.RaceType = levelCareerInfo.GameMode
		levelInfoModifier.LapLength = levelCareerInfo.LapLength
		levelInfoModifier.PedCount = levelCareerInfo.NumPeds
		levelInfoModifier.Laps = levelCareerInfo.Laps

		levelInfoModifier.AISkill = levelCareerInfo.AISkill
		levelInfoModifier.AICars = levelCareerInfo.AICars
		levelInfoModifier.NumAI = levelCareerInfo.NumAI
		levelInfoModifier.Boss = levelCareerInfo.Boss

		levelInfoModifier.RequiredCredits = levelCareerInfo.RequiredCredits

		levelInfoModifier.WinBonusLaps_Easy = levelCareerInfo.WinBonusLaps.Easy
		levelInfoModifier.WinBonusLaps_Medium = levelCareerInfo.WinBonusLaps.Medium
		levelInfoModifier.WinBonusLaps_Hard = levelCareerInfo.WinBonusLaps.Hard

		levelInfoModifier.WinBonusPeds_Easy = levelCareerInfo.WinBonusPeds.Easy
		levelInfoModifier.WinBonusPeds_Medium = levelCareerInfo.WinBonusPeds.Medium
		levelInfoModifier.WinBonusPeds_Hard = levelCareerInfo.WinBonusPeds.Hard

		levelInfoModifier.WinBonusWasted_Easy = levelCareerInfo.WinBonusWasted.Easy
		levelInfoModifier.WinBonusWasted_Medium = levelCareerInfo.WinBonusWasted.Medium
		levelInfoModifier.WinBonusWasted_Hard = levelCareerInfo.WinBonusWasted.Hard

		levelInfoModifier.StartTime_Easy = levelCareerInfo.StartTime.Easy
		levelInfoModifier.StartTime_Medium = levelCareerInfo.StartTime.Medium
		levelInfoModifier.StartTime_Hard = levelCareerInfo.StartTime.Hard


	)

	levelModifier.LevelFolderName = folderName
	levelModifier.LevelFileName = "level_"+(levelNumString)+".txt"
	levelModifier.LevelLayerName = "sys_level_"+(levelNumString)
	levelModifier.LevelPedLayerName = levelModifier.LevelLayerName + "_ped"
	levelModifier.LevelPowerupLayerName = levelModifier.LevelLayerName + "_powerups"
	levelModifier.LevelPathsLayerName ="sys_LevelRoutes_"+levelNumString

	levelModifier.LevelName = FunsizeGetValueFromXml (folderName+"_"+levelNumString)
	if levelTxt.Environment != undefined then (
		levelModifier.Environment = levelTxt.Environment
	)
	if levelTxt.EnvironmentMap != undefined then (
		levelModifier.EnvironmentMap = levelTxt.EnvironmentMap
	)
	if levelTxt.ShadowStrength != undefined then (
		levelModifier.ShadowStrength = color (levelTxt.ShadowStrength.X * 255) (levelTxt.ShadowStrength.Y * 255) (levelTxt.ShadowStrength.Z * 255)
	)
	if levelTxt.Map != undefined then (
		levelModifier.MapName = levelTxt.Map.Name
		levelModifier.MapSize = point3 levelTxt.Map.Size.X levelTxt.Map.Size.Y 0
		levelModifier.MapCenter = point3 levelTxt.Map.Center.X levelTxt.Map.Center.Y 0
	)
	if levelTxt.BigMap != undefined then (
		levelModifier.BigMap = levelTxt.BigMap
	)

	local gridHelper = PlaceGridHelper (ConvertFromCRSpace (ToxicRagersVector3ToMaxPoint3 levelTxt.Grid.Position)) levelTxt.Grid.Orientation

	levelModifier.GridHelper =  nodeTransformMonitor node:gridHelper forwardTransformChangeMsgs:false

	levelModifier.MapMatrix = ToxicRagersMatrix3DToMaxMatrix3 levelTxt.MapMatrix
	levelModifier.FogColour = ToxicRagersColourToMaxColor levelTxt.Fog
	levelModifier.LightingColour = ToxicRagersColourToMaxColor levelTxt.Lighting
	levelModifier.Headlights = levelTxt.Headlights == true
	if levelTxt.Splash != undefined then (
		levelModifier.Splash = levelTxt.Splash
	)
	if levelTxt.AutoRecoverHeight != undefined then (
		levelModifier.AutoRecoverHeightEnabled = true
		levelModifier.AutoRecoverHeight = levelTxt.AutoRecoverHeight
	)
	levelModifier.Viz = levelTxt.Viz
	levelModifier.AIPath = levelTxt.AIPath

	for i = 0 to (levelTxt.SmokeColours.count - 1) do
	(
		local smokeColour = levelTxt.SmokeColours.item[i]
		append levelModifier.SmokeColours (ToxicRagersColourToMaxColor smokeColour)
	)
	levelModifier.MatMods = ""
	for i = 0 to (levelTxt.MatMods.count - 1) do
	(
		local matmod = levelTxt.MatMods.item[i]
		local matModString = (matMod.WallFriction as string) + ";" + (matMod.TyreFriction as string) + ";" + (matMod.DownForce as string) + ";" + (matMod.Bumpiness as string) + ";" + (matMod.TyreSound as string) + ";" + (matMod.CrashSound as string) + ";" + (matMod.ScrapeSound as string) + ";" + (matMod.Sparks as string) + ";" + (matMod.SmokeType as string)
		if levelModifier.MatMods.count > 0 then (
			levelModifier.MatMods = levelModifier.MatMods + ":"
		)
		levelModifier.MatMods = levelModifier.MatMods + matModString
	)

	levelModifier
)

fn SetFunsizeLevelTXTFromModifier levelRoot careersTxt textXml levelNum = (
	local levelModifier = levelRoot.modifiers["Funsize Level Settings"] 
	local levelInfoModifier = levelRoot.modifiers["Funsize Level Info"] 

	local levelNumString = (levelInfoModifier.LevelRaceNum as string)
	local careerLevelNum = levelInfoModifier.LevelCareerNum

	if levelInfoModifier.LevelRaceNum < 10 then levelNumString = "0"+levelNumString

	-- TODO: Use an index to find the race to replace?
	local levelCareerInfo = careersTxt.FindLevel folderName ("level_"+levelNumString+".txt")

	if levelCareerInfo == undefined then
	(
		levelCareerInfo = dotNetObject "ToxicRagers.CarmageddonMobile.Formats.CareerModeTextItem"
		careersTxt.Items.insert (careerLevelNum - 1) levelCareerInfo
	)
	else if (careersTxt.Items.IndexOf levelCareerInfo) != (careerLevelNum - 1) then
	(
		careersTxt.Items.remove levelCareerInfo
		careersTxt.Items.insert (careerLevelNum - 1) levelCareerInfo
	)

	if levelCareerInfo != undefined then (
		levelCareerInfo.LevelNameKey = levelInfoModifier.LevelNameKey
		levelCareerInfo.LevelDescriptionKey = levelInfoModifier.LevelDescriptionKey
		levelCareerInfo.EnvironmentNameKey = levelInfoModifier.LevelEnvironmentKey
		levelCareerInfo.LocalisationTextKey4 = levelInfoModifier.LevelText3Key
		
		textXml.SetText levelCareerInfo.LevelNameKey levelInfoModifier.LevelName
		textXml.SetText levelCareerInfo.LevelDescriptionKey levelInfoModifier.LevelDescription 
		textXml.SetText levelCareerInfo.EnvironmentNameKey levelInfoModifier.LevelEnvironment
		textXml.SetText levelCareerInfo.LocalisationTextKey4 levelInfoModifier.LevelText3
		

		levelCareerInfo.TrackUnlock = levelInfoModifier.TrackUnlock
		levelCareerInfo.VehicleUnlock = levelInfoModifier.VehicleUnlock
		levelCareerInfo.EventUnlock = levelInfoModifier.EventUnlock
		levelCareerInfo.SpecialCode = levelInfoModifier.SpecialCode

		levelCareerInfo.GameMode = levelInfoModifier.RaceType
		levelCareerInfo.LapLength = levelInfoModifier.LapLength
		levelCareerInfo.NumPeds = levelInfoModifier.PedCount
		levelCareerInfo.Laps = levelInfoModifier.Laps

		levelCareerInfo.AISkill = levelInfoModifier.AISkill
		levelCareerInfo.AICars = levelInfoModifier.AICars
		levelCareerInfo.NumAI = levelInfoModifier.NumAI
		levelCareerInfo.Boss = levelInfoModifier.Boss

		levelCareerInfo.RequiredCredits = levelInfoModifier.RequiredCredits

		levelCareerInfo.WinBonusLaps.Easy = levelInfoModifier.WinBonusLaps_Easy
		levelCareerInfo.WinBonusLaps.Medium = levelInfoModifier.WinBonusLaps_Medium
		levelCareerInfo.WinBonusLaps.Hard = levelInfoModifier.WinBonusLaps_Hard

		levelCareerInfo.WinBonusPeds.Easy = levelInfoModifier.WinBonusPeds_Easy
		levelCareerInfo.WinBonusPeds.Medium = levelInfoModifier.WinBonusPeds_Medium
		levelCareerInfo.WinBonusPeds.Hard = levelInfoModifier.WinBonusPeds_Hard

		levelCareerInfo.WinBonusWasted.Easy = levelInfoModifier.WinBonusWasted_Easy
		levelCareerInfo.WinBonusWasted.Medium = levelInfoModifier.WinBonusWasted_Medium
		levelCareerInfo.WinBonusWasted.Hard = levelInfoModifier.WinBonusWasted_Hard

		levelCareerInfo.StartTime.Easy = levelInfoModifier.StartTime_Easy
		levelCareerInfo.StartTime.Medium = levelInfoModifier.StartTime_Medium
		levelCareerInfo.StartTime.Hard = levelInfoModifier.StartTime_Hard


	)

	folderName = levelModifier.LevelFolderName
	/*
	levelModifier.LevelFileName = "level_"+(levelNumString)+".txt"
	levelModifier.LevelLayerName = "sys_level_"+(levelNumString)
	levelModifier.LevelPedLayerName = levelModifier.LevelLayerName + "_ped"
	levelModifier.LevelPowerupLayerName = levelModifier.LevelLayerName + "_powerups"
	levelModifier.LevelPathsLayerName = levelModifier.LevelLayerName + "_paths"
*/
	--levelModifier.LevelName = FunsizeGetValueFromXml (folderName+"_"+levelNumString)
	if levelModifier.Environment != undefined then (
		levelTxt.Environment = levelModifier.Environment
	)
	if levelModifier.EnvironmentMap != undefined then (
		levelTxt.EnvironmentMap = levelModifier.EnvironmentMap
	)
	if levelModifier.ShadowStrength != undefined then (
		levelTxt.ShadowStrength = MaxColorToToxicRagersColour levelModifier.ShadowStrength
		--levelModifier.ShadowStrength = color (levelTxt.ShadowStrength.X * 255) (levelTxt.ShadowStrength.Y * 255) (levelTxt.ShadowStrength.Z * 255)
	)
	if levelModifier.Map != undefined then (
		levelTxt.Map.Name = levelModifier.MapName
		levelTxt.Map.Size = (dotnetObject "ToxicRagers.Helpers.Vector3" levelModifier.MapSize.x levelModifier.MapSize.y 0)
		levelTxt.Map.Center = (dotnetObject "ToxicRagers.Helpers.Vector3" levelModifier.MapCenter.x levelModifier.MapCenter.y 0)
		--levelModifier.MapSize = point3 levelTxt.Map.Size.X levelTxt.Map.Size.Y 0
		--levelModifier.MapCenter = point3 levelTxt.Map.Center.X levelTxt.Map.Center.Y 0
	)
	if levelModifier.BigMap != undefined then (
		levelTxt.BigMap = levelModifier.BigMap
	)

	local gridHelper = PlaceGridHelper (ConvertFromCRSpace (ToxicRagersVector3ToMaxPoint3 levelTxt.Grid.Position)) levelTxt.Grid.Orientation

	--levelModifier.GridHelper =  nodeTransformMonitor node:gridHelper forwardTransformChangeMsgs:false

	levelTxt.MapMatrix = MaxMatrix3ToxicRagersMatrix3D levelModifier.MapMatrix 
	levelTxt.Fog = MaxColorToToxicRagersColour levelModifier.FogColour
	levelTxt.Lighting = MaxColorToToxicRagersColour levelModifier.LightingColour
	levelTxt.Headlights = levelModifier.Headlights == true
	if levelModifier.Splash != undefined then (
		levelTxt.Splash = levelModifier.Splash
	)
	if levelModifier.AutoRecoverHeightEnabled then (
		levelTxt.AutoRecoverHeight = levelModifier.AutoRecoverHeight
	)
	levelTxt.Viz = levelModifier.Viz
	levelTxt.AIPath = levelModifier.AIPath

	for i = 1 to (levelModifier.SmokeColours.length) do
	(
		local smokeColour = levelModifier.SmokeColours[i]
		levelTxt.SmokeColours.Add (ToxicRagersColourToMaxColor smokeColour)
	)
	
	local matMods = FilterString levelModifier.MatMods ":"
	for i = 1 to matMods.count do
	(
		local matmodinfo = FilterString matMods[i] ";"
		local matmod = dotNetObject "ToxicRagers.CarmageddonMobile.Formats.MatMod"
		
		matMod.WallFriction = matmodinfo[1] as float
		matMod.TyreFriction = matmodinfo[2] as float
		matMod.DownForce = matmodinfo[3] as float
		matMod.Bumpiness = matmodinfo[4] as float
		matMod.TyreSound = matmodinfo[5] as integer 
		matMod.CrashSound = matmodinfo[6] as integer
		matMod.ScrapeSound = matmodinfo[7] as integer
		matMod.Sparks = matmodinfo[8] as float
		matMod.SmokeType = matmodinfo[9] as float
		
		levelTxt.MatMods.Add matMod
	)

	levelTxt
)
