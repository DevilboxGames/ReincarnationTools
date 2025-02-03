fn ExportFunsizeLevelTXT levelRoot filename  = (
	global CarmaSettings

	local FunsizeDataPath = CarmaSettings.FunsizeSettings.DataFolder

	local pathClass = (dotnetclass "System.IO.Path")
	local levelTxt = (dotnetObject "ToxicRagers.CarmageddonMobile.Formats.Level")

	local exportTextures = CarmaSettings.ExportSettings.ExportTextures
	local exportMaterials = CarmaSettings.ExportSettings.ExportMaterials
	
	
	local levelFolder = pathClass.GetDirectoryName filename

	
	local levelFolder = levelModifier.LevelFolderName
	local levelNumString = (levelInfoModifier.LevelRaceNum as string)
	
	if levelInfoModifier.LevelRaceNum < 10 then levelNumString = "0"+levelNumString

	local LevelLayerName = "sys_level_"+(levelNumString)
	local LevelPedLayerName = LevelLayerName + "_ped"
	local LevelPowerupLayerName = LevelLayerName + "_powerups"
	local LevelPathsLayerName = LevelLayerName + "_paths"

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

	local levelCntPath = pathClass.Combine levelFolder "level.cnt"
	local lightCntPath = pathClass.Combine levelFolder "light.cnt"
	local levelModifier = levelRoot.modifiers["Funsize Level Settings"] 
	local levelInfoModifier = levelRoot.modifiers["Funsize Level Info"] 
/*
	if (doesFileExist lightCntPath) then (
		local lightRoot = ImportCNT lightCntPath importTextures:importTextures forcePREP:forcePREP useTriStrips:useTriStrips mergeMDLs:false mergeSplits:mergeSplits  SpawnOctree:SpawnOctree
		local lightNull = CreateNewNULLNode lightRoot.transform "light.cnt" addAttributes:true nodeType:"CNT"
		lightNull.modifiers["CNT Hierarchy"].FileName = "light.cnt"
		lightRoot.parent = lightNull
	)*/

	local currentLayer = layerManager.current

	--(layerManager.getLayerFromName LevelLayerName).current = true
	local racingIndex = (filterstring (pathClass.GetFileNameWithoutExtension fileName) "_")[2] as integer
	SetFunsizeLevelSettingsFromTXT levelRoot levelTxt careersTxt textXml (GetFolderName FileName) racingIndex

	for i = 0 to levelTxt.Accessories.count - 1 do (
		local accData = levelTxt.Accessories.item[i]
		local accTransform = ConvertMatrixFromCRSpace (ToxicRagersMatrix3DToMaxMatrix3 accData.Transform)
		PlaceMobileAccessory accTransform accData.Name accData.InstanceName (ToxicRagersColourToMaxColor accData.InstanceColour)
	)

	for i = 0 to levelTxt.Cops.count - 1 do (
		local copData = levelTxt.Cops.item[i]
		local copType = copData.Type.ToString()
		local copPos = (ConvertCopFromFunsize (ToxicRagersVector3ToMaxPoint3 copData.Position)) 
		PlaceCopHelper copType copPos
	)

	--(layerManager.getLayerFromName LevelPedLayerName).current = true

	for i = 0 to levelTxt.Peds.count - 1 do (
		local pedData = levelTxt.Peds.item[i]
		local pedPoints = #()
		for i = 0 to pedData.Paths.count - 1 do (
			local pathPoint = ConvertFromCRSpace (ToxicRagersVector3ToMaxPoint3 pedData.Paths.item[i])
			append pedPoints pathPoint
		)
		PlacePed pedData.PedType pedPoints pedData.LoopCount
	)

	--(layerManager.getLayerFromName LevelPowerupLayerName).current = true

	for i = 0 to levelTxt.Powerups.count - 1 do (
		local pupDef = levelTxt.Powerups.item[i]
		local pupTrans = ConvertMatrixFromCRSpace (ToxicRagersMatrix3DToMaxMatrix3 pupDef.Transform)
		local pupTypes = #()
		for p = 0 to pupDef.PowerupNames.count - 1 do (
			append pupTypes pupDef.PowerupNames.item[p]
		)

		PlacePowerup pupTrans pupTypes pupDef.RespawnTime
	)
	--(layerManager.getLayerFromName LevelPathsLayerName).current = true

	ParseLevelRoutesTXT ((dotnetclass "System.IO.Path").Combine #((getFileNamePath filename), ("paths_"+levelNumString+".txt")))

	--currentLayer.current = true

)

fn Funsize_AddLeveltoXML levelInfoModifier = (
	local FunsizeDataPath = CarmaSettings.FunsizeSettings.DataFolder
	local xmlPath = pathClass.Combine #(FunsizeDataPath, "Data", "Content","Text", "Text.xml")
	local textXml = (dotnetobject "ToxicRagers.CarmageddonMobile.Formats.TextXml" xmlPath)

	textXml.SetText levelCareerInfo.LevelNameKey levelInfoModifier.LevelName
	textXml.SetText levelCareerInfo.LevelDescriptionKey levelInfoModifier.LevelDescription 
	textXml.SetText levelCareerInfo.EnvironmentNameKey levelInfoModifier.LevelEnvironment
	textXml.SetText levelCareerInfo.LocalisationTextKey4 levelInfoModifier.LevelText3

	textXml.Save xmlPath
)

fn Funsize_UpdateCareersTXT levelModifier levelInfoModifier = (

	
	local levelFolder = levelModifier.LevelFolderName
	local levelNumString = (levelInfoModifier.LevelRaceNum as string)
	
	if levelInfoModifier.LevelRaceNum < 10 then levelNumString = "0"+levelNumString

	local careersTxtPath = pathClass.Combine #(FunsizeDataPath, "Data", "Content", "careermode.txt")
	local careersTxt = (dotnetclass "ToxicRagers.CarmageddonMobile.Formats.CareerModeTxt").Load careersTxtPath
	local levelCareerInfo = careersTxt.FindLevel folderName ("level_"+levelNumString+".txt")

	if levelCareerInfo == undefined then
	(
		levelCareerInfo = dotNetObject "ToxicRages.CarmageddonMobile.Formats.CareerModeTextItem"
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

	careersTxt.Save careersTxtPath

)

fn Funsize_CollectAccessoriesForLevelTxt levelModifier levelTxt = (

	
	local levelFolder = levelModifier.LevelFolderName
	local levelNumString = (levelInfoModifier.LevelRaceNum as string)
	
	if levelInfoModifier.LevelRaceNum < 10 then levelNumString = "0"+levelNumString
	local LevelLayerName = "sys_level_"+(levelNumString)
	local LevelPedLayerName = LevelLayerName + "_ped"
	local LevelPowerupLayerName = LevelLayerName + "_powerups"
	local LevelPathsLayerName = LevelLayerName + "_paths"

	local accessoryNodes
	local pedNodes
	local powerupNodes
	local pathNodes

	(LayerManager.getLayerFromName LevelLayerName).nodes &accessoryNodes
	(LayerManager.getLayerFromName LevelPedLayerName).nodes &pedNodes
	(LayerManager.getLayerFromName LevelPowerupLayerName).nodes &powerupNodes
	(LayerManager.getLayerFromName LevelPathsLayerName).nodes &pathNodes

	for accessoryNode in accessoryNodes do (
		local accModifier = accessoryNode.Modifiers["Funsize Accessory"]
		local accTransform = MaxMatrix3ToToxicRagersMatrix3D (ConvertMatrixToCRSpace accData.Transform)
		local accData = dotnetObject "ToxicRages.CarmageddonMobile.Formats.AccessoryDef"
		accData.Name = accModifier.AccessoryType
		accData.InstanceName = accModifier.InstanceName
		accData.InstanceColour = MaxColorToToxicRagesColour accModifier.InstanceColo
		
		levelTxt.Accessories.Add accData
	)


)

fn Funsize_ExportLevelTxt levelModifier = (
	

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



	levelTxt.Save
)

fn ExportFunsizeLevel levelRoot nolaunch: false onlyAllowCars: = (
	global CarmaSettings
	FunsizeDataPath = CarmaSettings.FunsizeSettings.DataFolder
	--for mat in scenematerials do format "%: %\n" mat.name (classof mat)
	ApplyMTLToAllMatsInScene OnlyWithDiffuse:false OnlyProperlyNamed:true
	
	Funsize_ExportHUDScript FunsizeDataPath carModifier.carname carRoot.Modifiers["Funsize HUD Damage"]
	Funsize_UpdateCarSpecs FunsizeDataPath carModifier.carname carModifier
	Funsize_QuickRaceCars FunsizeDataPath carModifier.carname carModifier onlyAllowCars: onlyAllowCars
	Funsize_ExportCarTXTFile (FunsizeDataPath+"Data\\Content\\Vehicles\\" + carModifier.carname + "\\car.txt") carRoot
	local levelModifier = levelRoot.modifiers["Funsize Level Settings"] 
	local levelInfoModifier = levelRoot.modifiers["Funsize Level Info"] 

	Funsize_AddLeveltoXML levelInfoModifier
	Funsize_UpdateCareersTXT levelModifier levelInfoModifier

	levelFolder = (FunsizeDataPath+"Data\\Content\\Tracks\\Levels\\" + levelModifier.LevelFolderName + "\\")

	global MaterialsToExport
	MaterialsToExport=#()
	ExportMDL carFolder false true exportMats:true exportTextures:true funsizeExport:true createOctree:true nodes:#(levelRoot)
	ExportCNT (carFolder+"level.cnt") levelRoot
	--for mat in MaterialsToExport do format "%, %\n" mat[2].name mat[2].mat_flags
	ExportMaterialsAndTextures carFolder exportMats:true exportTextures:true funsizeExport:true createOctree:false
	RenderMobileUIAssets carModifier.CarName FunsizeDataPath
	

	if CarmaSettings.FunsizeSettings.AutoBuild and nolaunch == false then (
		PackObb()
	)
)
