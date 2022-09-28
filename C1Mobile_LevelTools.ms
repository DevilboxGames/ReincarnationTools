fn PlaceGridHelper location orientation = (
	local gridMeshPath = (dotnetclass "System.IO.Path").Combine #((getFileNamePath (getThisScriptFilename())), "MDLs", "grid", "grid.cnt")

	local gridHelper = QuickImportCnt gridMeshPath mergeMdls:true
	gridHelper.rotation = EulerAngles 0 0 -(orientation - 90)
	gridHelper.position = location
	SetCNTNodeType gridHelper "IGNORE"
	gridHelper.name = "GRID_HELPER"
	gridHelper
)

fn PlacePowerup trans pupNames respawnTime = (
	local pupMeshPath = (dotnetclass "System.IO.Path").Combine #((getFileNamePath (getThisScriptFilename())), "MDLs\\pup", "pup.cnt")


	local pupHelper = QuickImportCnt pupMeshPath mergeMdls:true
	

	pupHelper.transform = trans
	
	SetCNTNodeType pupHelper "IGNORE"
	pupHelper.name = "pup_HELPER_" + pupNames[1]

	local pupMod = AddFunsizePowerupItemAttributes pupHelper
	pupMod.PowerupTypes = pupNames
	pupMod.RespawnTime = respawnTime
	pupHelper
)

fn PlaceCopHelper copType location = (
	local copMeshPath = (dotnetclass "System.IO.Path").Combine #((getFileNamePath (getThisScriptFilename())), "MDLs\\cops", copType, "carbody.cnt")


	local copHelper = QuickImportCnt copMeshPath mergeMdls:true
	

	copHelper.position = location
	
	SetCNTNodeType copHelper "IGNORE"
	copHelper.name = "COP_HELPER"

	local copMod = AddFunsizeCopAttributes copHelper
	copMod.CopType = copType
	copHelper
)

fn PlacePed pedType pedPoints firstPoint = (

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
	pedMod.InitialPoint = firstPoint

	local pedNull = CreateNewNULLNode (matrix3 1) (pedType as string) addAttributes:true nodeType:"IGNORE"
	pedNull.pos = pedPoints[1]
	pedSpline.parent = pedNull
	pedNull
)

fn PlaceAccessory trans accessoryName instanceName instanceColour = (

	local accNull = CreateNewNULLNode trans (instanceName as string) addAttributes:true nodeType:"IGNORE"
	local accMod = AddFunsizeAccessoryItemAttributes accNull

	accMod.InstanceColour = instanceColour
	if instanceName != undefined then (
		accMod.InstanceName = instanceName
	)
	accMod.AccessoryType = accessoryName

	ReplaceWithFunsizeAccessory accessoryName accNull

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
		levelInfoModifier.LevelNameKey = levelCareerInfo.LevelNameKey
		levelInfoModifier.LevelDescriptionKey = levelCareerInfo.LevelDescriptionKey
		levelInfoModifier.LevelEnvironmentKey = levelCareerInfo.EnvironmentNameKey
		levelInfoModifier.LevelText3Key = levelCareerInfo.LocalisationTextKey4
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
	levelModifier.LevelPathsLayerName = levelModifier.LevelLayerName + "_paths"

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
