fn PlaceGridHelper location orientation = (
	local gridMeshPath = (dotnetclass "System.IO.Path").Combine (getFileNamePath (getThisScriptFilename())) "MDLs" "grid" "grid.cnt"

	local gridHelper = QuickImportCnt gridMeshPath mergeMdls:true
	gridHelper.rotation = EulerAngles 0 0 orientation
	gridHelper.position = location
	SetCNTNodeType gridHelper "IGNORE"
	gridHelper.name = "GRID_HELPER"
	gridHelper
)

fn PlaceCopHelper copType location = (
	local copMeshPath = (dotnetclass "System.IO.Path").Combine (getFileNamePath (getThisScriptFilename())) "MDLs\\cops" copType "carbody.cnt"


	local copHelper = QuickImportCnt copMeshPath mergeMdls:true
	format "CopHelper has % children\n" copHelper.children.count

	copHelper.position = location
	
	SetCNTNodeType copHelper "IGNORE"
	copHelper.name = "COP_HELPER"

	local copMod = AddFunsizeCopAttributes copHelper
	copMod.CopType = copType
	copHelper
)

fn PlaceAccessory trans accessoryName instanceName instanceColour = (

	local accNull = CreateNewNULLNode trans "instanceName" addAttributes:true nodeType:"IGNORE"
	local accMod = AddFunsizeAccessoryItemAttributes accNull

	accMod.InstanceColour = instanceColour
	if instanceName != undefined then (
		accMod.InstanceName = instanceName
	)
	accMod.AccessoryType = accessoryName

	ReplaceWithFunsizeAccessory accessoryName accNull

)


fn SetFunsizeLevelSettingsFromTXT levelRoot levelTxt folderName levelNum = (
	local levelModifier = levelRoot.modifiers["Funsize Level"] 

	if levelModifier == undefined then (
		levelModifier = AddFunsizeLevelAttributes levelRoot
	)

	local levelNumString = (levelNum as string)

	if levelNum < 10 then levelNumString = "0"+levelNumString

	levelModifier.LevelFolderName = folderName
	levelModifier.LevelFileName = "level_"+(levelNumString)+".txt"
	levelModifier.LevelLayerName = "sys_level_"+(levelNumString)
	levelModifier.LevelPedLayerName = levelModifier.LevelLayerName + "_ped"
	levelModifier.LevelPowerupLayerName = levelModifier.LevelLayerName + "_powerups"

	levelModifier.LevelName = FunsizeGetValueFromXml (folderName+"_"+levelNumString)
	levelModifier.Environment = levelTxt.Environment
	levelModifier.EnvironmentMap = levelTxt.EnvironmentMap
	levelModifier.ShadowStrength = color (levelTxt.ShadowStrength.X * 255) (levelTxt.ShadowStrength.Y * 255) (levelTxt.ShadowStrength.Z * 255)
	levelModifier.MapName = levelTxt.Map.Name
	levelModifier.MapSize = point3 levelTxt.Map.Size.X levelTxt.Map.Size.Y 0
	levelModifier.MapCenter = point3 levelTxt.Map.Center.X levelTxt.Map.Center.Y 0
	levelModifier.BigMap = levelTxt.BigMap

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
